#!/bin/bash

run_tests() {
    if [ "$1" == "jmeter" ]; then
        run_jmeter_test "$2" "$3"
    else
        run_k6_test
    fi
}

run_jmeter_test() {
    echo "Running JMeter test..."
    mvn -f ./jmeter clean test -DtestOutputLocation="$1" > /dev/null 2>&1 &
    local pid=$!
    wait $pid
}

run_k6_test() {
    echo "Running k6 test..."
    # k6 run --out json="$2" script.js > /dev/null 2>&1
}

start_docker() {
    echo "Starting containers..."
    ok_container=$(docker run -d -p 8080:8080 svenstaro/dummyhttp:latest -d 1000 -c 200 -b '{"detail": "OK"}' -H "content-type:application/json")
    created_container=$(docker run -d -p 8081:8080 svenstaro/dummyhttp:latest -d 1000 -c 201 -b '{"detail": "Created"}' -H "content-type:application/json")
    not_found_container=$(docker run -d -p 8084:8080 svenstaro/dummyhttp:latest -d 1000 -c 404 -b '{"detail": "Not Found"}' -H "content-type:application/json")
    internal_error_container=$(docker run -d -p 8085:8080 svenstaro/dummyhttp:latest -d 1000 -c 500 -b '{"detail": "Internal Server Error"}' -H "content-type:application/json")
    sleep 2
}

stop_docker() {
    echo "Stopping containers..."
    docker ps -q --filter ancestor=svenstaro/dummyhttp:latest | xargs -r docker rm -f > /dev/null
}

start_resource_collection() {
    echo "Starting resource collection..."
}

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <jmeter/k6> <test_output_location> <resource_output_location>"
    exit 1
fi
if [ "$1" != "jmeter" ] && [ "$1" != "k6" ]; then
    echo "First argument must be either 'jmeter' or 'k6'"
    exit 1
fi
start_docker
run_tests "$1" "$2" "$3"
stop_docker