# 02: Apache Kafka and Reactive Messaging

## Adding Kafka

Let's swap out our REST call by directly sending the order to a Kafka Topic

First we need to add SmallRye Reactive Messaging and 2 dependencies that will help us test Kafka:

## Workin with Kafka

```xml
<dependency>
      <groupId>io.quarkus</groupId>
      <artifactId>quarkus-smallrye-reactive-messaging-kafka</artifactId>
    </dependency>
 <dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-test-common</artifactId>
</dependency>
<dependency>
      <groupId>org.testcontainers</groupId>
      <artifactId>kafka</artifactId>
      <version>1.15.0-rc2</version>
</dependency>
```

application.properties:

```properties
# Kafka
# Kafka
%dev.mp.messaging.outgoing.orders.connector=smallrye-kafka
%dev.mp.messaging.outgoing.orders.value.serializer=org.apache.kafka.common.serialization.StringSerializer
%dev.mp.messaging.outgoing.orders.topic=orders

%test.mp.messaging.outgoing.orders.connector=smallrye-kafka
%test.mp.messaging.outgoing.orders.value.serializer=org.apache.kafka.common.serialization.StringSerializer
%test.mp.messaging.outgoing.orders.topic=orders
```

Update our test:

```java
@QuarkusTest @QuarkusTestResource(KafkaTestResource.class)
public class ApiResouceTest {

    Logger logger = LoggerFactory.getLogger(ApiResourceTest.class);

/*
    @InjectMock
    RESTService restService;
*/
```

```java
package org.j4k.workshops.quarkus.coffeeshop.favfood;

import io.quarkus.test.common.QuarkusTestResource;
import io.quarkus.test.junit.QuarkusTest;
import io.quarkus.test.junit.mockito.InjectMock;
import org.j4k.workshops.quarkus.coffeeshop.infrastructure.KafkaTestResource;
import org.j4k.workshops.quarkus.coffeeshop.infrastructure.RESTService;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObject;
import javax.ws.rs.core.MediaType;
import java.util.UUID;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.is;

@QuarkusTest @QuarkusTestResource(KafkaTestResource.class)
public class FavFoodOrderTest {

    Logger logger = LoggerFactory.getLogger(FavFoodOrderTest.class);

/*
    @InjectMock
    RESTService restService;
*/

    @Test
    public void testPlacingOrder() {

        JsonObject mockOrder = mockOrder();
        System.out.println(mockOrder);

        given()
                .accept(MediaType.APPLICATION_JSON)
                .contentType(MediaType.APPLICATION_JSON)
                .body(mockOrder)
                .when()
                .post("/api/favfood")
                .then()
                    .statusCode(202)
                    .body("orderId", equalTo(mockOrder.getString("orderId")))
                    .body("customerName", equalTo("Lemmy"));

    }

    private JsonObject mockOrder() {

        return Json.createObjectBuilder()
                .add("customerName", "Lemmy")
                .add("orderId", UUID.randomUUID().toString())
                .add("lineItems", mockLineItems())
                .build();
    }

    private JsonArray mockLineItems() {

        final JsonArrayBuilder jsonArrayBuilder = Json.createArrayBuilder();
        jsonArrayBuilder.add(mockLineItem());
        return jsonArrayBuilder.build();
    }

    private JsonObject mockLineItem() {

        return Json.createObjectBuilder()
                .add("item", "COFFEE_BLACK")
                .add("itemId", UUID.randomUUID().toString())
                .add("quantity", 1).build();
    }
}
```
### Building

./mvnw clean package -Dquarkus.container-image.build=true
docker build -f src/main/docker/Dockerfile.jvm -t jeremydavis/j4k-workshop .
