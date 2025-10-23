#!/bin/bash

docker run -d -p 8080:8080 svenstaro/dummyhttp:latest -d 1000 -c 200 -b '{"detail": "OK"}' -H "content-type:application/json" 
docker run -d -p 8081:8080 svenstaro/dummyhttp:latest -d 1000 -c 201 -b '{"detail": "Created"}' -H "content-type:application/json" 
docker run -d -p 8084:8080 svenstaro/dummyhttp:latest -d 1000 -c 404 -b '{"detail": "Not Found"}' -H "content-type:application/json" 
docker run -d -p 8085:8080 svenstaro/dummyhttp:latest -d 1000 -c 500 -b '{"detail": "Internal Server Error"}' -H "content-type:application/json" 