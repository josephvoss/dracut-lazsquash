#!/bin/bash

buildah bud -f Dockerfile -t root-user:$(git rev-parse --short HEAD) .
