### What's changed in v0.5.1

* fix: probe celld's own health path, not the Worker's (#23) (by @patrickleet)

  /__celld/health reaches the deployed Worker once there is one; a Worker
  that answers it with 401 fails every probe and restarts the pod.
  celld 0.6 serves /.well-known/celld/health itself.


See full diff: [v0.5.0...v0.5.1](https://github.com/hops-ops/celld-chart/compare/v0.5.0...v0.5.1)
