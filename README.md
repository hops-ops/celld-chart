# celld Helm chart

Installs [celld](https://celld.dev) — Deno's self-hosted Durable Objects runtime — as a Kubernetes StatefulSet.

Each replica is a fleet node. Nodes coordinate through an object-storage bucket you own (S3, R2, GCS, or Azure Blob). There is no separate control plane.

## Install

AWS / production bucket:

```bash
helm repo add celld https://hops-ops.github.io/celld-chart
helm install celld celld/celld \
  --namespace celld \
  --create-namespace \
  --set celld.bucket=s3://my-cells-bucket \
  --set celld.region=us-east-2 \
  --set credentials.existingSecret=celld-aws
```

AWS S3 (credentials via a Secret with `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`):

```bash
helm install celld celld/celld \
  --namespace celld \
  --create-namespace \
  --set celld.bucket=s3://my-cells-bucket \
  --set celld.region=us-east-2 \
  --set credentials.existingSecret=celld-aws \
  --set bootstrapPlaceholder=true
```

Local / kind (in-cluster Azurite, same shape as `distributed/tests/celld/docker-compose.yml`):

```bash
helm install celld celld/celld \
  --namespace celld \
  --create-namespace \
  --set azurite.enabled=true
```

Azurite is a development store. celld's emulator client always uses `127.0.0.1:10000`; the chart runs a socat sidecar that forwards that port to the Azurite Service.

`celld dev` (local object store, one Wrangler project, no fleet bucket):

```bash
helm install celld celld/celld \
  --namespace celld \
  --create-namespace \
  --set dev.enabled=true \
  --set dev.hostPath=/path/visible/on/the/node/to/wrangler-project
```

`dev.hostPath` empty uses the chart's placeholder worker and `--no-watch`. The node path must be visible inside the cluster (kind extraMounts / hostPath). Dev mode forces one replica and ignores `azurite` and `celld.bucket`. Health is `GET /.well-known/celld/health`.

`credentials.existingSecret` should contain `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` (plus `AWS_SESSION_TOKEN` when using temporary credentials).

For hops `local aws` (INI file under Secret key `credentials`):

```bash
helm install celld celld/celld \
  --namespace celld \
  --create-namespace \
  --set celld.bucket=s3://my-cells-bucket \
  --set celld.region=us-east-2 \
  --set credentials.sharedCredentialsSecret=aws-creds \
  --set bootstrapPlaceholder=true
```

## Ports

| Port | Purpose |
|------|---------|
| 8080 | Public Worker / Durable Object HTTP |
| 8081 | Internal peer + operator API — keep off the public internet |

Health: `GET /__celld/health` (fleet). Dev mode uses `GET /.well-known/celld/health`.

## Values

See `values.yaml`. The stack XRD `CelldStack` (`hops-ops/celld-stack`) passes these through as Helm values.

## License

Apache-2.0
