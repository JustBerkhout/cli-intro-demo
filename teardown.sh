#!/bin/bash

ksql -f drop_script.ksql

kafka-topics --bootstrap-server localhost:9092 --delete --topic STREAM2
kafka-topics --bootstrap-server localhost:9092 --delete --topic TABLE1
kafka-topics --bootstrap-server localhost:9092 --delete --topic demo-topic-1
