#!/bin/bash
set -e

PROJECT_DIRECTORY=/app/app_template
SWIFT_APP=Dealer

app_present() {
    [ -d $PROJECT_DIRECTORY ]
}

log () {
    echo -e "\033[0;33m$(date "+%H:%M:%S")\033[0;37m ==> $1."
}

if [ "$1" == "swift" -a "$2" == "app" -a "$3" == "start" ]; then
    if ! app_present; then
	log "Creating example Swift application"
	cp -r /app_template/ .
	cd app_template/
	swift build
	log "Swift app created"
    else 
	log "App already created"
    fi
fi

exec $PROJECT_DIRECTORY/.build/debug/$SWIFT_APP
