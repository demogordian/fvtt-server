# FVTT Docker Compose Setup

## Features

- nginx (ssl termination) -> oauth2-proxy (secure auth) -> fvtt (profit!)
- mrprimate ddb integration

## Operations

### Upgrade FVTT Version

- upload new version to server directory
- unzip and symlink from `current`

### Setup

#### Create new ec2 instance with latest Ubuntu LTS
- spin up ec2 instance
  - latest ubuntu lts hvm
  - t3.micro
  - 25gb root volume
  - security group inbound ports 22, 80, 443

#### Execute in new instance (manually #tbd)
- adjust versions as necessary

```bash
sudo apt-get update && apt-get dist-upgrade
sudo shutdown -r now
sudo apt-get install docker.io unzip
# see https://docs.docker.com/compose/install/
mkdir -p /usr/local/lib/docker/cli-plugins 
sudo curl -SL \
  https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
# non-root user to run fvtt in container
adduser --group fvtt
usermod --append -G docker fvtt
# write ssh keys to /home/fvtt/.ssh/authorized_keys
cd ~ 
git clone https://git-codecommit.us-west-2.amazonaws.com/v1/repos/fvtt
cd ~/fvtt
cp config/docker/daemon.json /etc/docker \
  && chown root.root /etc/docker/daemon.json \
  && chmod 644 /etc/docker/daemon.json
cp config/rsyslogd/docker.conf /etc/rsyslog.d/10-docker.conf \
  && chown root.root /etc/rsyslog.d/10-docker.conf \
  && chmod 644 /etc/rsyslog.d/10-docker.conf
systemctl restart docker.service rsyslog.service
sudo cp config/logrotate/docker /etc/logrotate.d
ln -s /var/log/docker ~/fvtt/logs/docker   # remote only, container logs here
cd ~/fvtt/server
# Download FVTT linux install zipfile
unzip FoundryVTT-9.255.zip
ln -s FoundryVTT-9.255 current
cd ~/fvtt
cp ./.env.example ./.env
# edit .env, customize for your installation
```

### Running

Logged in as fvtt user:

```bash
% cd ~/fvtt
% source vttenv
% vtt help
% vtt vup
```

To be safe, ensure that FVTT is in setup mode before shutting down, and that it's shut down before upgrading.

### Add users to oauth

- read docs on user setup here:
  https://oauth2-proxy.github.io/oauth2-proxy/docs/configuration/oauth_provider/#google-auth-provider
- add test user email to https://console.cloud.google.com/apis/credentials/consent?project=foundryvtt-343421
- add user to config/oauth/authenticated_mails file

### SSL Certificate (#todo: update for vtt cli)

#### Create cert

```bash
% docker compose up -d nginx
% docker compose run --rm certbot certonly
```

#### Renew cert (#tbd automate renewals)

- renew letsencrypt certificate with `vtt renew-cert`

### Self-signed SSL (#todo move to vtt script)

- Copy `~/fvtt/config/nginx/ssl/ssl.config.template`
  to `~/fvtt/config/nginx/ssl/ssl.config`
- Run script `~/fvtt/bin/create-selfcert`
- generate dhparams
  - `openssl dhparam -out /etc/nginx/ssl/dhparam-2048.pem 2048`

### Recommendations

- consider creating a local git repo at ~/fvtt/config/fvtt
  - for configuration management of fvtt server
- consider creating local git repo at ~/fvtt/config/fvtt/Data/worlds/* (for each world)
  - for configuration management of specific worlds
