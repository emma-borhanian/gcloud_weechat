# Personal configuration for running weechat on google cloud

# Setup
* Install [docker](http://docs.docker.com/)
* [Configure gcloud](https://cloud.google.com/container-engine/docs/before-you-begin) with a default zone
* setup `.env`:
```bash
export CLOUDSDK_CORE_PROJECT=# google cloud project ID (required even if configured via gcloud)
export WEECHAT_PASSWORD=#password for weechat relay service
```
* Run `bin/setup`
* Run `bin/weechat` to attach
