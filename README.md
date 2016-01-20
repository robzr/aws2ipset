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

**TBD**

Add uci lists & config parsing logic to allow user to select which service(s)/region(s) are used, ex:

	option FilterOut '.*/us-.*east-.*'  # filter out all us data centers in the east, northeast, southeast, etc.
	option FilterIn 'AMAZON/us-'        # defaults to everything, or '/'

(Assemble variable into $service/$region then check against sed regex processing.)
