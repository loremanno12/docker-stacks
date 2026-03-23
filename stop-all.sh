#!/bin/bash
echo "Arresto tutti gli stack..."
cd ~/docker-stacks/general && docker compose down
cd ~/docker-stacks/ai-tools && docker compose down
cd ~/docker-stacks/security && docker compose down
cd ~/docker-stacks/custom-containers/raspi-status && docker compose down
cd ~/docker-stacks/custom-containers/ai-router && docker compose down
echo "✓ Tutti gli stack arrestati!"
