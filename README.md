# docker-stacks

## Struttura

```
~/docker-stacks/
├── .env                              ← segreti, MAI su git
├── .gitignore
├── nftables.conf                     ← firewall di sistema
├── general/
│   └── docker-compose.yml            ← homeassistant, mosquitto, watchtower, portainer
├── ai-tools/
│   └── docker-compose.yml            ← ollama, open-webui, n8n
├── security/
│   ├── docker-compose.yml            ← pihole, crowdsec, nginx, wireguard
│   └── nginx/
│       ├── nginx.conf
│       ├── proxy_params
│       ├── logs/                     ← ignorata da git
│       └── conf.d/
│           ├── ha.conf
│           ├── ai.conf
│           ├── n8n.conf
│           ├── pihole.conf
│           ├── portainer.conf
│           └── router.conf
└── custom-containers/
    ├── rasp-status/
    │   ├── docker-compose.yml
    │   └── Dockerfile + .py
    └── ai-router/
        ├── docker-compose.yml
        └── Dockerfile + .py
```

---

## Setup iniziale

```bash
# 1. Git
sudo apt install git -y
git config --global user.name "Nome"
git config --global user.email "email@example.com"
cd ~/docker-stacks
git init
git add .
git commit -m "primo commit"
git remote add origin https://github.com/tuoutente/docker-stacks.git
git push -u origin main

# 2. Rete Docker (una volta sola)
docker network create internal_net

# 3. Compila .env con le tue password vere
nano .env

# 4. Firewall — controlla prima l'interfaccia
ip link show
sudo cp nftables.conf /etc/nftables.conf
sudo systemctl enable nftables
sudo systemctl start nftables
sudo nft list ruleset  # verifica

# 5. Security stack (ordine obbligatorio)
cd security
docker compose up -d crowdsec
docker exec crowdsec cscli bouncers add nginx-bouncer
# → copia la chiave nel .env → CROWDSEC_BOUNCER_API_KEY
docker compose up -d

# 6. Altri stack
cd ../general   && docker compose up -d
cd ../ai-tools  && docker compose up -d
cd ../custom-containers/rasp-status  && docker compose up -d
cd ../custom-containers/ai-router    && docker compose up -d

# 7. Pi-hole come DNS del router
# → pannello router → DNS primario: 192.168.0.30
# → DNS secondario: 1.1.1.1
```

---

## Comandi utili

```bash
# Stato di tutti i container
docker ps

# Log in tempo reale
docker logs crowdsec -f
docker logs nginx -f

# Test config nginx
docker exec nginx nginx -t

# Reload nginx
docker exec nginx nginx -s reload

# CrowdSec — IP bannati
docker exec crowdsec cscli decisions list

# WireGuard — QR code per un peer
docker exec wireguard cat /config/peer_macbook/peer_macbook.conf
```

---

## .env — ricorda

- Cambia `PIHOLE_WEBPASSWORD` subito
- `WG_SERVERURL` = il tuo IP pubblico (`curl ifconfig.me`)
- `CROWDSEC_BOUNCER_API_KEY` si genera al primo avvio (vedi step 5)
- `BASE44_API_KEY` = la tua chiave API di Base44
