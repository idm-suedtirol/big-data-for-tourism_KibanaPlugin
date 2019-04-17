#!/bin/bash

TOKEN=$(echo -n "${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD}" | base64)

sed -i -e "s/<token>/${TOKEN}/" /etc/nginx/conf.d/default.conf

nginx -g "daemon off;"
