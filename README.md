# aws2ipset
Simple OpenWRT script that syncs the official Amazon AWS IP range JSON feed into an Linux ipset for use with iptables firewall rules

OpenWRT Forum post: https://forum.openwrt.org/viewtopic.php?pid=308408

**Dependencies**

- curl, ca-certificates, ipset, kmod-ipt-ipset packages

**Installation**

	opkg update ; opkg install curl ca-certificates ipset kmod-ipt-ipset
	wget -O /usr/sbin/aws2ipset https://raw.githubusercontent.com/robzr/aws2ipset/master/aws2ipset
	chmod 755 /usr/sbin/aws2ipset
	echo -e '# aws2ipset updates every other week\n15 1 * * 0 /usr/sbin/aws2ipset' >> /etc/crontabs/root 
	/etc/init.d/cron enable
	/usr/sbin/aws2ipset

Once installed, the "aws" ipset can be used in iptables rules, ex:

	iptables -A input_wan_rule -p tcp --dport 22 -m set --set aws src -j ALLOW

**TODO**

Rewriting in Lua for speed, efficiency and extensibility

Add uci lists & config parsing logic to allow user to select which service(s)/region(s) are used, ex:

	option FilterOut '.*/us-.*east-.*'  # filter out all us data centers in the east, northeast, southeast, etc.
	option FilterIn 'AMAZON/us-'        # defaults to everything, or '/'

(Assemble variable into $service/$region then check against sed regex processing.)

Speeding up, before :

	root@gw:~# time /usr/sbin/aws2ipset
	real    0m 59.24s
	user    0m 13.54s
	sys     0m 42.61s
	root@gw:~# ipset list aws  | wc -l
	507


Example JSON:

    {
      "ip_prefix": "52.94.248.208/28",
      "region": "ca-central-1",
      "service": "AMAZON"
    },
    {
      "ipv6_prefix": "2a01:578:13::/64",
      "region": "eu-central-1",
      "service": "EC2"
    },

