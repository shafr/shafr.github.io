#!/bin/bash -e

export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

colorize() { CODE=$1; shift; echo -e "\033[0;${CODE}m$*\033[0m"; }
red() { echo -e "$(colorize 31 "$@")"; }
green() { echo -e "$(colorize 32 "$@")"; }

function checkIfFileExists(){
    local FILE_TO_CHECK="$1"

    if test -f "${FILE_TO_CHECK}"; then
        green "${FILE_TO_CHECK} exists"
    else
        red "${FILE_TO_CHECK} does not exist"
        exit 1
    fi
}

function isPresent(){
    if [[ -z $1 ]]; then echo "Value is empty!!" && exit 1; fi
}

export BLACKDUCK_URL=${BLACKDUCK_URL}

isPresent ${BLACKDUCK_API_TOKEN}
isPresent ${RALLY_PROJECT_NAME}

function getToken(){
    curl -s -X POST ${BLACKDUCK_URL}/api/tokens/authenticate \
    -H "Accept: application/vnd.blackducksoftware.user-4+json" \
    -H "Authorization: token ${BLACKDUCK_API_TOKEN}" > token.json
    checkIfFileExists 'token.json'
    BEARER=$(cat token.json | jq -r '.bearerToken')
    isPresent ${BEARER}
}

function findProjectID(){
    isPresent ${DETECT_PROJECT_NAME}

    echo "Project scanned is ${DETECT_PROJECT_NAME} / ${RALLY_PROJECT_NAME}" >> scan-info.txt

    # Fetch those
    local PROJECTS_FILE="project.json"
    curl -s -H "Authorization: Bearer ${BEARER}" -X GET "${BLACKDUCK_URL}/api/projects?limit=500" | jq > ${PROJECTS_FILE}
    checkIfFileExists ${PROJECTS_FILE}
    export RALLY_PROJECT_URL=$(cat ${PROJECTS_FILE} | jq -r ".items[] | select(.name==\"${RALLY_PROJECT_NAME}\")._meta.href")
    echo "RALLY_PROJECT_URL: ${RALLY_PROJECT_URL}"
    isPresent ${RALLY_PROJECT_URL}

    local numberOfProjects=$(cat ${PROJECTS_FILE} | jq -r '.items[].name' | wc -l)
    echo "Number of projects ${numberOfProjects}" >> scan-info.txt
}

function findVersionID(){
    local VERSIONS_FILE="version.json"
    curl -s -H "Authorization: Bearer ${BEARER}" -X GET "${RALLY_PROJECT_URL}/versions?limit=500" | jq > ${VERSIONS_FILE}
    checkIfFileExists "${VERSIONS_FILE}"
    export RALLY_PROJECT_VERSION_URL=$(cat ${VERSIONS_FILE} | jq -r ".items[] | select(.versionName==\"${RALLY_PROJECT_NAME}\")._meta.href")
    isPresent ${RALLY_PROJECT_VERSION_URL}

    local numberOfVersions=$(cat ${VERSIONS_FILE} | jq -r '.items[].versionName' | wc -l)
    local lastBomUpdate=$(cat ${VERSIONS_FILE} | jq -r ".items[] | select(.versionName==\"${RALLY_PROJECT_NAME}\").lastBomUpdateDate")
    export LAST_SCAN_DATE=$(cat ${VERSIONS_FILE} | jq -r ".items[] | select(.versionName==\"${RALLY_PROJECT_NAME}\").lastScanDate")

    echo "Number of versions ${numberOfVersions}" >> scan-info.txt
    echo "Last BOM update: ${lastBomUpdate}" >> scan-info.txt
    echo "Last Scan Date: ${LAST_SCAN_DATE}" >> scan-info.txt
    echo "Project HREF: ${RALLY_PROJECT_VERSION_URL}" >> scan-info.txt
    echo "HREF=${RALLY_PROJECT_VERSION_URL}" >> env.prop
    echo "Scan date: $(date)" >> scan-info.txt

}

function getVulnsJson(){
    curl -s -H "Authorization: Bearer ${BEARER}" -X GET "${RALLY_PROJECT_VERSION_URL}/vulnerable-bom-components?offset=0&limit=500" | jq > vulnerable-bom-components.json
    checkIfFileExists 'vulnerable-bom-components.json'
    export NUMBER_OF_ELEMENTS=$(cat vulnerable-bom-components.json | jq '.items' | jq length)
    echo "Number of elements: ${NUMBER_OF_ELEMENTS}" >> scan-info.txt
    green "File is saved"
}

function findLastScanDate(){
    isPresent ${LAST_SCAN_DATE}

    local fmtScanDate=$(date -d  ${LAST_SCAN_DATE} '+%s')
    local nowDate=$(date -d  now '+%s')
    export DIFF_DATE=$(( ${nowDate} - ${fmtScanDate}))

    echo "Last Scan was executed ${DIFF_DATE} seconds ago" >> scan-info.txt
    echo ${DIFF_DATE} >> diff_date.txt
}

getToken
findProjectID
findVersionID
getVulnsJson
findLastScanDate