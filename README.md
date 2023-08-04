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
docker-compose -f docker-compose-cluster.yaml down
```

## Produce messages

```bash
curl --location --request POST '0.0.0.0:3000/api/v1/comments' \
--header 'Content-Type: application/json' \
--data-raw '{ "text":"first comment" }'

curl --location --request POST '0.0.0.0:3000/api/v1/comments' \
--header 'Content-Type: application/json' \
--data-raw '{ "text":"second comment" }'


echo "hello Kafka" | kafkacat -P -b localhost:9092 -t test
```

## Consume messages

```bash
kafkacat -C -b localhost:9092 -t test
```

## References

[Original](https://medium.com/swlh/apache-kafka-with-golang-227f9f2eb818)
