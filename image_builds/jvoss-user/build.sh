#!/bin/bash

buildah bud -f Dockerfile -t jvoss-user:$(git rev-parse --short HEAD) .
