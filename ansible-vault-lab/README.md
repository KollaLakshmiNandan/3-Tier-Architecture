# Automate Operations with Ansible and Vault

## Project Overview

This project demonstrates Linux operations automation using Ansible
and secure application configuration using Ansible Vault.

## Architecture

- Control Node: macOS Mac mini with Ansible installed
- Managed Node: Ubuntu 24.04 VM running in Multipass
- Connection: SSH using an Ed25519 key
- Operations: Nginx installation, service management, and status page deployment
- Secret Management: Ansible Vault encrypted YAML configuration

## Project Structure

ansible-vault-lab/
├── ansible.cfg
├── inventory/
│   └── hosts.ini
├── group_vars/
│   └── linux_servers.yml
├── playbooks/
│   ├── operations.yml
│   └── secure_operations.yml
├── evidence/
│   ├── operations-idempotency.txt
│   └── vault-success.txt
└── README.md

## Operations Automation

The operations playbook:
1. Installs Nginx using the Ansible apt module.
2. Ensures the Nginx service is running and enabled.
3. Deploys an operations status page with controlled file permissions.

## Secret Management

Ansible Vault encrypts application configuration containing the
application name, environment, and a dummy API token.

The secure operations playbook:
1. Loads the encrypted configuration.
2. Validates required configuration values.
3. Displays non-sensitive settings while redacting the token.

## Testing and Results

- Ansible connectivity test: Passed.
- Nginx service verification: Passed.
- Status page deployment: Passed.
- Idempotency test: Passed; second operations run reported changed=0.
- Vault configuration validation: Passed.
- Intentional assertion failure and recovery: Passed.

## Commands

Check connectivity:

    ansible linux_servers -m ansible.builtin.ping

Run operations automation:

    ansible-playbook playbooks/operations.yml

Run secure configuration validation:

    ansible-playbook playbooks/secure_operations.yml --ask-vault-pass

View encrypted configuration:

    ansible-vault view group_vars/linux_servers.yml --ask-vault-pass

Edit encrypted configuration:

    ansible-vault edit group_vars/linux_servers.yml

## Security Notes

- Never commit the Vault password or real credentials.
- Do not commit private SSH keys.
- Keep real secrets out of logs and evidence files.
- Use a dummy token for demonstrations.
