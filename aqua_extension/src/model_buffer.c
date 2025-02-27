#include "model_buffer.h"

WeightPool *
create_weight_pool(void)
{
    WeightPool *pool;
    HASHCTL info;
    MemoryContext old_context;

    // 创建一个新的内存上下文，限制大小为 512MB
    MemoryContext pool_context = AllocSetContextCreate(TopMemoryContext,
                                                       "WeightPoolContext",
                                                       POOL_SIZE,
                                                       POOL_SIZE,
                                                       POOL_SIZE);

    old_context = MemoryContextSwitchTo(pool_context);

    pool = (WeightPool *)palloc(sizeof(WeightPool));
    pool->context = pool_context;

    memset(&info, 0, sizeof(info));
    info.keysize = NAMEDATALEN;
    info.entrysize = sizeof(WeightEntry);
    info.hash = string_hash;

    pool->entries = hash_create("WeightPool",
                                512,
                                &info,
                                HASH_ELEM | HASH_FUNCTION);

    pool->weight_cache = create_lru_cache(32, pool_context);
    pool->current_memory_usage = LRU_CACHE_SIZE;
    MemoryContextSwitchTo(old_context);

    return pool;
}

bool insert_weight(WeightPool *pool, const char *name, void *data, size_t data_size,
                   int16 ndims, int *dims, Oid element_type)
{
    WeightEntry *entry;
    bool found;
    MemoryContext old_context;

    if (pool->current_memory_usage + data_size > POOL_SIZE)
    {
        ereport(ERROR,
                (errcode(ERRCODE_OUT_OF_MEMORY),
                 errmsg("weight pool memory limit exceeded")));
        return false;
    }

    old_context = MemoryContextSwitchTo(pool->context);
    entry = (WeightEntry *)hash_search(pool->entries, name, HASH_ENTER, &found);
    if (found)
    {
        if (entry->data)
        {
            pool->current_memory_usage -= entry->data_size;
            pfree(entry->data);
        }
    }

    strlcpy(entry->name, name, NAMEDATALEN);
    entry->data = palloc(data_size);
    memcpy(entry->data, data, data_size);
    entry->data_size = data_size;
    entry->ndims = ndims;
    memcpy(entry->dims, dims, sizeof(int) * ndims);
    entry->element_type = element_type;
    pool->current_memory_usage += data_size;

    MemoryContextSwitchTo(old_context);

    // elog(INFO, "[insert weight] find %d", found);
    // entry = get_weight(pool, name);
    return true;
}

WeightEntry *get_weight(WeightPool *pool, const char *weight_name)
{
    // elog(INFO, "[get_weight] %s", weight_name);
    MemoryContext old_context;
    WeightEntry *entry = NULL;
    bool found;
    if (!pool)
    {
        elog(ERROR, "[get_weight] pool is NULL");
        return NULL;
    }

    old_context = MemoryContextSwitchTo(pool->context);
    entry = (WeightEntry *)hash_search(pool->entries, weight_name, HASH_FIND, &found);
    if (!found)
    {
        elog(INFO, "[get_weight] not found");
        return NULL;
    }
    // entry = get_lru_cache(pool->weight_cache, weight_name);
    // if (entry == NULL)
    // {
    //     // elog(INFO, "[get_weight] lru cache not found");
    //     entry = (WeightEntry *)hash_search(pool->entries, weight_name, HASH_FIND, &found);
    //     if (!found)
    //     {
    //         elog(INFO, "[get_weight] not found");
    //         return NULL;
    //     }
    //     put_lru_cache(pool->weight_cache, weight_name, entry);
    // }
    // else
    // {
    //     // elog(INFO, "[get_weight] lru cache found");
    // }
    MemoryContextSwitchTo(old_context);
    return entry;
}

void destroy_weight_pool(WeightPool *pool)
{
    HASH_SEQ_STATUS status;
    WeightEntry *entry;

    hash_seq_init(&status, pool->entries);
    while ((entry = (WeightEntry *)hash_seq_search(&status)) != NULL)
    {
        if (entry->data)
        {
            pfree(entry->data);
        }
    }

    hash_destroy(pool->entries);

    if (pool->weight_cache != NULL)
    {
        destroy_lru_cache(pool->weight_cache);
    }

    MemoryContextDelete(pool->context);
    pfree(pool);
}

void lru_cache_move_to_head(LRUCache *cache, LRUCacheEntry *entry)
{
    if (entry == cache->head)
    {
        return;
    }

    // Remove from current position
    if (entry->prev)
    {
        entry->prev->next = entry->next;
    }
    if (entry->next)
    {
        entry->next->prev = entry->prev;
    }
    if (entry == cache->tail)
    {
        cache->tail = entry->prev;
    }

    // Insert at head
    entry->next = cache->head;
    entry->prev = NULL;
    if (cache->head)
    {
        cache->head->prev = entry;
    }
    cache->head = entry;
    if (!cache->tail)
    {
        cache->tail = entry;
    }
}

LRUCache *create_lru_cache(int capacity, MemoryContext context)
{
    MemoryContext old_context;
    LRUCache *cache;
    old_context = MemoryContextSwitchTo(context);

    // cache = (LRUCache *)MemoryContextAlloc(context, sizeof(LRUCache));
    cache = (LRUCache *)palloc(sizeof(LRUCache));
    cache->capacity = capacity;
    cache->size = 0;
    cache->head = NULL;
    cache->tail = NULL;
    cache->context = context;

    MemoryContextSwitchTo(old_context);
    return cache;
}

void put_lru_cache(LRUCache *cache, const char *name, WeightEntry *entry)
{
    MemoryContext old_context = MemoryContextSwitchTo(cache->context);
    LRUCacheEntry *current = cache->head;
    while (current != NULL)
    {
        if (strcmp(current->name, name) == 0)
        {
            current->entry = entry;
            lru_cache_move_to_head(cache, current);
            return;
        }
        current = current->next;
    }

    if (cache->size >= cache->capacity)
    {
        // Remove the least recently used entry
        LRUCacheEntry *tail = cache->tail;
        if (tail)
        {
            if (tail->prev)
            {
                tail->prev->next = NULL;
            }
            cache->tail = tail->prev;
            if (tail == cache->head)
            {
                cache->head = NULL;
            }
            pfree(tail);
            cache->size--;
        }
    }

    // Insert new entry
    LRUCacheEntry *new_entry = (LRUCacheEntry *)palloc(sizeof(LRUCacheEntry));
    strlcpy(new_entry->name, name, NAMEDATALEN);
    new_entry->entry = entry;
    new_entry->prev = NULL;
    new_entry->next = cache->head;

    if (cache->head)
    {
        cache->head->prev = new_entry;
    }
    cache->head = new_entry;

    if (!cache->tail)
    {
        cache->tail = new_entry;
    }

    cache->size++;
    MemoryContextSwitchTo(old_context);
}

WeightEntry *get_lru_cache(LRUCache *cache, const char *name)
{
    LRUCacheEntry *current = cache->head;
    while (current != NULL)
    {
        if (strcmp(current->name, name) == 0)
        {
            lru_cache_move_to_head(cache, current);
            return current->entry;
        }
        current = current->next;
    }
    return NULL;
}

void destroy_lru_cache(LRUCache *cache)
{
    LRUCacheEntry *current = cache->head;
    while (current != NULL)
    {
        LRUCacheEntry *next = current->next;
        pfree(current);
        current = next;
    }
    // MemoryContextDelete(cache->context);
    pfree(cache);
}

void print_all_keys(WeightPool *pool)
{
    HASH_SEQ_STATUS scan_status;
    WeightEntry *entry;

    // 初始化哈希表扫描
    hash_seq_init(&scan_status, pool->entries);

    // 遍历哈希表中的所有条目
    while ((entry = (WeightEntry *)hash_seq_search(&scan_status)) != NULL)
    {
        elog(INFO, "[print_all_keys] key: %s", entry->name);
    }
}
