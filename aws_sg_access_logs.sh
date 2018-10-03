declare s
if [ -z "$1" ]; then echo "Syntax: sh get_access_logs.sh <sg-id> [start-date] [end-date] [filter-pattern] [max-items]"; exit 1; fi
if [ -n "$2" ]; then start="--start-time "`date "+%s" -d $2`; fi
if [ -n "$3" ] && [ `date "+%s" -d $3` -lt `date "+%s"` ]; then end="--end-time "`date "+%s" -d $3`; fi
if [ -n "$4" ]; then filterPattern="--filter-pattern "$4; fi
if [ -n "$5" ]; then maxItems="--max-items "$5; fi

echo "Collecting log data..."
networkId=`aws ec2 describe-network-interfaces --filters Name=group-id,Values=$1 | grep NetworkInterfaceId | cut -d '"' -f 4`
vpcId=`aws ec2 describe-network-interfaces --filters Name=group-id,Values=$1 | grep VpcId | cut -d '"' -f 4`
logGroupName=`aws ec2 describe-flow-logs --filter "Name=resource-id,Values=$vpcId" | grep LogGroupName | cut -d '"' -f 4`
trafficType=`aws ec2 describe-flow-logs --filter "Name=resource-id,Values=$vpcId" | grep TrafficType | cut -d '"' -f 4 | tr '[:upper:]' '[:lower:]'`
aws logs filter-log-events --log-group-name $logGroupName --log-stream-names $networkId-$trafficType $start $end $filterPattern $maxItems --output text > $1-logs.csv
echo "Converting to csv..."
sed -i 's/\t/,/g' $1-logs.csv
sed -i 's/ /,/g' $1-logs.csv
sed -i '1 i\,,,,version,accountId,interfaceId,srcAddress,destAddress,srcPort,destPort,protocol,packets,bytes,startTime,endTime,action,logStatus' $1-logs.csv
echo "Done."

