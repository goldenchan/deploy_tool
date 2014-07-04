#!/bin/sh
rm -rf /var/www/html/svn_export/*
svn update --username chenjin --password {svn_password} /var/www/html/web

svn diff -r $1:HEAD --username chenjin --password {svn_password} --summarize /var/www/html/web | grep '^[ADMR]' | cut -b 8- | xargs -I '{}' cp --parents {} /var/www/html/svn_export/

[ -f /var/www/html/svn_export/var/www/html/web/application/cli/index.php ] && perl -pi -e 's/127\.0\.0\.1/www\.cosmenu\.com/g' /var/www/html/svn_export/var/www/html/web/application/cli/index.php

rsync -e "ssh -i {pem_path}" --exclude '{exclude_file}' --exclude application/public/demo/ --exclude application/files/ --exclude application/tmp/ -rvz --chmod=ugo=rwX /var/www/html/svn_export/var/www/html/web/ {remote_server_user}@{remote_server_ip}:/var/www/html/web/

ssh -i {pem_path} -t {remote_server_user}@{remote_server_ip} "sudo chown -R apache:apache /var/www/html/web/"
