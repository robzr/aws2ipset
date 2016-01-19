# aws2ipset
Simple script that syncs the official Amazon AWS IP range JSON feed into an Linux ipset for use with iptables firewall rules

**Installation**

	opkg update ; opkg install curl ca-certificates ipset kmod-ipt-ipset
	wget -O /usr/sbin/aws2ipset https://raw.githubusercontent.com/robzr/aws2ipset/master/aws2ipset
	chmod 755 /usr/sbin/aws2ipset
	echo -e '# aws2ipset updates every other week\n15 1 * * 0 /usr/sbin/aws2ipset' >> /etc/crontabs/root 
	/etc/init.d/cron enable
	/usr/sbin/aws2ipset

Once installed, the "aws" ipset can be used in iptables rules, ex:

	iptables -A input_wan_rule -p tcp --dport 22 -m set --set aws src -j ALLOW

