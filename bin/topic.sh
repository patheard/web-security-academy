#!/bin/bash

read -rp "Topic name: " TOPIC
DIR=$(echo "${TOPIC//[^A-Za-z]/-}" | tr '[:upper:]' '[:lower:]')

echo "🚧 Creating $TOPIC"
mkdir -p "$DIR"

echo 📝 "Creating $DIR/README.md"
cat << EOF > "$DIR/README.md"
# $TOPIC

## Prevent

## Tools

## References
EOF

echo 📝 "Adding $DIR/README.md link to main README.md"
echo -e "\n- [$TOPIC]($DIR/README.md)" >> README.md
