#!/bin/bash
echo "Avvio tutti gli stack..."
cd ~/docker-stacks/general && docker compose up -d
cd ~/docker-stacks/ai-tools && docker compose up -d
cd ~/docker-stacks/security && docker compose up -d
cd ~/docker-stacks/custom-containers/raspi-status && docker compose up -d --build
cd ~/docker-stacks/custom-containers/ai-router && docker compose up -d --build
cd ~/docker-stacks/security && docker restart nginx
echo "✓ Tutti gli stack avviati!"
echo ""
