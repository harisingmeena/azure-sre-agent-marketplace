# Azure App Service and Front Door SRE

This plugin bundles:

- **Azure App Service and Front Door SRE** — a Copilot agent for evidence-based App Service incident response and Front Door WAF IP changes.
- **App Service bad-deployment rollback** — a skill for diagnosing a suspected bad release and planning, approving, executing, and verifying a rollback.
- **Front Door WAF IP block/allow** — a skill for investigating and safely planning scoped client-IP rules.

## Safety

The plugin does not include automation hooks or an MCP server. The agent may use the available terminal to inspect Azure resources, but must not perform a production-changing action without explicit user approval for the specific action and target. Never assume that the previous deployment is safe to restore; verify its identity and compatibility first. Front Door WAF policies can be shared across endpoints, and an `Allow` custom rule terminates WAF evaluation; verify the affected scope and explain this risk before proposing an allow rule.

## Prerequisites

- Azure CLI installed and authenticated to the intended tenant and subscription.
- Sufficient read permissions to inspect the target App Service and its deployment slots.
- For Front Door WAF changes, sufficient read permissions to inspect the profile, security-policy associations, WAF policy, and WAF diagnostics.
- For rollback, the appropriate write permissions and an explicitly approved change.
- For WAF changes, the appropriate write permissions and explicit approval of the exact IP/CIDR, rule, policy, and affected endpoints.

The user is responsible for ensuring the selected subscription and resource group are correct.
