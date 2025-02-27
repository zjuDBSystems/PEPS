# PEPS: Towards Automatic and Efficient Prediction Query Processing in Analytical Database
<hr>

## Abstract
<hr>
Data analysts nowadays are keen to have analytical
capabilities involving deep learning (DL). Prediction queries,
which combine relational operations with DL models to analyze
multi-modal data, provide a powerful facility for smart in-
database analysis. However, loose integration systems, which
support such queries via User-Defined Functions (UDFs) and
external runtimes, often impose high economic costs, particularly
in cloud-based environments; while tight integration systems,
which implement model inference through a sequence of explic-
itly written SQL queries, incur heavy user burdens and huge
optimization space.

In this paper, we introduce PEPS, an end-to-end analytical
database for automatic and efficient prediction query processing.
PEPS automates the process of prediction query synthesis and
ensures usability through declarative schemes. Additionally, it
improves query performance with offline optimization using
the DB-oriented Computation Graph Optimization (DBCGO)
algorithm and online optimization via heuristic query rewriting.
Empirical evaluations show that PEPS offers better usability than
baseline methods, provides lower economic costs, and achieves
performance speedup compared to advanced Python UDFs.

## Quick Start
<hr>

#### Compile PEPS

```shell
./configure --prefix=$PEPS_PATH\
            --with-python $PYTHONPATH$
            
make clean && make -j32  && make install 
make clean && make -j32 > ./make.log && make install  
```

#### Install Extension
```shell
make clean && make USE_PGXS=1 install
pg_ctl -D $DATA_PATH$ -l logfile restart
```

