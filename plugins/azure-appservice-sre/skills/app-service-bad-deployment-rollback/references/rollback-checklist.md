# App Service rollback checklist

## Before the change

- [ ] Confirm tenant, subscription, resource group, app, region, and slot.
- [ ] Record incident symptoms, start time, and impact.
- [ ] Correlate deployment history with logs, health checks, and metrics.
- [ ] Verify the rollback release or slot by identifier and provenance.
- [ ] Check schema/data and external dependency compatibility.
- [ ] Confirm slot settings, identity, network, certificate, and warm-up behavior.
- [ ] Share exact target, action, impact, validation, and abort criteria.
- [ ] Obtain explicit approval for this specific production change.

## After the change

- [ ] Confirm the intended release and slot are serving traffic.
- [ ] Verify app state, health checks, representative routes, and error rate.
- [ ] Compare availability and latency with the pre-incident baseline.
- [ ] Escalate if recovery is not verified; do not make further unapproved changes.
- [ ] Record the timeline, release identifiers, approval, action, and evidence.
