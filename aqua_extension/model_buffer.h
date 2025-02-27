#ifndef MODEL_BUFFER_H
#define MODEL_BUFFER_H

#include "postgres.h"
#include "fmgr.h"
#include "utils/builtins.h"
#include "utils/hsearch.h"
#include "utils/array.h"
#include "utils/memutils.h"
#include "common/hashfn.h"
#include "catalog/pg_type.h"
#include "access/hash.h"
#include "fmgr.h"

#define MAX_DIMS 4
#define LRU_CACHE_SIZE (128 * 1024 * 1024)
#define POOL_SIZE (1024 * 1024 * 1024)

typedef struct WeightEntry
{
    char name[NAMEDATALEN];
    char *data;
    size_t data_size;
    int16 ndims;
    int dims[MAX_DIMS];
    Oid element_type;
} WeightEntry;

typedef struct LRUCacheEntry
{
    char name[NAMEDATALEN];
    WeightEntry *entry;
    struct LRUCacheEntry *prev;
    struct LRUCacheEntry *next;
} LRUCacheEntry;

typedef struct LRUCache
{
    LRUCacheEntry *head;
    LRUCacheEntry *tail;
    int capacity;
    int size;
    MemoryContext context;
} LRUCache;

typedef struct WeightPool
{
    HTAB *entries;
    MemoryContext context;
    Size current_memory_usage;
    LRUCache *weight_cache;
} WeightPool;

extern WeightPool *WEIGHT_POOL;
extern LRUCache *WEIGHT_CACHE;

WeightPool *create_weight_pool(void);
bool insert_weight(WeightPool *pool, const char *name, void *data, size_t data_size,
                   int16 ndims, int *dims, Oid element_type);
WeightEntry *get_weight(WeightPool *pool, const char *weight_name);
void destroy_weight_pool(WeightPool *pool);
void print_all_keys(WeightPool *pool);

void lru_cache_move_to_head(LRUCache *cache, LRUCacheEntry *entry);
LRUCache *create_lru_cache(int capacity, MemoryContext context);
void put_lru_cache(LRUCache *cache, const char *name, WeightEntry *entry);
WeightEntry *get_lru_cache(LRUCache *cache, const char *name);
void destroy_lru_cache(LRUCache *cache);

#endif // MODEL_BUFFER_H
