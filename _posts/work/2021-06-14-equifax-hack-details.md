---
layout: post
title:  "Equifax hack cause (GAO report)"
tags: [security]
categories: work
---

I've stumbled upon [GAO report](https://www.gao.gov/products/gao-18-559) on 2017th Equifax hack. I though that it was elite hackers using super technologies, but it actually was a carelessness of admins / security team:

* Network traffic analyzer that had 10 month expired certificate and was not analyzing https traffic
* Security configuration that allowed to perform 9000 queries from one account
* Security tools/scans that showed that vulnerability was fixed
* Network segmentation that allowed to extract data from 90 DB's
* Storing username and data in plain text

### More details on that:

* While Equifax had installed a device to inspect network traffic for evidence of malicious activity, a misconfiguration allowed encrypted traffic to pass through the network without being inspected. According to Equifax officials, the misconfiguration was due to an expired digital certificate. 26 The certificate had expired about 10 months before the breach occurred, meaning that encrypted traffic was not being inspected throughout that period.

* According to Equifax officials, the Apache Struts vulnerability was not properly identified as being present on the online dispute portal when patches for the vulnerability were being installed throughout the company. After receiving a notice of the vulnerability from the United States Computer Emergency Readiness Team in March 2017, Equifax officials stated that they circulated the notice among their systems administrators. However, the recipient list for the notice was out-of-date and, as a result, the notice was not received by the individuals who would have been responsible for installing the necessary patch. In addition, Equifax officials stated that although the company scanned the network a week after the Apache Struts vulnerability was identified, the scan did not detect the vulnerability on the online dispute portal.

* Because individual databases were not isolated or “segmented” from each other, the attackers were able to access additional databases beyond the ones related to the online dispute portal, according to Equifax officials. The lack of segmentation allowed the attackers to gain access to additional databases containing PII, and, in addition to an expired certificate, allowed the attackers to successfully remove large amounts of PII without triggering an alarm.

* Data governance includes setting limits on access to sensitive information, including credentials such as usernames and passwords. According to Equifax officials, the attackers gained access to a database that contained unencrypted credentials for accessing additional databases, such as usernames and passwords. This enabled the intruders to run queries on those additional databases.