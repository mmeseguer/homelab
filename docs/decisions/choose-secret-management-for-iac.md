# Secret management for IaC

## Status

✅ **Accepted**

## Context and Problem Statement

When deploying the homelab we face the problem of handling the secrets for IaC (Terraform and Ansible) because we don't have a cluster already deployed to deploy a Vault solution.

Having the secrets without any encryption in Git is not an option.

## Considered Options

* Azure Key Vault
* Local vault inside the cluster (after it being deployed)
* [Ansible vault](https://docs.ansible.com/projects/ansible/latest/vault_guide/index.html)
* [SOPS](https://github.com/getsops/sops)

## Decision Outcome

Chosen option: **Ansible Vault**, because I don't want to overcomplicate the setup at this step, as I'm more focused in the Kubernetes side of the homelab.

Ansible vault comes with one of the tools that I'll use for IaC and is well integrated with it. On the other hand, the solution is really simple but provides good encryption of the secrets.

If I would be changing things daily or this would be an Enterprise solution my choice would have easily been Azure Key Vault.

### Consequences

- I'm not depending on a Cloud Provider for this
- No extra infrastructure is deployed
- Some friction when using IaC tools