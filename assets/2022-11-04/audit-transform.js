let data = "";
process.stdin.setEncoding("utf8");
process.stdin.on("readable", () => {
    let chunk = process.stdin.read();
    if (chunk !== null) {
        data += chunk;
    }
});

function convertWarning(string) {
    switch (string) {
        case "LOW":
            return "LOW";
        case "MEDIUM":
            return "NORMAL";
        case "HIGH":
            return "HIGH";
        case "CRITICAL":
            return "ERROR";

        default:
            return "NORMAL";
    }
}

function getDataFromComponentName(componentName) {
    return [
        `❔ ${componentName.replace(/\s/g, '_')}`,
        `❔ ${componentName.replace(/\s/g, '_')}`,
        ''
    ]
}

function getProperComponentName(originId, componentName) {
    var [fileName, packageName, version] = Array(3).fill('')

    if (originId === undefined || originId === '') {
        return getDataFromComponentName(componentName)
    }

    // Maven case
    if (originId.split(":").length == 3) {
        return originId.split(":");
    }

    // OS deps
    if (originId.split("/").length == 3) {
        //different order here
        var [fileName, version, packageName] = originId.split("/");
        return [fileName, packageName, version]
    }

    console.error(`cannot parse originID ${originId}, componentName: ${componentName}`)
    return getDataFromComponentName(componentName)

}

// Use this file for fields reference
// https://github.com/jenkinsci/analysis-model/blob/master/src/main/java/edu/hm/hafner/analysis/IssueBuilder.java
process.stdin.on("end", () => {
    const audit = JSON.parse(data);
    const actions = audit.items;

    const issues = actions.flatMap((cve) => {
        var [fileName, packageName, version] = getProperComponentName(cve.componentVersionOriginId, cve.componentName)

        return {
            fileName: fileName,
            packageName: packageName,
            directory: cve.vulnerabilityWithRemediation.cweId,
            category: cve.vulnerabilityWithRemediation.source,
            // type: cve.vulnerabilityWithRemediation.remediationStatus,
            // type: cve.vulnerabilityWithRemediation.source,
            type: cve.componentVersionOriginName,
            severity: convertWarning(cve.vulnerabilityWithRemediation.severity),
            message: cve.vulnerabilityWithRemediation.vulnerabilityName,
            description: cve.vulnerabilityWithRemediation.description,
            // moduleName: cve.vulnerabilityWithRemediation.vulnerabilityPublishedDate,
            origin: version,
            originName: cve.vulnerabilityWithRemediation.source,
            reference: cve.vulnerabilityWithRemediation.relatedVulnerability,
            // No place for origin, published date, etc
            fingerprint: cve.vulnerabilityWithRemediation.vulnerabilityName
        };
    });

    console.log(JSON.stringify({ issues: issues }));
});