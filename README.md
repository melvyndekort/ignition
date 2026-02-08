# Fedora IoT Server Configurations

This repository contains Butane configurations for setting up various servers on Fedora IoT.

## Available Configurations

- **pihole.bu**: Pihole DNS server with Unbound and Cloudflared
- **storage-1.bu**: Storage server with NFS exports and BTRFS
- **compute-1.bu**: Compute server for Docker containers
- **lmserver.bu**: Legacy server configuration (deprecated)

## Installing Fedora CoreOS

### Prerequisites

1. Download the Fedora CoreOS ISO:
```bash
podman run --pull=always --rm -v .:/data -w /data \
    quay.io/coreos/coreos-installer:release download -s stable -p metal -f iso
```

2. Build the ignition files (or let GitHub Actions do it):
```bash
make
```

### Installation Methods

#### Method 1: Interactive Install

1. Create bootable USB with the ISO
2. Boot target machine from USB
3. Serve ignition file from your network:
```bash
make serve  # Serves on http://localhost:8080
```
4. Install from the booted system:
```bash
sudo coreos-installer install /dev/nvme0n1 \
    --ignition-url http://YOUR_IP:8080/compute-1.ign
```
5. Reboot

#### Method 2: Automated Install

Create a customized ISO that auto-installs:
```bash
coreos-installer iso customize \
    --dest-device /dev/nvme0n1 \
    --dest-ignition dist/compute-1.ign \
    -o compute-1-auto.iso fedora-coreos-*.iso
```

Boot from this ISO - it will install automatically without interaction.

## Available Configurations

## Building and Deployment

### Using the Makefile

Convert all Butane files to Ignition files:
```bash
make convert
```

Convert and serve all ignition files over HTTP:
```bash
make serve
```

The `serve` target will start an nginx container on http://localhost:8080 serving the ignition files.

### Manual Conversion

Convert specific files manually:
```bash
docker run --rm -v "$(pwd)":/pwd -w /pwd quay.io/coreos/butane:release --pretty --strict src/<filename>.bu > dist/<filename>.ign
```

### Deployment

Deploy to your Fedora IoT system using the generated ignition file during installation or first boot.

## General Configuration Notes

### User Account
- Username: `core`
- Password: Set via password hash in butane files (change for production)
- SSH access: Configured with YubiKey SSH keys

### Security Notes
- SSH keys and password hash in the butane files should be updated for your environment
- Consider using a private repository if you customize the butane files with your credentials

---

## Pihole Configuration (pihole.bu)

### Services
- **Unbound**: DNS resolver on port 5335
- **Pihole**: DNS filter on port 53
- **Cloudflared**: Cloudflare tunnel
- **Caddy**: HTTPS reverse proxy for Pihole web interface
- **Keepalived**: VRRP for high availability
- **Beszel Agent**: Monitoring agent

### Prerequisites

Before deploying, you need to create the following files manually:

#### Cloudflare Tunnel Token

Create the following file on the target system:

```
/var/containers/cloudflared/tunnel-token
```

**File permissions:**
- Owner: 65532:65532 (nobody user)
- Mode: 0600 (read/write for owner only)

**Content:**
The file should contain your Cloudflare tunnel token (base64-encoded JSON).

#### Cloudflare API Token for Caddy

Create the following file on the target system:

```
/etc/cloudflare-api-token
```

**File permissions:**
- Owner: root:root
- Mode: 0600 (read/write for owner only)

**Content:**
The file should contain your Cloudflare API token with Zone Read and DNS Write permissions for mdekort.nl.

#### Creating the files

1. Ensure the directories exist:
   ```bash
   sudo mkdir -p /var/containers/cloudflared
   ```

2. Create the tunnel token file:
   ```bash
   sudo tee /var/containers/cloudflared/tunnel-token << 'EOF'
   YOUR_TUNNEL_TOKEN_HERE
   EOF
   sudo chown 65532:65532 /var/containers/cloudflared/tunnel-token
   sudo chmod 0600 /var/containers/cloudflared/tunnel-token
   ```

3. Create the Cloudflare API token file:
   ```bash
   sudo tee /etc/cloudflare-api-token << 'EOF'
   YOUR_CLOUDFLARE_API_TOKEN_HERE
   EOF
   sudo chmod 0600 /etc/cloudflare-api-token
   ```

### Configuration Details

#### Pihole Web Interface
- HTTP: http://pihole-1.mdekort.nl (port 80)
- HTTPS: https://pihole-1.mdekort.nl (port 443, via Caddy reverse proxy)
- Default password: `changeme`
- Change this password after first login or restore from backup

#### Security Notes
- The Cloudflare tunnel token is not included in this repository for security reasons
- The Cloudflare API token for Caddy is not included in this repository for security reasons
- Keep your tokens secure and rotate them regularly
- The pihole web password is set to "changeme" and should be changed for production use
- Caddy automatically obtains and renews Let's Encrypt certificates via Cloudflare DNS challenge

---

## LM Server Configuration (lmserver.bu)

*Configuration details for lmserver.bu would go here*
