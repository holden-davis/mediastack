#!/usr/bin/bash
set -e

#################################################################################
#################################################################################
##
##  MediaStack Server Setup Script
##  This script prepares a fresh Ubuntu Server installation for MediaStack
##
##  Run as: sudo ./setup-server.sh
##
##  This script will:
##  1. Update system packages
##  2. Install Docker and Docker Compose
##  3. Install dependencies (git, curl, wget, yq, xmllint, etc)
##  4. Create required folders and permissions
##  5. Set up docker user group
##  6. Configure folder structure for MediaStack
##
#################################################################################
#################################################################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: This script must be run as root (use sudo)${NC}"
    exit 1
fi

echo -e "${GREEN}"
echo "=========================================="
echo "  MediaStack Server Setup Script"
echo "=========================================="
echo -e "${NC}"

# Configuration variables
DOCKER_FOLDER=/docker/mediastack
APPDATA_FOLDER=/docker/appdata
MEDIA_FOLDER=/mnt/media
DOCKER_USER=docker
DOCKER_UID=1000
DOCKER_GID=1000

# Step 1: Update system
echo -e "${YELLOW}[1/6] Updating system packages...${NC}"
apt-get update
apt-get upgrade -y
apt-get install -y curl wget git build-essential

# Step 2: Install Docker
echo -e "${YELLOW}[2/6] Installing Docker and Docker Compose...${NC}"
if command -v docker &> /dev/null; then
    echo "Docker is already installed: $(docker --version)"
else
    # Add Docker's official GPG key
    apt-get install -y ca-certificates curl gnupg lsb-release
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    # Set up Docker repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Install Docker
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    
    echo -e "${GREEN}✓ Docker installed successfully${NC}"
fi

# Step 3: Install dependencies
echo -e "${YELLOW}[3/6] Installing dependencies (yq, xmllint, etc)...${NC}"
apt-get install -y \
    git \
    curl \
    wget \
    jq \
    yq \
    libxml2-utils \
    net-tools \
    htop \
    vim \
    nano

echo -e "${GREEN}✓ Dependencies installed${NC}"

# Step 4: Create docker user and group
echo -e "${YELLOW}[4/6] Setting up docker user group...${NC}"

# Create docker group if it doesn't exist
if ! getent group $DOCKER_GID > /dev/null; then
    groupadd -g $DOCKER_GID $DOCKER_USER
    echo -e "${GREEN}✓ Docker group created${NC}"
else
    echo "Docker group already exists"
fi

# Add current user to docker group (if not root)
if [ -n "$SUDO_USER" ]; then
    usermod -aG $DOCKER_USER $SUDO_USER
    echo -e "${GREEN}✓ User '$SUDO_USER' added to docker group${NC}"
    echo "NOTE: You may need to log out and back in for group membership to take effect"
fi

# Step 5: Create folder structure
echo -e "${YELLOW}[5/6] Creating folder structure...${NC}"

# Create main folders
mkdir -p $DOCKER_FOLDER
mkdir -p $APPDATA_FOLDER
mkdir -p $MEDIA_FOLDER

# Create appdata subfolders
mkdir -p $APPDATA_FOLDER/{authentik/{certs,media,templates},bazarr,chromium,crowdsec/data,ddns-updater,filebot,gluetun,grafana,headplane/data,headscale/data,heimdall,homarr/{configs,data,icons},homepage,huntarr,jellyfin,jellyseerr,logs/{unpackerr,traefik},mylar,portainer,postgresql,prometheus,prowlarr,qbittorrent,radarr,sabnzbd,sonarr,tailscale,tdarr/{server,configs,logs},tdarr-node,traefik/letsencrypt,traefik-certs-dumper,unpackerr,valkey}

# Create media subfolders
mkdir -p $MEDIA_FOLDER/media/{anime,audio,books,comics,movies,music,photos,tv,xxx}
mkdir -p $MEDIA_FOLDER/usenet/{anime,audio,books,comics,complete,console,incomplete,movies,music,prowlarr,software,tv,xxx}
mkdir -p $MEDIA_FOLDER/torrent/{anime,audio,books,comics,complete,console,incomplete,movies,music,prowlarr,software,tv,xxx}

echo -e "${GREEN}✓ Folders created${NC}"

# Step 6: Set permissions
echo -e "${YELLOW}[6/6] Setting folder permissions...${NC}"

# Set ownership and permissions for appdata
chown -R $DOCKER_UID:$DOCKER_GID $APPDATA_FOLDER
chmod -R 755 $APPDATA_FOLDER

# Set ownership and permissions for media
chown -R $DOCKER_UID:$DOCKER_GID $MEDIA_FOLDER
chmod -R 755 $MEDIA_FOLDER

# Set ownership for docker folder
chown -R $DOCKER_UID:$DOCKER_GID $DOCKER_FOLDER
chmod -R 755 $DOCKER_FOLDER

echo -e "${GREEN}✓ Permissions set${NC}"

# Step 7: Verify Docker installation
echo -e "${YELLOW}[7/7] Verifying Docker installation...${NC}"
docker --version
docker compose version

echo -e "${GREEN}"
echo "=========================================="
echo "  Setup Complete!"
echo "=========================================="
echo -e "${NC}"

echo ""
echo "Folder Structure Created:"
echo "  - Docker configs:  $DOCKER_FOLDER"
echo "  - App data:        $APPDATA_FOLDER"
echo "  - Media storage:   $MEDIA_FOLDER"
echo ""
echo "Docker User: $DOCKER_USER (UID: $DOCKER_UID, GID: $DOCKER_GID)"
echo ""
echo "Next Steps:"
echo "  1. Copy your mediastack files to: $DOCKER_FOLDER"
echo "  2. Edit the .env file with your specific settings"
echo "  3. Add ProtonVPN credentials to the .env file"
echo "  4. Run: cd $DOCKER_FOLDER && docker compose up -d"
echo ""
echo "If you added a user to the docker group, log out and back in to apply changes."
echo ""
