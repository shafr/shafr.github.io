---
layout: post
title:  "BlackDuck J-unit style report"
tags: ["security", "jenkins", "BlackDuck"]
categories: work
---

Back in a day I stumbled upon this article: https://uko.codes/npm-audit-jenkins-warnings-next-generation-custom-groovy-parser

I wanted to adapt this approach to display result from blackduck scan as well.


## What are the benefits:
* See vulnerabilities trend in Jenkins
* Set Quality gate that would fail job when there are some vulnerabilities
* Send slack notifications
* Navigate and see each individual CVE
* Have one Jenkins folder with all Blackduck projects status

![](/assets/2022-11-04/bd_overview.gif)
![](/assets/2022-11-04/bd_detailed.gif)

# How to is jenkins / bash script to make it work:

* [audit-transform.js](/assets/2022-11-04/audit-transform.js)
* [blackduck_get_report.sh](/assets/2022-11-04/blackduck_get_report.sh)
* [jenkins_blackduck.groovy](/assets/2022-11-04/jenkins_blackduck.groovy)

