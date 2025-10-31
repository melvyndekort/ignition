# Fedora IoT Server Configurations

This repository contains Butane configurations for setting up various servers on Fedora IoT.

## Available Configurations

- **pihole.bu**: Pihole DNS server with Unbound and Cloudflared
- **lmserver.bu**: Additional server configuration

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

### Prerequisites

Before deploying, you need to create the Cloudflared tunnel token file manually:

#### Required File

Create the following file on the target system:

```
/var/containers/cloudflared/tunnel-token
```

**File permissions:**
- Owner: 65532:65532 (nobody user)
- Mode: 0600 (read/write for owner only)

**Content:**
The file should contain your Cloudflare tunnel token (base64-encoded JSON).

#### Creating the file

1. Ensure the directory exists:
   ```bash
   sudo mkdir -p /var/containers/cloudflared
   ```

2. Create the token file:
   ```bash
   sudo tee /var/containers/cloudflared/tunnel-token << 'EOF'
   YOUR_TUNNEL_TOKEN_HERE
   EOF
   ```

3. Set correct ownership and permissions:
   ```bash
   sudo chown 65532:65532 /var/containers/cloudflared/tunnel-token
   sudo chmod 0600 /var/containers/cloudflared/tunnel-token
   ```

### Configuration Details

#### Pihole Web Interface
- Default password: `changeme`
- Change this password after first login or restore from backup

#### Security Notes
- The Cloudflare tunnel token is not included in this repository for security reasons
- Keep your tunnel token secure and rotate it regularly
- The pihole web password is set to "changeme" and should be changed for production use

---

## LM Server Configuration (lmserver.bu)

*Configuration details for lmserver.bu would go here*
