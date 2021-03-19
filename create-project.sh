#!/bin/bash

## This script was executed to create the project -- DO NOT USE AGAIN!!

echo "I don't need to be used anymore!  If you need to use me again to start a new project, please edit me!"
exit

echo "Creating Quarkus app... (Kotlin/REST API w/ Gradle)"
mvn io.quarkus:quarkus-maven-plugin:1.12.1.Final:create \
    -DprojectGroupId=org.acme \
    -DprojectArtifactId=braindump-micro \
    -DclassName="org.acme.rest.Braindump" \
    -Dpath="/braindump" \
    -Dextensions="resteasy,kotlin,resteasy-jackson" \
    -DbuildTool=gradle

