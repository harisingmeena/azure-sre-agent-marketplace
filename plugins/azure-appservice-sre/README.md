# Azure App Service SRE

This plugin bundles:

- **Azure App Service SRE** — a Copilot agent for evidence-based App Service incident response.
- **App Service bad-deployment rollback** — a skill for diagnosing a suspected bad release and planning, approving, executing, and verifying a rollback.

## Safety

The plugin does not include automation hooks or an MCP server. The agent may use the available terminal to inspect Azure resources, but must not perform a production-changing action without explicit user approval for the specific action and target. Never assume that the previous deployment is safe to restore; verify its identity and compatibility first.

## Prerequisites

- Azure CLI installed and authenticated to the intended tenant and subscription.
- Sufficient read permissions to inspect the target App Service and its deployment slots.
- For rollback, the appropriate write permissions and an explicitly approved change.

The user is responsible for ensuring the selected subscription and resource group are correct.
