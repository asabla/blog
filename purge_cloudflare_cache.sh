#!/bin/bash

declare GUSER=$1
declare GREPO=$2
declare GTOKEN=$3

readonly DELAY_SECONDS=15
readonly INTERVAL_SECONDS=5
readonly TIMEOUT_SECONDS=90

function poll_build_status() {
    echo "Awaiting for build completion of latest github pages..."
    local waited_seconds=0
    local curlResult=''
    local grepResult=''
    local requestUrl="https://api.github.com/repos/${GUSER}/${GREPO}/pages/builds/latest"

    # For debug
    # echo "Using this url for requests: $requestUrl"

    while [[ "${waited_seconds}" -lt "${TIMEOUT_SECONDS}" ]]; do
      curlResult=$(curl \
        --silent \
        --user "${GUSER}:${GTOKEN}" \
        --header "Accept: application/vnd.github.v3+json" \
        "$requestUrl")

			# For debug
      #echo "curlResult: $curlResult"

      if echo "${curlResult}" | grep -q '"status": "built"'; then
        echo "Success!"
        return 0
      # else
				# For debug
        #echo "Got something else!"
        #echo "${curlResult}"
      fi

      echo " sleeping ${INTERVAL_SECONDS} seconds until next status poll..."
      sleep "${INTERVAL_SECONDS}"
      (( waited_seconds += INTERVAL_SECONDS ))
    done

    echo "Error!" >&2
    return 1
}

function purge_cache() {
    echo "Purging Cloudflare cache..."
    if curl \
        --silent \
        --request POST \
        --header "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
        --header "Content-Type: application/json" \
        --data '{"purge_everything":true}' \
        "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/purge_cache" \
        | grep -q '"success": true'; then
        echo "Success!"
        return 0
    else
        echo "Error!" >&2
        return 1
    fi
}

function main() {
  # For debug
	#echo "some env variables..."
  #echo "github_user: ${GUSER}  github_repo:${GREPO}"

  echo "Sleeping for ${DELAY_SECONDS} seconds..."
  sleep "${DELAY_SECONDS}"
  poll_build_status || exit 1

  echo "Sleeping for ${DELAY_SECONDS} seconds..."
  sleep "${DELAY_SECONDS}"
  purge_cache || exit 1
}

main "$@"
