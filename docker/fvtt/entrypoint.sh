#!/bin/sh

# prep non-root runtime data dir
# - this needs to be done at runtime for add volume mapped dirs as they are root and can't be changed (at least on wsl)
chown fvtt:fvtt /var/lib/fvtt /var/lib/fvtt/Data

cd /opt/fvtt
su fvtt -c "node resources/app/main.js --dataPath=/var/lib/fvtt"
