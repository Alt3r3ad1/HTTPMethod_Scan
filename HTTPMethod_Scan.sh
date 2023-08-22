#!/bin/bash

if [ $1 = "" ]; then
        echo "HTTPMethod_Scan by:Alt3r3ad1"
        echo "Method for use: ./HTTPMethod_Scan.sh 'target.com'"
else
	HTTPMethods="ACL;BASELINE-CONTROL;BIND;CHECKIN;CHECKOUT;CONNECT;COPY;DELETE;GET;HEAD;LABEL;LINK;LOCK;MERGE;MKACTIVITY;MKCALENDAR;MKCOL;MKREDIRECTREF;MKWORKSPACE;MOVE;OPTIONS;ORDERPATCH;PATCH;POST;PRI;PROPFIND;PROPPATCH;PUT;REBIND;REPORT;SEARCH;TRACE;UNBIND;UNCHECKOUT;UNLINK;UNLOCK;UPDATE;UPDATEREDIRECTREF;VERSION-CONTROL"
	#https://www.iana.org/assignments/http-methods/http-methods.xhtml#methods

	for HTTPMethod in $(echo $HTTPMethods | tr ";" "\n")
	do
		((ForCount++))
		HTTPStatusCode=$(curl -I -s -X $HTTPMethod "$1" 2>/dev/null | head -n 1 | cut -d' ' -f2-)
		if [ $HTTPMethod = "GET" ]; then
			BypassAuthHTTPMethodGET=$HTTPStatusCode
		elif [ $HTTPMethod = "POST" ]; then
			BypassAuthHTTPMethodPOST=$HTTPStatusCode
		fi
		echo "$1 => $HTTPMethod => $HTTPStatusCode"
		if [ $ForCount -eq 39 ] && [ "$BypassAuthHTTPMethodGET" != "$BypassAuthHTTPMethodPOST" ]; then
			echo -e "\033[1;33m [!] HTTP Status Code divergent, check for possible bypass \033[0m"
		fi
	done
fi
