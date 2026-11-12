# Azure SRE Agent Marketplace

A VS Code Copilot agent-plugin marketplace containing an Azure App Service and Front Door SRE agent, a deployment rollback skill, and a Front Door WAF IP block/allow skill.

## Contents

- `plugins/azure-appservice-sre/` — installable Agent Plugins 1.0 package
- `.github/plugin/marketplace.json` — marketplace catalog

## Use locally

In VS Code, open **Chat: Install Plugin from Source** and select the `plugins/azure-appservice-sre` folder. Alternatively, add this repository as a marketplace in the Agent Customizations editor.

## Install from this repository

On Windows, clone this repository and run the installer from PowerShell:

```powershell
.\scripts\install-vscode-plugin.ps1
```

The script opens the VS Code install prompt for the `azure-appservice-sre` plugin from this repository. Review the publisher and plugin, then confirm the prompts in VS Code. The script does not install silently or bypass VS Code's trust and security prompts. Plugin support must be enabled in VS Code, and Copilot Agent Host must be available.

You can also open this install link directly:

```text
vscode://chat-plugin/install?source=harisingmeena%2Fazure-sre-agent-marketplace&plugin=azure-appservice-sre
```

The marketplace source is configured for this GitHub repository. The agent and skills provide operational guidance only and require explicit approval before any production-changing operation. For rollback, verify the target app, slot, release, and current health. For Front Door WAF changes, verify the associated endpoints and note that an `Allow` custom rule terminates WAF evaluation.

## Included workflows

Use the **Azure App Service and Front Door SRE** agent for App Service incidents or Front Door WAF IP block/allow requests. The `app-service-bad-deployment-rollback` skill guides triage, selection of a verified rollback target, approval, rollback, and post-change validation. The `azure-front-door-waf-ip-block-allow` skill guides scoped client-IP rules, WAF policy impact review, explicit approval, and verification.

Both workflows provide operational guidance only and require explicit approval before a production-changing operation. A Front Door WAF `Allow` custom rule terminates WAF evaluation and can bypass later rules.

## Marketplace registration

To browse the marketplace without installing directly, add this repository in VS Code's Agent Customizations editor. Review marketplace contents and publisher before installing.
