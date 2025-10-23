#!/bin/bash

# rm ALL containers started from the dummyhttp image
docker ps -q --filter ancestor=svenstaro/dummyhttp:latest | xargs -r docker rm -f
