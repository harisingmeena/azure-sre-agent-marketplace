# Azure SRE Agent Marketplace

A VS Code Copilot agent-plugin marketplace containing an Azure App Service SRE agent and a deployment rollback skill.

## Contents

- `plugins/azure-appservice-sre/` — installable Agent Plugins 1.0 package
- `.github/plugin/marketplace.json` — marketplace catalog

## Use locally

In VS Code, open **Chat: Install Plugin from Source** and select the `plugins/azure-appservice-sre` folder. Alternatively, add this repository as a marketplace in the Agent Customizations editor.

Before publishing this marketplace repository, replace `OWNER/REPOSITORY` in `.github/plugin/marketplace.json` with its GitHub owner and repository name.

The agent and skill provide operational guidance only. The rollback workflow requires explicit approval before any production-changing operation; review the target app, slot, release, and current health before approving.

## Included workflow

Use the **Azure App Service SRE** agent to investigate a suspected bad deployment. The `app-service-bad-deployment-rollback` skill guides triage, selection of a verified rollback target, approval, rollback, and post-change validation.

## Marketplace registration

Once published to GitHub, add this repository as a plugin marketplace in VS Code's Agent Customizations editor. Review marketplace contents and publisher before installing.
