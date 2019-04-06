#!/usr/bin/env bash

set -e
# deploy backend
cd code
yarn

serverless remove 2>&1 >/dev/null || true  # just in case any stack exists

serverless deploy -v
BASE_URL=`sls info -v | grep ServiceEndpoint: | xargs |cut -d " " -f2`
cd - > /dev/null

sed -i -E "s?lambdaApiEndpoint:.+?lambdaApiEndpoint: '${BASE_URL}'?g" ./frontend/src/environments/environment.ts
sed -i -E "s?lambdaApiEndpoint:.+?lambdaApiEndpoint: '${BASE_URL}'?g" ./frontend/src/environments/environment.prod.ts

# build frontend
cd frontend
if [[ $1 == "--build" ]]; then
	yarn
    node_modules/@angular/cli/bin/ng build --prod
fi
cd - > /dev/null

# deploy frontend
cd code
serverless client deploy --no-confirm
CLIENT_BUCKET=$(jq ".service.custom.client.bucketName" ./.serverless/serverless-state.json | xargs)
cd - > /dev/null

#open browser
if [[ $1 != "--no-browser" ]]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open "http://${CLIENT_BUCKET}.s3-website.eu-central-1.amazonaws.com/" 2>&1 > /dev/null
    else
        xdg-open "http://${CLIENT_BUCKET}.s3-website.eu-central-1.amazonaws.com/" 2>&1 > /dev/null
    fi
    sleep 2
    echo -e "\n\n\n\n" # to clear open command outputs which might appear
fi
