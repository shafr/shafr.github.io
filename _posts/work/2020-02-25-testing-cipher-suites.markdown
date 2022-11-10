---
layout: post
title:  "Testing server for vulnerable or obsolete ciphers."
tags: [jetty, curl, security, testing]
categories: work
---

I had a task of disabling obsolete ciphers in our Jetty instance and testing it.

Here are some instructions that might help.

### Disabling

Disabling part was easy - it's just matter of editing `web.xml` file with `excludeCipherSuites` section.



### Testing

Testing is the fun part. I found that `curl` has flag `--ciphers` that allows to specify exact cipher to establish connection with.

It took me a while to read obvious thing about curl - that it uses openssl for cipher enumeration (since I was not able to find cipher names in curl source).

So in order to match specification ciphers with CURL one [this page][openssl_ciphers] would be very helpfull.

Also it is not so obvious what specific ciphers correspond to `tls 1.1`. Finally I found [specification][tls1.1] which listed which ciphers were introduced.

Also also to match ciphers with ID's [mozzila page][mozilla] is helpfull.

### Test code

```bash
#!/bin/bash -l
#set -x

colorize() { CODE=$1; shift; echo -e '\033[0;'$CODE'm'$@'\033[0m'; }
red() { echo -e $(colorize 31 $@); }
green() { echo -e $(colorize 32 $@); }
yellow() { echo -e $(colorize 33 $@); }

export HTTPS_HOST_AND_PORT="https://google.com/";

testSuite(){
	echo "TESTING ${1}"

	shift;

	for cipher in $@; do
			curl --silent --insecure --include --output /dev/null --location "${HTTPS_HOST_AND_PORT}" --ciphers $cipher
			local EXIT_CODE=$?

			case $EXIT_CODE in

			35) echo "${cipher} - OK";;
			*) red "Test Suite to fail with exit code - ${EXIT_CODE} - on cipher $cipher" ;;
			# https://ec.haxx.se/usingcurl/usingcurl-returns

			esac
	done

	echo ""
}

testSuite "vulnerable ciphers" DES-CBC3-SHA DHE-RSA-DES-CBC3-SHA AES128-SHA DHE-RSA-AES128-SHA ECDHE-RSA-AES128-SHA ECDHE-RSA-DES-CBC3-SHA
testSuite "tls1.1"  NULL-MD5 NULL-SHA RC4-MD5 RC4-SHA IDEA-CBC-SHA DES-CBC3-SHA DHE-DSS-DES-CBC3-SHA
```





[openssl_ciphers]: https://www.openssl.org/docs/man1.1.0/man1/ciphers.html]
[tls1.1]: https://tools.ietf.org/html/rfc4346
[mozilla]: https://wiki.mozilla.org/Security/Cipher_Suites