 CTE Scan on concat302_fwd0  (cost=1600024.02..1600024.74 rows=32 width=36) (actual time=659.357..724.582 ro
ws=32 loops=1)
   CTE input_feature_map
     ->  Seq Scan on cifar c  (cost=0.25..320001.57 rows=32 width=36) (actual time=0.253..3.580 rows=32 loop
s=1)
   CTE conv506_fwd0
     ->  Nested Loop  (cost=0.25..1280002.22 rows=32 width=36) (actual time=3.097..36.071 rows=32 loops=1)
           ->  Seq Scan on conv506_weight w  (cost=0.00..1.01 rows=1 width=810) (actual time=0.002..0.004 ro
ws=1 loops=1)
           ->  CTE Scan on input_feature_map i  (cost=0.00..0.64 rows=32 width=36) (actual time=0.407..4.586
 rows=32 loops=1)
   CTE averagepool293_fwd0
     ->  CTE Scan on conv506_fwd0 i_1  (cost=0.00..0.72 rows=32 width=36) (actual time=7.954..169.673 rows=3
2 loops=1)
   CTE conv507_fwd0
     ->  Nested Loop  (cost=0.00..2.05 rows=32 width=36) (actual time=0.808..22.398 rows=32 loops=1)
           ->  Seq Scan on conv507_weight w_1  (cost=0.00..1.01 rows=1 width=298) (actual time=0.011..0.013
rows=1 loops=1)
           ->  CTE Scan on conv506_fwd0 i_2  (cost=0.00..0.64 rows=32 width=36) (actual time=0.201..4.939 ro
ws=32 loops=1)
   CTE conv508_fwd0
     ->  Nested Loop  (cost=0.00..2.05 rows=32 width=36) (actual time=0.719..22.302 rows=32 loops=1)
           ->  Seq Scan on conv508_weight w_2  (cost=0.00..1.01 rows=1 width=234) (actual time=0.004..0.006
rows=1 loops=1)
           ->  CTE Scan on conv506_fwd0 i_3  (cost=0.00..0.64 rows=32 width=36) (actual time=0.142..5.682 ro
ws=32 loops=1)
   CTE conv509_fwd0
     ->  Nested Loop  (cost=0.00..2.05 rows=32 width=36) (actual time=0.773..23.937 rows=32 loops=1)
           ->  Seq Scan on conv509_weight w_3  (cost=0.00..1.01 rows=1 width=298) (actual time=0.004..0.006
rows=1 loops=1)
           ->  CTE Scan on conv506_fwd0 i_4  (cost=0.00..0.64 rows=32 width=36) (actual time=0.173..5.292 ro
ws=32 loops=1)
   CTE conv512_fwd0
     ->  Nested Loop  (cost=0.00..2.05 rows=32 width=36) (actual time=9.709..205.047 rows=32 loops=1)
           ->  Seq Scan on conv512_weight w_4  (cost=0.00..1.01 rows=1 width=170) (actual time=0.005..0.006
rows=1 loops=1)
           ->  CTE Scan on averagepool293_fwd0 i_5  (cost=0.00..0.64 rows=32 width=36) (actual time=9.073..1
92.847 rows=32 loops=1)
   CTE conv510_fwd0
     ->  Nested Loop  (cost=0.00..2.05 rows=32 width=36) (actual time=7.300..167.138 rows=32 loops=1)
           ->  Seq Scan on conv510_weight w_5  (cost=0.00..1.01 rows=1 width=298) (actual time=0.007..0.008
rows=1 loops=1)
           ->  CTE Scan on conv508_fwd0 i_6  (cost=0.00..0.64 rows=32 width=36) (actual time=0.784..24.172 r
ows=32 loops=1)
   CTE conv511_fwd0
     ->  Nested Loop  (cost=0.00..2.05 rows=32 width=36) (actual time=5.092..114.059 rows=32 loops=1)
           ->  Seq Scan on conv511_weight w_6  (cost=0.00..1.01 rows=1 width=426) (actual time=0.004..0.005
rows=1 loops=1)
           ->  CTE Scan on conv509_fwd0 i_7  (cost=0.00..0.64 rows=32 width=36) (actual time=0.889..27.059 r
ows=32 loops=1)
   CTE conv513_fwd0
     ->  Nested Loop  (cost=0.00..2.05 rows=32 width=36) (actual time=12.067..258.041 rows=32 loops=1)
           ->  Seq Scan on conv513_weight w_7  (cost=0.00..1.01 rows=1 width=426) (actual time=0.012..0.013
rows=1 loops=1)
           ->  CTE Scan on conv511_fwd0 i_8  (cost=0.00..0.64 rows=32 width=36) (actual time=5.678..118.599
rows=32 loops=1)
   CTE concat302_fwd0
     ->  Hash Join  (cost=3.12..5.16 rows=32 width=36) (actual time=658.859..690.492 rows=32 loops=1)
           Hash Cond: (i1.id = i4.id)
           ->  Hash Join  (cost=2.08..3.60 rows=32 width=108) (actual time=450.480..475.039 rows=32 loops=1)
                 Hash Cond: (i1.id = i3.id)
                 ->  Hash Join  (cost=1.04..2.12 rows=32 width=72) (actual time=174.201..198.722 rows=32 loo
ps=1)
                       Hash Cond: (i1.id = i2.id)
                       ->  CTE Scan on conv507_fwd0 i1  (cost=0.00..0.64 rows=32 width=36) (actual time=0.90
6..25.364 rows=32 loops=1)
                       ->  Hash  (cost=0.64..0.64 rows=32 width=36) (actual time=173.270..173.271 rows=32 lo
ops=1)
                             Buckets: 1024  Batches: 1  Memory Usage: 8203kB
                             ->  CTE Scan on conv510_fwd0 i2  (cost=0.00..0.64 rows=32 width=36) (actual tim
e=7.404..170.581 rows=32 loops=1)
                 ->  Hash  (cost=0.64..0.64 rows=32 width=36) (actual time=276.260..276.261 rows=32 loops=1)
                       Buckets: 1024  Batches: 1  Memory Usage: 12299kB
                       ->  CTE Scan on conv513_fwd0 i3  (cost=0.00..0.64 rows=32 width=36) (actual time=12.6
40..268.254 rows=32 loops=1)
           ->  Hash  (cost=0.64..0.64 rows=32 width=36) (actual time=208.046..208.047 rows=32 loops=1)
                 Buckets: 1024  Batches: 1  Memory Usage: 4107kB
                 ->  CTE Scan on conv512_fwd0 i4  (cost=0.00..0.64 rows=32 width=36) (actual time=9.913..206
.684 rows=32 loops=1)
 Planning Time: 0.602 ms
 Execution Time: 731.220 ms