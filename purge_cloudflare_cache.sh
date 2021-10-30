#!/usr/bin/env bash

readonly DELAY_SECONDS=15
readonly INTERVAL_SECONDS=5
readonly TIMEOUT_SECONDS=90

readonly GITHUB_USER=asabla
readonly GITHUB_REPO=asabla.github.io/blog


##################################################
# Poll status of latest GitHub Pages build every INTERVAL_SECONDS seconds for up
# to TIMEOUT_SECONDS seconds.
# Globals:
#   GITHUB_REPO
#   GITHUB_TOKEN
#   GITHUB_USER
#   INTERVAL_SECONDS
#   TIMEOUT_SECONDS
# Arguments:
#   None
# Outputs:
#   Success message to stdout or error message to stderr.
# Returns:
#   0 on success, 1 otherwise.
##################################################
function poll_build_status() {
    echo "Awaiting for build completion of latest github pages..."
    local waited_seconds=0
    local curlResult=''
    local grepResult=''

    while [[ "${waited_seconds}" -lt "${TIMEOUT_SECONDS}" ]]; do
      curlResult=$(curl \
        --silent --user "${GITHUB_USER}:${GITHUB_TOKEN}" \
        --header "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/pages/builds/latest")

      grepResult=$(echo curlResult | grep '"status": "built"')
      echo "grep result: ${grepResult}"

      if echo "${curlResult}" | grep -q '"status": "built"'; then
        echo "Success!"
        return 0
      fi
      echo " sleeping ${INTERVAL_SECONDS} seconds until next status poll..."
      sleep "${INTERVAL_SECONDS}"
      (( waited_seconds += INTERVAL_SECONDS ))
    done
    echo "Error!" >&2
    return 1
}


##################################################
# Purge entire Cloudflare cache.
# Globals:
#   CLOUDFLARE_API_TOKEN
#   CLOUDFLARE_ZONE_ID
# Arguments:
#   None
# Outputs:
#   Success message to stdout or error message to stderr.
# Returns:
#   0 on success, 1 otherwise.
##################################################
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


##################################################
# Main function of script.
# Globals:
#   DELAY_SECONDS
# Arguments:
#   None
##################################################
function main() {
    echo "Sleeping for ${DELAY_SECONDS} seconds..."
    sleep "${DELAY_SECONDS}"
    poll_build_status || exit 1

    echo "Sleeping for ${DELAY_SECONDS} seconds..."
    sleep "${DELAY_SECONDS}"
    purge_cache || exit 1
}

# Entrypoint
main "$@"
