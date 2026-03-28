# ignition

> For global standards, way-of-workings, and pre-commit checklist, see `~/.kiro/steering/behavior.md`

## Role

DevOps engineer and homelab enthusiast.

## What This Does

Butane configurations for provisioning Fedora IoT servers. Butane YAML is converted to Ignition JSON using the `butane` container tool. The Ignition files are served via a temporary nginx container for server provisioning.

## Repository Structure

- `src/` — Butane source files (`.bu`): `compute-1.bu`, `storage-1.bu`, `pihole.bu`
- `dist/` — Generated Ignition files (`.ign`) — do not edit directly
- `Makefile` — `convert` (butane → ignition), `serve` (nginx on port 8000), `clean`

## Important Notes

- No Terraform, no Python, no CI/CD pipeline
- Uses `podman` to run the butane converter and nginx
- Generated `.ign` files in `dist/` are the build artifacts

## Related Repositories

- `~/src/melvyndekort/homelab` — Docker Compose stacks that run on the provisioned servers
- `~/src/melvyndekort/network-documentation` — Documents the servers this provisions
