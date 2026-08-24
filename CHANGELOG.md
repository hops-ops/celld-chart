### What's changed in v0.4.0

* chore(deps): update docker.io/alpine/socat docker tag to v1.8.1.3 (#4) (by @renovate[bot])

  Co-authored-by: renovate[bot] <29139614+renovate[bot]@users.noreply.github.com>

* chore(deps): update mcr.microsoft.com/azure-cli docker tag to v2.89.1 (#5) (by @renovate[bot])

  Co-authored-by: renovate[bot] <29139614+renovate[bot]@users.noreply.github.com>

* chore(deps): update mcr.microsoft.com/azure-storage/azurite docker tag to v3.36.0 (#6) (by @renovate[bot])

  Co-authored-by: renovate[bot] <29139614+renovate[bot]@users.noreply.github.com>

* chore(deps): update unbounded-tech/workflow-vnext-tag action to v1.22.2 (#1) (by @renovate[bot])

  Co-authored-by: renovate[bot] <29139614+renovate[bot]@users.noreply.github.com>

* feat: mount hops AWS shared-credentials for S3 (by @patrickleet)

  Parse the hops local aws INI Secret into AWS_* env vars so celld
  can use the same CLI session that creates the bucket.

  Implements [[tasks/celld-stack]]


See full diff: [v0.3.1...v0.4.0](https://github.com/hops-ops/celld-chart/compare/v0.3.1...v0.4.0)
