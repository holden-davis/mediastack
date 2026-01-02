# MediaStack Configuration Documentation

This document tracks all modifications and changes made to the MediaStack configuration for the home server setup.

---

## Folder Structure Reorganization

**Date & Time:** January 2, 2026 - 12:25 UTC

**Description:** Flattened the project structure by moving all necessary files from `full-download-vpn/` and `base-working-files/` directories into the root folder. This simplifies the repository structure and consolidates all configuration files for easier management and deployment.

**Changes Made:**
- Moved `docker-compose.yaml` from `full-download-vpn/` to root
- Moved all configuration files from `base-working-files/` (including env, shell scripts, config files, and bookmark imports) to root
- Deleted unnecessary folders: `archived-old-configs/`, `mini-download-vpn/`, and `no-download-vpn/`
- Kept `full-download-vpn/` README for reference (can be reviewed and removed later if needed)

**Rationale:** The full-download-vpn configuration is the recommended approach for the setup, routing all media downloads through the Gluetun VPN tunnel for maximum privacy. The base-working-files contain all essential configuration templates needed for deployment.

---

## Server Configuration Customization

**Date & Time:** January 2, 2026 - 12:30 UTC

**Description:** Customized base configuration files for the cephalonsimaris home server setup with specific paths, IP address, and ProtonVPN settings.

**Changes Made:**

**.env file updates:**
- Set `LOCAL_DOCKER_IP=192.168.1.230` (cephalonsimaris internal IP)
- Set `FOLDER_FOR_MEDIA=/mnt/media` (1TB HDD for media storage)
- Set `FOLDER_FOR_DATA=/docker/appdata` (256GB SSD for application data)
- Set `TIMEZONE=UTC` (can be adjusted as needed)
- Set `VPN_SERVICE_PROVIDER=protonvpn` (ProtonVPN as specified)
- Updated VPN placeholders: `VPN_USERNAME` and `VPN_PASSWORD` await ProtonVPN credentials
- Cleared server region restrictions to allow Gluetun to choose optimal ProtonVPN servers

**Bash script updates:**
- Updated `restart.sh` folder path to `/docker/mediastack`
- Updated `get-apikeys.sh` with correct paths:
  - `FOLDER_FOR_YAMLS=/docker/mediastack`
  - `FOLDER_FOR_MEDIA=/mnt/media`

**Next Steps:** 
- ProtonVPN credentials need to be added to `.env` file before deployment
- Verify PUID/PGID values match the nobodyatall user on the server
- Test configuration on Ubuntu Server VM before deploying to cephalonsimaris

---

## Server Setup Script Creation

**Date & Time:** January 2, 2026 - 12:45 UTC

**Description:** Created comprehensive server initialization script (`setup-server.sh`) to automate setup of a fresh Ubuntu Server installation with all prerequisites for MediaStack deployment.

**Script Features:**
- Updates system packages to latest versions
- Installs Docker and Docker Compose with official repositories
- Installs all dependencies (git, curl, wget, yq, xmllint, jq, net-tools, htop, vim, nano)
- Creates docker user group with UID/GID 1000 for permission management
- Creates complete folder structure:
  - `/docker/mediastack` - Docker compose files and configs
  - `/docker/appdata` - All application persistent data (22 subdirectories)
  - `/mnt/media` - Media storage with anime, audio, books, comics, movies, music, photos, tv, xxx categories
  - Separate torrent and usenet download folders with matching category structure
- Sets proper ownership (1000:1000) and permissions (755) on all folders
- Verifies Docker installation before completion
- Provides clear next steps and usage instructions

**Usage:**
```bash
sudo ./setup-server.sh
```

**Notes:**
- Must be run with sudo on a fresh Ubuntu Server installation
- PUID and PGID are set to 1000 (standard user/group)
- User running sudo is automatically added to the docker group
- User may need to log out/in for docker group membership to take effect

---

## Docker Image Fix: Whisparr

**Date & Time:** January 2, 2026 - 12:50 UTC

**Description:** Fixed unavailable Whisparr Docker image. The `hotio/whisparr:nightly` image repository is either private or no longer available.

**Changes Made:**
- Updated Whisparr image from `hotio/whisparr:nightly` to `linuxserver/whisparr:latest`
- Updated docker-compose.yaml comment to reflect LinuxServer.io as the source

**Rationale:** LinuxServer.io maintains actively supported and publicly available images for all the *ARR applications used in MediaStack. This ensures consistent availability and reliability.

---

## Docker Image Fixes: Multiple Missing Tags

**Date & Time:** January 2, 2026 - 12:55 UTC

**Description:** Fixed multiple Docker images with missing tags or unstable tags that were causing pull access errors.

**Changes Made:**
- Prometheus: `prom/prometheus` → `prom/prometheus:latest`
- Prowlarr: `lscr.io/linuxserver/prowlarr:develop` → `lscr.io/linuxserver/prowlarr:latest`
- Readarr: `lscr.io/linuxserver/readarr:develop` → `lscr.io/linuxserver/readarr:latest`
- Unpackerr: `golift/unpackerr` → `golift/unpackerr:latest`

**Rationale:** Develop/nightly tags and untagged images are unstable and may not be publicly available. Using :latest tags ensures we get stable, publicly available releases from all sources.

---

## Docker Image Fix: Whisparr

**Date & Time:** January 2, 2026 - 13:00 UTC

**Description:** Corrected Whisparr Docker image source. LinuxServer.io does not maintain a Whisparr image - the official image is from the Servarr project on GitHub Container Registry.

**Changes Made:**
- Whisparr: `linuxserver/whisparr:latest` → `ghcr.io/servarr/whisparr:nightly`

**Rationale:** Whisparr is maintained by the Servarr organization and hosted on GitHub Container Registry (ghcr.io). This is the official and supported image source for Whisparr.

---

## Docker Service Disabled: Whisparr

**Date & Time:** January 2, 2026 - 13:05 UTC

**Description:** Disabled the Whisparr service in docker-compose.yaml due to lack of available public Docker images.

**Issue:** Whisparr does not have an official Docker image. The Servarr wiki recommends using `hotio/whisparr`, but this image is currently unavailable (access denied). No other public images are officially supported or reliably maintained.

**Action Taken:**
- Commented out the entire Whisparr service in docker-compose.yaml
- Added detailed comment explaining why it's disabled
- Included link to wiki documentation for future reference

**To Re-enable:**
When a stable public Docker image becomes available, users can:
1. Uncomment the Whisparr service in docker-compose.yaml
2. Update the image source in the configuration
3. Run `docker compose up -d whisparr`

**Note:** Users can still request adult content through Readarr for eBooks/comics, which is still available. Whisparr functionality can be restored once Docker image availability improves.

---

## Services Removed: Plex, Lidarr, Readarr, Whisparr

**Date & Time:** January 2, 2026 - 13:15 UTC

**Description:** Removed four media services from the MediaStack configuration to streamline the deployment and reduce complexity.

**Services Removed:**
1. **Plex** - Media server (user prefers Jellyfin)
2. **Lidarr** - Music library manager (user not managing music library)
3. **Readarr** - eBook/comic library manager (user not managing books)
4. **Whisparr** - Adult content manager (previously disabled due to image unavailability)

**Changes Made:**
- Removed all four service definitions from `docker-compose.yaml`
- Removed all related port mappings from Gluetun container
- Removed all related environment variable configurations from Unpackerr
- Removed `PLEX_CLAIM`, `WEBUI_PORT_PLEX`, `WEBUI_PORT_LIDARR`, `WEBUI_PORT_READARR`, `WEBUI_PORT_WHISPARR` from `.env` file
- Updated `setup-server.sh` folder creation to remove lidarr, plex, readarr, and whisparr directories
- Removed all Traefik router configurations for these services

**Retained Services:**
- Jellyfin (primary media server)
- Jellyseerr (media requests for Jellyfin)
- Radarr (movies)
- Sonarr (TV shows)
- Mylar (comics)
- All download clients and support services

**Result:** Cleaner, more focused configuration with only the services needed for the user's media stack.

---

## PostgreSQL Configuration Fix

**Date & Time:** January 2, 2026 - 13:20 UTC

**Description:** Fixed PostgreSQL container unhealthy status by removing the user directive that was preventing proper database initialization.

**Issue:** PostgreSQL container was failing healthcheck. The service was configured to run as user 1000:1000, which caused permission issues during database initialization.

**Solution:** Removed `user: ${PUID:?err}:${PGID:?err}` from PostgreSQL service definition. PostgreSQL must run as root (or at least with proper permissions) to initialize the database directories and handle authentication properly.

**Note:** PostgreSQL container will now run as root within the container (uid 0), which is the standard for PostgreSQL Docker images. This does not compromise security as the container is isolated in the mediastack network.

---

## PostgreSQL 18 Data Path Fix

**Date & Time:** January 2, 2026 - 13:25 UTC

**Description:** Updated PostgreSQL volume mount path to use PostgreSQL 18+ default data directory structure.

**Issue:** PostgreSQL 18 changed the default data directory path from `/var/lib/postgresql/data` to `/var/lib/postgresql/18/data`. The compose file was using the old path.

**Solution:** Updated volume mount in docker-compose.yaml:
```yaml
volumes:
  - ${FOLDER_FOR_DATA:?err}/postgresql:/var/lib/postgresql/18/data
```

**Reference:** [MediaStack GitHub Issue #55](https://github.com/geekau/mediastack/issues/55)

**Result:** PostgreSQL container now starts successfully and passes healthcheck.

---
