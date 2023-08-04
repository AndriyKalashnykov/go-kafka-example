# go-kafka-example

# Start Kafka singe server

```bash
docker-compose -f docker-compose.yaml up -d 
```

# Start Kafka cluster

```bash
docker-compose -f docker-compose-cluster.yaml up -d 
```

# Stop Kafka singe server

```bash
docker-compose -f docker-compose.yaml down
```

# Stop Kafka cluster

```bash
docker-compose -f docker-compose-cluster-needs-work.yaml down
```

## Produce messages

```bash
curl --location --request POST '0.0.0.0:4000/api/v1/comments' \
--header 'Content-Type: application/json' \
--data-raw '{ "text":"first comment" }'

curl --location --request POST '0.0.0.0:4000/api/v1/comments' \
--header 'Content-Type: application/json' \
--data-raw '{ "text":"second comment" }'


echo "hello Kafka" | kafkacat -P -b localhost:9092 -t test
echo "comment1" | kafkacat -P -b localhost:9092 -t comments
```

## Consume messages

```bash
kafkacat -C -b localhost:9092 -t test
```

## Kafka UI

```bash
xdg-open http://172.28.1.4:8080/ui/clusters/local/brokers
```

## References

[Original](https://medium.com/swlh/apache-kafka-with-golang-227f9f2eb818)
