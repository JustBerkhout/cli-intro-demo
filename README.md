## CLI demo

```bash
confluent local services start
```


To help with repeatable, scriptable development.

Allows code control

## Installation/configuration
* Confluent Platform
* Kafka tools
* `confluent` client

```bash
which confluent
#/path/to/bin/confluent

which kafka-server-start
#/path/to/confluent-7.1.1/bin/kafka-server-start
```


## Walkthrough examples

### Verify local services

```bash
confluent local services status

# Connect is [UP]
# Control Center is [UP]
# Kafka is [UP]
# Kafka REST is [UP]
# ksqlDB Server is [UP]
# Schema Registry is [UP]
# ZooKeeper is [UP]

```

* `TAB`  completion for `bash` and `zsh`

```bash
confluent [TAB][TAB]
# admin            (Perform administrative tasks for the current organization.)
# api-key          (Manage the API keys.)
# audit-log        (Manage audit log configuration.)
# cloud-signup     (Sign up for Confluent Cloud.)
# completion       (Print shell completion code.)
# connect          (Manage Kafka Connect.)
# context          (Manage CLI configuration contexts.)
# environment      (Manage and select Confluent Cloud environments.)
# help             (Help about any command)
# iam              (Manage RBAC and IAM permissions.)
# kafka            (Manage Apache Kafka.)
# ksql             (Manage ksqlDB.)
# local            (Manage a local Confluent Platform development environment.)
# login            (Log in to Confluent Cloud or Confluent Platform.)
# logout           (Log out of Confluent Cloud.)
# price            (See Confluent Cloud pricing information.)
# prompt           (Add Confluent CLI context to your terminal prompt.)
# schema-registry  (Manage Schema Registry.)
# service-quota    (Look up Confluent Cloud service quota limits.)
# shell            (Start an interactive shell.)
# update           (Update the Confluent CLI.)
# version          (Show version of the Confluent CLI.)

```


* install tab completion
the confluent CLI has a function that helps you install the Bash or Zsh completion.


```bash
confluent completion --help
```

#### Advanced 🎓
Customising 
The local installation that you start with `confluent local services ...` uses a working directory that you can see using this `confluent local current` command. That working directory contains configuration files (e.g. `kafka.properties`) that you can use to configure your local cluster, and it contains the data files and the log files. With this you can customise your local development confluent cluster

```bash
confluent local current
# /tmp/confluent.478693

 ls /tmp/confluent.478693
# connect  control-center  kafka  kafka-rest  ksql-server  schema-registry  zookeeper

ls /tmp/confluent.478693/kafka/
# data  kafka.pid  kafka.properties  kafka.stdout  logs

```

### Topics

No [TAB] complete
```bash
kafka-topics [ENTER]
# Create, delete, describe, or change a topic.
# Option                                   Description
# ------                                   -----------
# --alter                                  Alter the number of partitions,
#                                            replica assignment, and/or
#                                            configuration for the topic.
# --at-min-isr-partitions                  if set when describing topics, only
#                                            show partitions whose isr count is
#                                            equal to the configured minimum.
# --bootstrap-server <String: server to    REQUIRED: The Kafka server to connect
#   connect to>                              to.
# --command-config <String: command        Property file containing configs to be
#   config property file>                    passed to Admin Client. This is used
#                                            only with --bootstrap-server option
#                                            for describing and altering broker
#                                            configs.
# --config <String: name=value>            A topic configuration override for the
# ...
```


```bash
kafka-topics --bootstrap-server localhost:9092 --list
# __consumer_offsets
# __transaction_state
# _confluent-command
# _confluent-controlcenter-7-1-1-1-AlertHistoryStore-changelog
# _confluent-controlcenter-7-1-1-1-AlertHistoryStore-repartition
# _confluent-controlcenter-7-1-1-1-Group-ONE_MINUTE-changelog
# _confluent-controlcenter-7-1-1-1-Group-ONE_MINUTE-repartition
# _confluent-controlcenter-7-1-1-1-Group-THREE_HOURS-changelog
# _confluent-controlcenter-7-1-1-1-Group-THREE_HOURS-repartition
# ... 
```

With authentication you would specify authentication in a config file
and reference it in the `--command.config` argument 
```bash
kafka-topics --bootstrap-server localhost:9092 --list --command.config myconfig.file
```




```bash
kafka-topics --bootstrap-server localhost:9092 --create --topic demo-topic-1
# Created topic demo-topic-1.
```

```bash
kafka-topics --bootstrap-server localhost:9092 --describe --topic demo-topic-1
# Topic: demo-topic-1      TopicId: PhMMa-MtQLeXSZcEVmVGzA PartitionCount: 1       ReplicationFactor: 1    Configs: segment.bytes=1073741824
#         Topic: demo-topic-1      Partition: 0    Leader: 0       Replicas: 0     Isr: 0  Offline:
```

#### Tools
These CLI tools and utilities come with the Confluent Platform
Using `which` to show the path from which my bash/Linux environment loads the tool
I can show you what other tools are in the same `bin` directory under the confluent platform



```bash
 which kafka-topics
# /path/to/confluent-7.1.1/bin/kafka-topics

ls /path/to/confluent-7.1.1/bin/
# Sample shown
# kafka-server-start
# kafka-server-stop
# ksql-server-start
# ksql-server-stop
# connect-distributed
# connect-standalone
# kafka-add-brokers
# confluent-hub
...
# kafka-console-consumer
# kafka-console-producer
# kafka-avro-console-consumer
# kafka-avro-console-producer
# kafka-protobuf-console-consumer
# kafka-protobuf-console-producer
# ksql
# ksql-datagen
# kafka-producer-perf-test
# kafka-consumer-perf-test

```
This is only a small sample of the tools in the platform. Some tools are the same as Apache Kafka, while some other tools are from the different editions of the Confluent Platform. (The unified Confluent CLI is installed separately)

Highlight:
Component Stop/Start scripts
Operations tasks scripts
Confluent Hub

CLI Client software (Producers and consumers, some schema-aware)
Testing tools (e.g. `perf-test` and `datagen`)
KSQL client

### Kafka clients

Interactive
```bash
kafka-console-producer --bootstrap-server localhost:9092 --topic demo-topic-1
```

piping `|`

```bash
echo 5 | kafka-console-producer --bootstrap-server localhost:9092  --topic demo-topic-1
```


```bash
cat numbers.txt
# 6
# 7
# 8
# 9
# 10

cat numbers.txt | kafka-console-producer --bootstrap-server localhost:9092  --topic demo-topic-1
```



```bash
for x in {11..200}; do echo $x; sleep 1; done | kafka-console-producer --bootstrap-server localhost:9092  --topic demo-topic-1
```

`producer.properties`
```txt
acks=all
linger.ms=2000
compression.type=gzip
```


```bash
for x in {1..200}; \
   do echo $x; \
      sleep 1; \
   done | kafka-console-producer \
--bootstrap-server localhost:9092  \
--topic demo-topic-1 \
--producer.config producer.properties
```


### `kcat` (formerly  kafkacat)


`kcat` is a generic non-JVM producer and consumer for Apache Kafka, including Confluent Platform. It is based on the `librdkafka` library


It used to be known as `kafkacat` but was renamed `kcat`

https://github.com/edenhill/kcat



### ksql client

```bash
ksql

#   ===========================================
#   =       _              _ ____  ____       =
#   =      | | _____  __ _| |  _ \| __ )      =
#   =      | |/ / __|/ _` | | | | |  _ \      =
#   =      |   <\__ \ (_| | | |_| | |_) |     =
#   =      |_|\_\___/\__, |_|____/|____/      =
#   =                   |_|                   =
#   =        The Database purpose-built       =
#   =        for stream processing apps       =
#   ===========================================
# ksql>
```

```sql
ksql> [ctrl-d]
# Exiting ksqlDB.
```

```bash
ksql http://localhost:8088 -u my-user -p my-pa$sw0rd!
```

ksql db scripts
```bash
ksql -f create_script.ksql
# CREATE STREAM STREAM1 (MYVAL STRING) WITH (KAFKA_TOPIC='demo-topic-1', KEY_FORMAT='KAFKA', VALUE_FORMAT='JSON', WRAP_SINGLE_VALUE=false);
#  Message
# ----------------
#  Stream created
# ----------------

# CREATE TABLE TABLE1 WITH (KAFKA_TOPIC='TABLE1', PARTITIONS=1, REPLICAS=1) AS SELECT
#   STREAM1.MYVAL MYVAL,
#   COUNT(*) MYNUM
# FROM STREAM1 STREAM1
# GROUP BY STREAM1.MYVAL
# EMIT CHANGES;
#  Message
# --------------------------------------
#  Created query with ID CTAS_TABLE1_15
# --------------------------------------

```


Cleaning up the example in an executable bash-script
```bash
./teardown.sh > teardown.log 2>&1
```

