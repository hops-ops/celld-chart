# celld Helm chart

Installs [celld](https://celld.dev) — Deno's self-hosted Durable Objects runtime — as a Kubernetes StatefulSet.

Each replica is a fleet node. Nodes coordinate through an object-storage bucket you own (S3, R2, GCS, or Azure Blob). There is no separate control plane.

## Install

```bash
helm repo add celld https://hops-ops.github.io/celld-chart
helm install celld celld/celld \
  --namespace celld \
  --create-namespace \
  --set celld.bucket=s3://my-cells-bucket \
  --set celld.region=us-east-2 \
  --set credentials.existingSecret=celld-aws
```

`credentials.existingSecret` should contain `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` (plus `AWS_SESSION_TOKEN` when using temporary credentials).

## Ports

| Port | Purpose |
|------|---------|
| 8080 | Public Worker / Durable Object HTTP |
| 8081 | Internal peer + operator API — keep off the public internet |

Health: `GET /__celld/health`.

## Values

See `values.yaml`. The stack XRD `CelldStack` (`hops-ops/celld-stack`) passes these through as Helm values.

## License

Apache-2.0
