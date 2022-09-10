#!/bin/bash

read -p "Topic name: " TOPIC

echo "🚧 Creating $TOPIC"
mkdir -p "$TOPIC"

echo 📝 "Creating $TOPIC/README.md"
cat << EOF > "$TOPIC/README.md"
# $TOPIC

## Prevent

## Tools

## References
EOF

echo 📝 "Adding $TOPIC/README.md link to main README.md"
echo -e "\n- [$TOPIC]($TOPIC/README.md)" >> README.md
