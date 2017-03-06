#!/usr/bin/lua
#
# aws2ipset @robzr - https://github.com/robzr/aws2ipset
#
# Syncs Amazon AWS published IP ranges into a hash:net ipset
#
# Installation: Run out of cron and/or firewall.user
# 
# Dependencies: curl, ca-certificates (for use with OpenWRT/Busybox)
#
awsIPRangeURL='https://ip-ranges.amazonaws.com/ip-ranges.json'
setName='aws'
swingSetName="$setName"-swing
tmpFile=`mktemp`

# retrieve JSON file from Amazon
curl -so "$tmpFile" "$awsIPRangeURL" || { echo "Error running curl" ; exit -1 ; }

# create sets if necessary
for set in $setName $swingSetName ; do
  ipset list -q -n $set >/dev/null || ipset create -q $set hash:net maxelem 1024
done

# process file
while read line ; do
  key=`echo $line | cut -f2 -d\"`
  case $key in
    ip_prefix|region|service)
      eval $key="`echo $line | cut -f4 -d\\"`"
      ;;
    "},")
      echo add "$swingSetName" "$ip_prefix"
      # removed: comment "$service $region"
      ;;
  esac
done < "$tmpFile" | ipset restore

ipset add -q "$swingSetName" "$ip_prefix"

rm -f "$tmpFile"

ipset swap $swingSetName $setName

ipset destroy $swingSetName
