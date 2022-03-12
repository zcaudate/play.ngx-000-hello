dev:
	ls nginx.conf | entr -r make restart

start:
	nginx -p runtime -c ../nginx.conf

stop:
	nginx -s stop

refresh:
	nginx -s reload

restart:
	@nginx -s stop
	nginx -p runtime -c ../nginx.conf
	@alerter -message 'NGINX RESTARTED' -title 'STATSNET' -timeout 2 > /dev/null