---
name: app-service-bad-deployment-rollback
description: "Use when an Azure App Service or deployment slot becomes unhealthy after a release, to investigate a bad deployment and safely plan, approve, execute, and verify a rollback."
argument-hint: "App name, resource group, slot, subscription, and incident symptoms"
---

# Azure App Service Bad Deployment Rollback

Guide an operator through a controlled rollback after a suspected bad App Service deployment. Do not equate correlation with cause, and do not change production without explicit approval.

## 1. Establish scope and impact

Confirm with the operator:

- Tenant and subscription, resource group, App Service name, region, and affected slot.
- User-visible symptoms, affected routes/regions, start time, and severity.
- The last deployment time and whether production was updated directly or through a slot swap.
- Whether rollback is authorized as a change, and who owns approval.

If the exact target is not confirmed, do not run commands that can change it. Do not print secret app settings.

## 2. Gather read-only evidence

Use the authenticated Azure CLI context only after confirming it matches the intended tenant and subscription. For example:

```powershell
az account show --query "{subscription:name, subscriptionId:id, tenantId:tenantId}" -o json
az webapp show --resource-group <resource-group> --name <app-name> --query "{name:name, state:state, location:location, hostNames:hostNames}" -o json
az webapp deployment slot list --resource-group <resource-group> --name <app-name> -o table
az webapp log tail --resource-group <resource-group> --name <app-name>
```

Use the applicable slot option for slot-specific inspection. Check available platform metrics and health checks through the configured monitoring tools. Avoid dumping environment variables, app settings, or deployment credentials.

Compare the incident window with deployment history, application errors, health probe results, and relevant platform metrics. State what is known, what is only suspected, and whether evidence supports a deployment regression.

## 3. Identify and validate a rollback target

Select a target only after confirming its release/build identifier and provenance from deployment history or the release pipeline. Confirm:

- The target is a known-good artifact or slot, not merely an older one.
- Its runtime, schema, and external dependencies remain compatible with current state.
- Any database or data migrations are backward-compatible; rolling application code back does not roll data back.
- Slot-specific settings, managed identities, networking, certificates, and warm-up behavior are understood.
- The operator has a way to validate recovery and an abort/escalation path.

If no verifiable safe target exists, stop and recommend the release owner or incident commander identify one. Do not invent a package path, release ID, or slot state.

## 4. Present the plan and obtain approval

Before any write operation, present:

1. Exact subscription, resource group, app, and slot(s).
2. Current release and the verified rollback release/slot.
3. The exact proposed operation and expected effects, including routing and warm-up implications.
4. Validation checks, success criteria, and abort/escalation criteria.

Wait for explicit user approval of that specific operation. Approval to investigate, diagnose, or prepare a plan is not approval to execute it. If approval or target changes, reconfirm before proceeding.

## 5. Execute only the approved rollback

Use the deployment system of record when possible to redeploy the verified immutable last-known-good artifact.

For a confirmed prior production version now residing in a staging slot after a swap, a reverse swap may be appropriate. Confirm actual slot contents and configuration first. A typical command shape is:

```powershell
az webapp deployment slot swap --resource-group <resource-group> --name <app-name> --slot <previous-production-slot> --target-slot production
```

Substitute only verified values. Do not run this example as-is. The correct source slot depends on the observed slot state; never infer it from the slot name alone. Do not delete slots, alter app settings, change routing, or redeploy a guessed artifact as part of this workflow.

## 6. Verify recovery and communicate

After the approved operation, check:

- The intended release is serving from the intended production slot.
- App state, health probes, representative routes, and error rates recover.
- Relevant latency and availability metrics return toward baseline.
- No new configuration, dependency, or data compatibility issues appeared.

Do not declare success based only on a successful CLI exit code. If validation fails or impact worsens, stop further changes, report the observed state, and escalate using the incident process.

Record the timeline, approval, exact operation, release identifiers, validation evidence, unresolved risks, and follow-up work. Preserve useful diagnostic evidence according to the team's retention policy.

## Related checklist

See [rollback checklist](./references/rollback-checklist.md) for a concise operator handoff.
