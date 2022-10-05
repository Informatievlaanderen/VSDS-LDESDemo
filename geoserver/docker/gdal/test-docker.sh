#!/bin/bash
echo "Test correct file:"
curl --fail-with-body http://localhost:8090/ -d @post-correct.json

echo "Test incorrect file:"
curl --fail-with-body http://localhost:8090/ -d @post-incorrect.json
