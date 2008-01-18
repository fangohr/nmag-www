got to nmag.soton.ac.uk:/var/local/www/apache-logs
Then run

 zcat nmag-http*.gz | perl -MSocket -ne 'm/^([0-9.]+)/ and do {$n=($h{$1} or gethostbyaddr(inet_aton($1),AF_INET));$h{$1}=$n;$r{$n}++}; END{printf "%-40s -> %4d\n",$_,$r{$_} for (sort keys %r)}'
