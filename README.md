# Event Driven Architecture with Quarkus, Kafka, and Kubernetets

*Don't hesitate to ask questions!*

## Table of Contents

1. Your Presenters
1. Workshop Overview (what you're going to build)
1. Pre-Requisites
1. Preparing Your Workspace

## Your Presenters

Your presenters are:

**Jeremy Davis**  
Chief Architect, Red Hat  
@argntprgrmr  
https://www.linkedin.com/in/jeremyrdavis/

**Tosin Akinosho**  
Specialist Solutions Architect, Red Hat  
@tech0827  
https://www.linkedin.com/in/tosinakinosho/

## Workshop Overview

The workshop is based around the Quarkus Coffeeeshop.  In the workshop you will create a microservice that integrates with a delivery provider.  You will leverage Microprofile's REST Client, Microprofile Reactive Messaging for Kafka integration, and Hibernate Panache for persisting records to MongoDB

[Getting Started](workshop-quickstart.md)
[Step One: Introducing Quarkus](WORKSHOP-LOCAL-01-GETTING_STARTED.md)
[Step Two: Using Quarkus' REST Client](WORKSHOP-LOCAL-02-REST.md)
[Step Three: Leveraging Kafka with Microprofile Reactive Messaging](WORKSHOP-LOCAL-03-KAFKA.md)
[Step Four: Persistance with Hibernate Panache](WORKSHOP-LOCAL-04-MONGODB.md)
 
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
* a REST development tool
    * [Postman](https://www.postman.com/) is favored by your humble workshop authors
    * Browser plugins:
        * Firefox 
	    * https://addons.mozilla.org/en-US/firefox/addon/rested/
	    * https://addons.mozilla.org/en-US/firefox/addon/restclient/
	    * https://addons.mozilla.org/en-US/firefox/addon/rester/
        * Chrome
	    * https://chrome.google.com/webstore/detail/advanced-rest-client/
	    * https://chrome.google.com/webstore/detail/talend-api-tester-free-ed/aejoelaoggembcahagimdiliamlcdmfm?hl=en
* Docker (for the Kafka and MongoDB steps)
    * https://www.docker.com/products/docker-desktop
    * https://docs.docker.com/engine/install/ubuntu/

## Preparing Your Workspace

1. Create a folder for your work, i.e. "/Users/<<YOUR NAME>>/J4k" or "C:\\J4K"
1. Clone the solution in this folder: https://github.com/jeremyrdavis/j4k-workshop-solution.git

### Deploy Workshop on OpenShift
* [j4k workshop OpenShift deployment](workshop-quickstart.md)
