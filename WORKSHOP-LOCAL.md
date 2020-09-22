# Event Driven Architecture with Quarkus, Kafka, and Kubernetets (Local Development)

In this workshop you will build a microservice to integrate the existing Quarkus Coffeeshop application with the FavFood Delivery Service

## Table of Contents

1. Pre-requisites
1. Application Requirements (what you're going to build)
	1. Background
	1. Documentation
1. Creating a project at https://code.quarkus.io
1. Importing the project into Visual Studio Code
1. Getting Started with the project
	1. Importing the project into Visual Studio Code
	1. Testing Quarkus applications
1. Quarkus dev mode
    1. Live changes
    1. Configuration and Parameterizing the Greeting Message
1. Starting on Our Application
    1. Test First and Fail Fast
    1. Implement Our Endpoint


## Pre-requisites

You need:
* a JDK installed on your machine (the workshop was developed with 11)
    * [Adopt OpenJDK](https://adoptopenjdk.net/) is an easy way to get started with OpenJDK
    * [Oracle JDK](https://www.oracle.com/java/technologies/javase-downloads.html) the official, Oracle version
* a Github account
    * [Github](https://github.com/)
* an IDE (although the workshop authors use IntelliJ, and it will have to be pried from our cold, dead fingers, the examples all use Visual Studio Code, which is a pretty great IDE)
    * [Visual Studio Code](https://code.visualstudio.com/)
        * Be sure to install the Java and Quarkus tools for VS Code: (https://code.visualstudio.com/docs/languages/java)
    * [IntelliJ](https://www.jetbrains.com/idea/)
    * [Eclipse](https://www.eclipse.org/)
    * [Netbeans](https://netbeans.org/)

## Application Requirements

### Background

Because to go orders have recently taken on a new importance :mask: the Quarkus Coffeeshop business team has recently inked a deal with FavFood Delivery.  FavFood requires us, the Quarkus Coffeeshop dev team, to implement a REST endpoint for them to call with to go orders.

In this workshop we will consume their JSON format, translate it into our expected format, and enter it into the Quarkus Coffeeshop system.  Along the way we will learn how to:
* Quickly create a Quarkus application
* About Quarkus extensions
* Running Quarkus in dev mode (developer joy!)
* Reactive messaging with SmallRye reactive messaging
* Making REST calls

### Documentation

FavFood has supplied us with an [OpenApi](https://www.openapis.org/) document describing the service that we need to stand up in order to integrate with them.  Don't worry if you are unfamiliar with the OpenAPI spec, but it is worth checking out after the workshop: [SwaggerIO OpenAPI Specification](https://swagger.io/specification/)

```yaml
---
openapi: 3.0.1
info:
  title: FavFood Delivery Service API
  version: "1.0"
paths:
  /api:
    post:
      responses:
        "202":
          description: OK
          content:
            'application/json':
              schema:
                $ref: '#/components/schemas/Order'
components:
  schemas:
    Order:
      type: object
      properties:
        customerName:
          type: string
        orderId:
          type: string
        lineItems:
          $ref: '#/components/schemas/ListLineItem'
    ListLineItem:
      type: array
      items:
        $ref: '#/components/schemas/LineItem'
    LineItem:
      type: object
      properties:
        item:
          type: string
        itemId:
          type: string
        quantity:
          format: int32
          type: integer
```

We need to accept an "Order" object with properties, "customerName," "id," and an array "listLineItems" of "LineIem" objects defined.  The "LineItem" contains Strings for "itemId," "item," and an integer "quantity."

## Creating a Project with https://code.quarkus.io

* Open https://code.quarkus.io
* In the top left corner set the values for your microservice:
** org.j4k.workshops.quarkus
** quarkus-coffeeshop-workshop
** Maven (Quarkus supports Gradle as well, but this tutorial is built with Maven )
* From the menu select 
** "RESTEasy JSON-B"
** "Hibernate ORM with Panache" 
** "JDBC Driver - PostgreSQL" 
** "JDBC Driver - H2"
** "SmallRye Reactive Messaging"
* Click "Generate Your Application" and Push to Github
* Clone the repository on your filesystem

*Note:* We have intentionally left out one dependency so that you can add it later with Quarkus' Maven plugin.  This an attempt at forshadowing and is designed to make the workshop more enjoyable 

## Getting Started with Your Project

### Importing the project into Visual Studio Code

* Open Visual Studio Code
* Open your existing workspace
* Click, "Git Clone"
* Enter the URL from your github repo

TODO: Have a workspace ready or add instructions for creating one

#### pom.xml

The selections you made at https://code.quarkus.io are in the pom.xml :

```xml
  <dependencies>
    <dependency>
      <groupId>io.quarkus</groupId>
      <artifactId>quarkus-resteasy</artifactId>
    </dependency>
    <dependency>
      <groupId>io.quarkus</groupId>
      <artifactId>quarkus-junit5</artifactId>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>io.rest-assured</groupId>
      <artifactId>rest-assured</artifactId>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>io.quarkus</groupId>
      <artifactId>quarkus-jdbc-h2</artifactId>
    </dependency>
    <dependency>
      <groupId>io.quarkus</groupId>
      <artifactId>quarkus-resteasy-jsonb</artifactId>
    </dependency>
    <dependency>
      <groupId>io.quarkus</groupId>
      <artifactId>quarkus-smallrye-reactive-messaging</artifactId>
    </dependency>
    <dependency>
      <groupId>io.quarkus</groupId>
      <artifactId>quarkus-hibernate-orm-panache</artifactId>
    </dependency>
    <dependency>
      <groupId>io.quarkus</groupId>
      <artifactId>quarkus-jdbc-postgresql</artifactId>
    </dependency>
  </dependencies>
```

For more on [Quarkus extensions](https://quarkus.io/guides/writing-extensions)


### Testing Quarkus Applications

* Open src/test/java/org/j4k/workshops/quarkus/ExampleResourceTest
* There are 2 ways to run tests from within VSCode:
** Click "Run Test," which can be found under the @Test annotation and above the "ExampleResourceTest" method
** Open a Terminal from within Visual Studio Code and type the following:

```shell
./mvnw clean test
```

### Quarkus Tests

You have probably noticed that the test classes are annotated with "@QuarkusTest."  The test spins up a version of Quarkus, calls the endpoint using rest-assured, and verifies the output using [Rest-Assured](https://rest-assured.io)

### Dev Mode

"quarkus:dev runs Quarkus in development mode. This enables hot deployment with background compilation, which means that when you modify your Java files and/or your resource files and refresh your browser, these changes will automatically take effect. This works too for resource files like the configuration property file. 

Refreshing the browser triggers a scan of the workspace, and if any changes are detected, the Java files are recompiled and the application is redeployed; your request is then serviced by the redeployed application. If there are any issues with compilation or deployment an error page will let you know.

This will also listen for a debugger on port 5005. If you want to wait for the debugger to attach before running you can pass -Dsuspend on the command line. If you don’t want the debugger at all you can use -Ddebug=false."

https://quarkus.io/guides/getting-started#development-mode

:sunglasses: *Q-TIP* : when running multiple intances of Quarkus locally, which is pretty common in a microservices architecture you can have each one listen for a debugger on different ports.  For example when working the the Quarkus Coffeeshop your humble workshop authors typically assign the ports:
* web "-Ddebug=5005"
* core "-Ddebug=5006"
* barista "-Ddebug=5007"



Start Quarkus in dev mode:

```shell

./mvnw clean compile quarkus:dev

```
Open http://localhost:8080 and http://localhost:8080/hello

#### Live changes

Open the ExampleResource class (org.j4k.workshops.quarkus.ExampleResource.java.  This class was generated when we created our application.  It doesn't do much.  We will fix that.

Change the message from "hello" to something more prosaic, like "hello, world!" and save the file.  Now reload your browser.

The change is almost instantaneous.  

Change the message again to something even better, like, "hello, j4k!" and reload your browser.  Play around until you have a hello message you like

Quarkus Code Wisdom: *Coding is mostly trial and error.  The faster your feedback loop the more productive you will be!*

Once you're happy with the message, and your test are passing you can commit your code.  Of course the tests aren't going to pass no that we've changed the message

##### Some More Testing

You can run the test again without stopping Quarkus.  The tests use a different port so you can keep Quarkus runing in dev mode and run tests at the same time so we can fail our test while the app is running

#### Configuration and Parameterizing the Greeting Message

Let's parameterize the message by moving it into the application.properties file found in src/main/resources by adding the following:

```properties
# Configuration file
# key = value

%dev.hello.message=Hello, J4K 2020!
%test.hello.message=hello
hello.message=Hello from Quarkus!
```

As an astute developer you will have noticed that the properties are parameterized ("%dev.hello.message".)  You can add "%prod" if you like, but Quarkus will grab the non-parameterized property for prod by default.  

#### Update ExampleResource

Now we need to update ExampleResource.java to use the parameter:

```java
package org.j4k.workshops.quarkus;


import org.eclipse.microprofile.config.inject.ConfigProperty;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/hello")
public class ExampleResource {

    @ConfigProperty(name="hello.message")
    String helloMessage;

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String hello() {
        return helloMessage;
    }
}
```

Refresh your browser.  You should of course see the new %dev.hello.message.

Re-run the test, and this time you should pass.  You can also parameterize the ExampleResourceTest.java:

```java
package org.j4k.workshops.quarkus;

import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;

import javax.resource.spi.ConfigProperty;

@QuarkusTest
public class ExampleResourceTest {

    @ConfigProperty(name="hello.message")
    String helloMessage;

    @Test
    public void testHelloEndpoint() {
        given()
          .when().get("/hello")
          .then()
             .statusCode(200)
             .body(is(helloMessage));
    }

}
```


You can commit the changes to github if you want:

```shell script
git commmit -am "Parameterized ExampleResource message"
```

## Starting on Our Application

### Test First  and Fail Fast

Let's create a new package, "org.j4k.workshops.quarkus.infrastructure," and a test, "FavFoodResourceTest" for our REST service:

```java
package org.j4k.workshops.quarkus.infrastucture;

import java.util.UUID;

import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObject;
import javax.ws.rs.core.MediaType;

import org.junit.jupiter.api.Test;

import io.quarkus.test.junit.QuarkusTest;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;

@QuarkusTest
public class FavFoodResourceTest {

    @Test
    public void testFavFoodEndpoint() {

        final JsonObject order = mockOrder();

        given()
          .accept(MediaType.APPLICATION_JSON)
          .contentType(MediaType.APPLICATION_JSON)
          .body(order.toString())
          .when()
          .post("/FavFood")
          .then()
             .statusCode(202)
             .body("orderId", equalTo(order.getString("orderId")))
             .body("customerName", equalTo("Lemmy"));
    }

    JsonObject mockOrder(){
        return Json.createObjectBuilder()
        .add("customerName", "Lemmy")
        .add("id", UUID.randomUUID().toString())
        .add("lineItems", mockLineItems()).build();    
    }

	private JsonArray mockLineItems() {
        final JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();
        arrayBuilder.add(mockLineItem());
		return arrayBuilder.build();
	}

	private JsonObject mockLineItem() {
        return Json.createObjectBuilder()
        .add("item", "BLACK_COFFEE")
        .add("orderId", UUID.randomUUID().toString())
        .add("quantity", 1).build();    
	}

}
```
#### Rest Assured Test

[Rest Assured](https://rest-assured.io/) is a great testing tool.  It is included with the RESTEasy extension.  We are also going to use the [Hamcrest](http://hamcrest.org/JavaHamcrest/) matchers.  If you aren't familiar with these projects your humble workshops authors highly recommend you carve out some time to familiarize yourself with them.  Even if you are familiar with them it can be worth your time to revisit the docs; they are both great projects!


The Rest-Assured part of our test is:

```java
    @Test
    public void testFavFoodEndpoint() {

        final JsonObject order = mockOrder();

        given()
          .accept(MediaType.APPLICATION_JSON)
          .contentType(MediaType.APPLICATION_JSON)
          .body(order.toString())
          .when()
          .post("/FavFood")
          .then()
             .statusCode(202)
             .body("orderId", equalTo(order.getString("orderId")))
             .body("customerName", equalTo("Lemmy"));
    }
```

Most of it is similar to our earlier test.  The differences are that we have added header information and a body to the POST request.

#### Mock Out an Example Payload

```java
    JsonObject mockOrder(){
        return Json.createObjectBuilder()
        .add("customerName", "Lemmy")
        .add("id", UUID.randomUUID().toString())
        .add("lineItems", mockLineItems()).build();    
    }

	private JsonArray mockLineItems() {
        final JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();
        arrayBuilder.add(mockLineItem());
		return arrayBuilder.build();
	}

	private JsonObject mockLineItem() {
        return Json.createObjectBuilder()
        .add("item", "BLACK_COFFEE")
        .add("id", UUID.randomUUID().toString())
        .add("quantity", 1).build();    
	}
```

These three methods create the JSON payload we will send to our REST endpoint.  We are using [JSON-B](http://json-b.net/) which is one of the Json libraries available in Quarkus.  Jackson is also available if you prefer their API's.

Run the test.  It should of course fail because we haven't implemented our endpoint yet.

*IRRELEVENT NOTE:* Black Coffee seems an appropriate beverage for Lemmy Kilminster who was the bassist, singer, and leader of Mötorhead until his death in 2015.  Your humble workshops authors chose Lemmy as our customer because Mötorhead is excellent background music for creating workshops.  Feel free to substitute Lemmy for a customer of your choosing.

### Implement Our Endpoint

Create the "infrastructure" package in the "src/java" folder.  Create a Java class, "org.j4k.workshops.quarkus.infrastructure.FavFoodResource" with the following content:

```java
package org.j4k.workshops.quarkus.infrastructure;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.Response;

@Path("FavFood")
public class FavFoodResource {

    @POST
    public Response placeOrder(final FavFoodOrder favFoodOrder){
        return Response.accepted().entity(favFoodOrder).build();
    }
}
```

Our class won't compile of course because FavFoodOrder doesn't exist.

### Create the FavFood domain model

#### FavFoodOrder

Create a "domain" package in "src/test," and create a class, "FavFoodOrder," in the "domain package":

```java
package org.j4k.workshops.quarkus.domain;

import java.util.List;

import io.quarkus.runtime.annotations.RegisterForReflection;

@RegisterForReflection
public class FavFoodOrder {

    String orderId;

    String customerName;

    List<LineItem> lineItems;

    public FavFoodOrder(){

    }

}
```

Use your IDE to generate equals(), hashCode(), toString(), and getters and setters.  In Visual Studio Code you can right-click on the class, choose "Source Action," and you will get a menu with the options.

The whole class is below for reference:

```java
package org.j4k.workshops.quarkus.domain;

import java.util.List;

import io.quarkus.runtime.annotations.RegisterForReflection;

@RegisterForReflection
public class FavFoodOrder {

    String orderId;

    String customerName;

    List<LineItem> lineItems;

    public FavFoodOrder(){

    }

	/* (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((customerName == null) ? 0 : customerName.hashCode());
		result = prime * result + ((lineItems == null) ? 0 : lineItems.hashCode());
		result = prime * result + ((orderId == null) ? 0 : orderId.hashCode());
		return result;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		FavFoodOrder other = (FavFoodOrder) obj;
		if (customerName == null) {
			if (other.customerName != null)
				return false;
		} else if (!customerName.equals(other.customerName))
			return false;
		if (lineItems == null) {
			if (other.lineItems != null)
				return false;
		} else if (!lineItems.equals(other.lineItems))
			return false;
		if (orderId == null) {
			if (other.orderId != null)
				return false;
		} else if (!orderId.equals(other.orderId))
			return false;
		return true;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	
	@Override
	public String toString() {
		return "FavFoodOrder [customerName=" + customerName + ", lineItems=" + lineItems + ", orderId=" + orderId + "]";
	}

	/**
	 * @return the orderId
	 */
	public String getOrderId() {
		return orderId;
	}

	/**
	 * @param orderId the orderId to set
	 */
	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	/**
	 * @return the customerName
	 */
	public String getCustomerName() {
		return customerName;
	}

	/**
	 * @param customerName the customerName to set
	 */
	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	/**
	 * @return the lineItems
	 */
	public List<LineItem> getLineItems() {
		return lineItems;
	}

	/**
	 * @param lineItems the lineItems to set
	 */
	public void setLineItems(List<LineItem> lineItems) {
		this.lineItems = lineItems;
	}
}

```

Your IDE should be complaining at this point because we don't have a "LineItem" class yet.  Let's fix that!

#### LineItem

Just like the FavFoodOrder create a class, "LineItem," in the "domain package":

```java

package org.j4k.workshops.quarkus.domain;

import io.quarkus.runtime.annotations.RegisterForReflection;

@RegisterForReflection
public class LineItem {

    String itemId;

    String item;

    int quantity;

    public LineItem(){

    }

}
```

Repeat the code generation steps above for getters and settes, hashCode(), equals(), and toString() so that you have a class like:

```java
package org.j4k.workshops.quarkus.domain;

public class LineItem {

    String itemId;

    String item;

    int quantity;

    public LineItem(){

    }

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	
	@Override
	public String toString() {
		return "LineItem [item=" + item + ", itemId=" + itemId + ", quantity=" + quantity + "]";
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((item == null) ? 0 : item.hashCode());
		result = prime * result + ((itemId == null) ? 0 : itemId.hashCode());
		result = prime * result + quantity;
		return result;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		LineItem other = (LineItem) obj;
		if (item == null) {
			if (other.item != null)
				return false;
		} else if (!item.equals(other.item))
			return false;
		if (itemId == null) {
			if (other.itemId != null)
				return false;
		} else if (!itemId.equals(other.itemId))
			return false;
		if (quantity != other.quantity)
			return false;
		return true;
	}

	/**
	 * @return the itemId
	 */
	public String getItemId() {
		return itemId;
	}

	/**
	 * @param itemId the itemId to set
	 */
	public void setItemId(String itemId) {
		this.itemId = itemId;
	}

	/**
	 * @return the item
	 */
	public String getItem() {
		return item;
	}

	/**
	 * @param item the item to set
	 */
	public void setItem(String item) {
		this.item = item;
	}

	/**
	 * @return the quantity
	 */
	public int getQuantity() {
		return quantity;
	}

	/**
	 * @param quantity the quantity to set
	 */
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
}
```

### Re-Run the Test

The test should now pass!

You can commit the changes to github if you like:

```shell script
git commit -am "completed step 1"
```

## Getting the FavFoodOrder into our Format

### Our Domain

The other Quarkus Coffeeshop developers have documented their endpoint with the follwoing document:

```yaml
---
openapi: 3.0.3
info:
  title: Quarkus Cafe Order API
  version: "1.0"
paths:
  /order:
    post:
      responses:
        "200":
          description: OK
          content:
            '*/*':
              schema:
                $ref: '#/components/schemas/OrderInCommand'
components:
  schemas:
    LineItem:
      type: object
      properties:
        item:
          $ref: '#/components/schemas/Item'
        name:
          type: string
    ListLineItem:
      type: array
      items:
        $ref: '#/components/schemas/LineItem'
    Item:
      enum:
      - CAKEPOP
      - CAPPUCCINO
      - COFFEE_BLACK
      - COFFEE_WITH_ROOM
      - CROISSANT
      - CROISSANT_CHOCOLATE
      - ESPRESSO
      - ESPRESSO_DOUBLE
      - LATTE
      - MUFFIN
      type: string
    OrderInCommand:
      type: object
      properties:
        beverages:
          $ref: '#/components/schemas/ListLineItem'
        id:
          type: string
        kitchenOrders:
          $ref: '#/components/schemas/ListLineItem'
```

*NOTE*: We could of course import a jar file with these objects, but for the sake of this workshop we will create the OrderInCommand manually.  Actually we will create two classes: OrderInCommand and LineItem.  This is simple stuff so feel free to copy and paste from below.

#### OrderInCommand

This object is pretty simple.  There are only three things to note:

*NOTE*
* The @RegisterForReflection annotation is used when compiling to native code with GraalVM.  It is not always necessary, but it is a good idea to include it with domain objects.
* JSON-B, the library we are using for marshalling to and from JSON, requires a default empty constructor
* the "addBeverage" and "addKitchenOrder" are convenience methods for adding to the internal List<LineItem> objects

```java
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import io.quarkus.runtime.annotations.RegisterForReflection;

@RegisterForReflection
public class OrderInCommand {

    String id;

    List<LineItem> beverages;

    List<LineItem> kitchenOrders;

	/**
	 * 
	 */
	public OrderInCommand() {
	}

    public void addBeverage(LineItem lineItem){
        if(this.beverages == null) this.beverages = new ArrayList<LineItem>();
        this.beverages.add(lineItem);
    }

    public void addKitchenOrder(LineItem lineItem){
        if(this.kitchenOrders == null) this.kitchenOrders = new ArrayList<LineItem>();
        this.kitchenOrders.add(lineItem);
    }

	/* (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((beverages == null) ? 0 : beverages.hashCode());
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		result = prime * result + ((kitchenOrders == null) ? 0 : kitchenOrders.hashCode());
		return result;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		OrderInCommand other = (OrderInCommand) obj;
		if (beverages == null) {
			if (other.beverages != null)
				return false;
		} else if (!beverages.equals(other.beverages))
			return false;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		if (kitchenOrders == null) {
			if (other.kitchenOrders != null)
				return false;
		} else if (!kitchenOrders.equals(other.kitchenOrders))
			return false;
		return true;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	
	@Override
	public String toString() {
		return "OrderInCommand [beverages=" + beverages + ", id=" + id + ", kitchenOrders=" + kitchenOrders + "]";
	}

	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return the beverages
	 */
	public List<LineItem> getBeverages() {
		return beverages;
	}

	/**
	 * @param beverages the beverages to set
	 */
	public void setBeverages(List<LineItem> beverages) {
		this.beverages = beverages;
	}

	/**
	 * @return the kitchenOrders
	 */
	public List<LineItem> getKitchenOrders() {
		return kitchenOrders;
	}

	/**
	 * @param kitchenOrders the kitchenOrders to set
	 */
	public void setKitchenOrders(List<LineItem> kitchenOrders) {
		this.kitchenOrders = kitchenOrders;
	}

    
}
```
#### LineItem

```java
package org.j4k.workshops.quarkus.domain;

import io.quarkus.runtime.annotations.RegisterForReflection;

@RegisterForReflection
public class LineItem {

    String item;

    String name;

	/**
	 * 
	 */
	public LineItem() {
    }

	/**
	 * @param item
	 * @param name
	 */
	public LineItem(String item, String name) {
		this.item = item;
		this.name = name;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	
	@Override
	public String toString() {
		return "LineItem [item=" + item + ", name=" + name + "]";
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((item == null) ? 0 : item.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		return result;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		LineItem other = (LineItem) obj;
		if (item == null) {
			if (other.item != null)
				return false;
		} else if (!item.equals(other.item))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		return true;
	}

	/**
	 * @return the item
	 */
	public String getItem() {
		return item;
	}

	/**
	 * @param item the item to set
	 */
	public void setItem(String item) {
		this.item = item;
	}

	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}
}
```
### Translating the FavFoodOrder into Our Domain with a Transaction Script

#### Test First

First let's write a test (this is just testing our business logic so feel free to copy and paste.)  The interesting stuff is next.

```java
package org.j4k.workshops.quarkus.infrastucture;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.Arrays;
import java.util.UUID;

import org.j4k.workshops.quarkus.domain.*;
import org.j4k.workshops.quarkus.domain.favfood.*;
import org.junit.jupiter.api.Test;

public class FavFoodOrderProcessorTest {
    

    @Test
    public void testFavFoodOrder(){

        FavFoodOrder favFoodOrder = new FavFoodOrder();
        favFoodOrder.setCustomerName("Lemmy");
        favFoodOrder.setLineItems(Arrays.asList(new FavFoodLineItem(UUID.randomUUID().toString(), "COFFEE_BLACK", 1)));
        OrderInCommand expectedOrderInCommand = new OrderInCommand();
        expectedOrderInCommand.addBeverage(new LineItem("COFFEE_BLACK", "Lemmy"));

        OrderInCommand resultingOrderInCommand = FavFoodOrderHandler.createFromFavFoodOrder(favFoodOrder);

        assertEquals(expectedOrderInCommand.getBeverages().size(), resultingOrderInCommand.getBeverages().size());
        assertEquals(expectedOrderInCommand.getBeverages().get(0).getName(), resultingOrderInCommand.getBeverages().get(0).getName());
        assertEquals(expectedOrderInCommand.getBeverages().get(0).getItem(), resultingOrderInCommand.getBeverages().get(0).getItem());
        
    }
}
```

#### FavFoodOrderHandler (Our Transaction Script)

We use Object Oriented design principles throughout the application.  When you look at the code in the core application the Order domain object encapsulates all of the business logic for creating events from commands.

In this case we will use an anemic domain model and handle the translation with a transaction script.  The OrderInCommand is after all only a command.  Other parts of our system will handle persistence (for now anyway), and so using a transaction script in the favfood package makes sense.

```java
package org.j4k.workshops.quarkus.domain.favfood;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import org.j4k.workshops.quarkus.domain.LineItem;
import org.j4k.workshops.quarkus.domain.OrderInCommand;
import org.j4k.workshops.quarkus.domain.favfood.*;

public class FavFoodOrderHandler {

    static final Set<String> beverages = new HashSet<>(Arrays.asList("CAPPUCCINO","COFFEE_BLACK","COFFEE_WITH_ROOM","ESPRESSO","ESPRESSO_DOUBLE","LATTE"));

    static final Set<String> food = new HashSet<>(Arrays.asList("CAKEPOP","CROISSANT","CROISSANT_CHOCOLATE","MUFFIN"));
    
    public static OrderInCommand createFromFavFoodOrder(final FavFoodOrder favFoodOrder){

        OrderInCommand orderInCommand = new OrderInCommand();

        favFoodOrder.getLineItems().forEach(favFoodLineItem -> {
            if(beverages.contains(favFoodLineItem.getItem())){
                for(int i=0;i<favFoodLineItem.getQuantity();i++){
                    orderInCommand.addBeverage(new LineItem(favFoodLineItem.getItem(), favFoodOrder.getCustomerName()));  
                }
            }else if(food.contains(favFoodLineItem.getItem())){
                for(int i=0;i<favFoodLineItem.getQuantity();i++){
                    orderInCommand.addKitchenOrder(new LineItem(favFoodLineItem.getItem(), favFoodOrder.getCustomerName()));  
                }
            }
        });
        return orderInCommand;
    }
    

}

```
## Getting the FavFoodOrder into our System

We are going to use Quarkus' REST Client to call an existing endpoint in the web application

```java
package org.j4k.workshops.quarkus.infrastructure;

import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;
import org.j4k.workshops.quarkus.domain.OrderInCommand;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.Response;
import java.util.concurrent.CompletionStage;

@Path("/order")
@RegisterRestClient
public interface RESTService {

    @POST
    CompletionStage<Response> placeOrders(OrderInCommand createOrderCommand);
}
```

Update the application.properties to contain:

```properties
# REST CLIENT
%dev.com.redhat.quarkus.cafe.infrastructure.RESTService/mp-rest/url=http://localhost:8080
%test.com.redhat.quarkus.cafe.infrastructure.RESTService/mp-rest/url=http://localhost:8080
%prod.com.redhat.quarkus.cafe.infrastructure.RESTService/mp-rest/url=${REST_URL}

%dev.com.redhat.quarkus.cafe.infrastructure.RESTService/mp-rest/scope=javax.inject.Singleton
%test.com.redhat.quarkus.cafe.infrastructure.RESTService/mp-rest/scope=javax.inject.Singleton
%prod.com.redhat.quarkus.cafe.infrastructure.RESTService/mp-rest/scope=javax.inject.Singleton
```

## Persisting our Order with Hibernate Panache

[Hibernate Panache](https://quarkus.io/guides/hibernate-orm-panache)
