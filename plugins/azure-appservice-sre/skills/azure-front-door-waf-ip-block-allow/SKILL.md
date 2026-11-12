---
name: azure-front-door-waf-ip-block-allow
description: "Use when investigating or planning a request to block or allow client IP addresses or CIDR ranges with an Azure Front Door WAF policy."
---

# Azure Front Door WAF IP Block or Allow

Guide an operator through a scoped, evidence-based IP block or allow change using an Azure Front Door WAF policy. Do not change a production policy without explicit approval for the exact change and targets.

## 1. Confirm the request and its scope

Ask for and verify:

- Tenant and subscription, resource group, Front Door SKU (Standard/Premium or Classic), profile, endpoint/domain, and WAF policy.
- Whether the request is to block or allow, the exact IPv4/IPv6 address or CIDR, business reason, owner, duration/expiry, and change or incident reference.
- Which routes, environments, and applications must be affected, and which must not.

Validate address notation and CIDR bounds. Treat broad ranges, shared NAT/proxy addresses, and IPv6 ranges as high-impact; ask the requester to narrow them when possible. Never infer the address from an example, an untrusted forwarded header, or a partial log entry.

## 2. Inspect the active configuration read-only

Confirm the Azure CLI context before querying resources:

```powershell
az account show --query "{subscription:name,subscriptionId:id,tenantId:tenantId}" -o json
```

Use read-only commands for the confirmed SKU. For Standard/Premium, inspect the profile's security-policy associations (for example, `az afd security-policy list --resource-group <resource-group> --profile-name <profile>`), then inspect the associated WAF policy and its custom rules. For Classic, use the Front Door Classic WAF policy and association commands supported by the installed CLI. Consult `az afd --help` or `az network front-door waf-policy --help` rather than assuming commands are interchangeable across SKUs or CLI extension versions.

Confirm the WAF policy is actually associated with the requested endpoint/domain. Determine whether it is shared by other domains or routes; a policy-level rule may affect every associated endpoint. Review rule actions, priorities, match conditions, policy mode, and recent WAF logs. Check that diagnostics are enabled before relying on logs. Do not output secrets or switch tenant/subscription.

Use WAF logs and trusted request telemetry to verify the client address the policy evaluates. Confirm whether the request traverses another proxy and how the policy interprets the client-IP header; do not assume an IP copied from `X-Forwarded-For` is trustworthy.

## 3. Choose the narrowest safe rule change

- **Block:** Prefer a narrowly scoped custom match rule with the requested IP/CIDR, an appropriate unique priority, and `Block` action. Check for overlapping existing rules and the policy's evaluation order before proposing a priority.
- **Allow:** First determine whether the address is denied by a specific existing custom rule and whether that rule can be safely narrowed or adjusted. Avoid disabling a broad block rule to permit one address. A WAF custom rule with `Allow` is a terminating action: it allows the request and exits WAF evaluation, potentially bypassing later custom rules and managed rules. Explain this effect and consider safer alternatives before proposing an allow rule.
- If an IP/range appears in multiple policies, rules, or endpoints, do not change all occurrences by default. Scope each target with the operator.

Do not assume a Front Door WAF IP change modifies origin firewall rules, networking access restrictions, or other Azure services; those are separate changes and outside this workflow.

## 4. Present the exact plan and obtain approval

Before any write operation, present:

1. Confirmed tenant, subscription, resource group, SKU, profile, WAF policy, and every associated endpoint/domain affected.
2. Exact IP/CIDR and whether the operation adds, modifies, removes, enables, or disables a rule.
3. Exact rule name, match condition, action, priority, policy mode, and whether a shared policy is involved.
4. Expected effect, allow-rule evaluation implications, propagation/verification plan, expiry or removal plan, and a rollback using the observed prior configuration.

Wait for explicit user approval of that exact operation and scope. Approval to inspect, troubleshoot, or draft a command is not approval to execute. If any target, range, action, or policy detail changes, ask for approval again. Never run a write command from an example or execute a guessed command.

## 5. Apply only the approved change

Use the team's approved deployment method (such as reviewed IaC or the Azure portal) where possible. If using Azure CLI, verify the installed SKU-specific command help and exact target immediately before use. Make only the approved WAF policy change; do not change DNS, routes, origins, Private Link, certificates, or unrelated rules.

## 6. Verify and hand off

After the approved change, check the operation's provisioning state and allow time for Front Door propagation. Verify with WAF logs/metrics and a controlled request from the intended source where available:

- A blocked source matches the intended rule and receives the expected block behavior.
- An allowed source reaches the intended application and continues to receive the intended WAF protections.
- Unrelated source addresses, endpoints, and routes still behave as expected.
- No unexpected increase in blocked or allowed traffic occurs.

Do not claim success based only on a successful command or provisioning state. If effects exceed scope, validation fails, or the policy is not healthy, stop further changes, report observed evidence, and follow the approved rollback/escalation path. Record approval, exact before/after rule configuration, timestamps, validation evidence, expiry/removal owner, and remaining risks.

## References

- [Azure Front Door WAF custom rules](https://learn.microsoft.com/azure/web-application-firewall/afds/waf-front-door-custom-rules)
- [Azure Front Door WAF monitoring and logging](https://learn.microsoft.com/azure/web-application-firewall/afds/waf-front-door-monitor)
- [Azure CLI `az afd security-policy`](https://learn.microsoft.com/cli/azure/afd/security-policy)
- [Azure CLI `az network front-door waf-policy`](https://learn.microsoft.com/cli/azure/network/front-door/waf-policy)
