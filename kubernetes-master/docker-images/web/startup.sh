#!/bin/bash

cp /etc/config/*.conf /etc/httpd/conf.d
/usr/sbin/httpd -DFOREGROUND
