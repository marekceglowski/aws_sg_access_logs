# AWS Security Group Access Logs

Gets flow logs from a specific security group and outputs to csv format.

## Syntax:

```
sh get_access_logs.sh <sg-id> [start-date] [end-date] [filter-pattern] [max-items]
```

## Notes: 

* [!] filter-log-events in AWS CLI seems to have has a bug with end-date, if you include it, it always returns no results. A workaround for this app is to use an end-date further than the current date until this issue is fixed.
* If you want to use max-items without a filter, just enter "" as your filter.

### Examples:

```
sh get_access_logs.sh sg-XXXXXXXX 2018-01-01
sh get_access_logs.sh sg-XXXXXXXX 2018-10-01 2020-01-01
sh get_access_logs.sh sg-XXXXXXXX 2018-10-01 2020-01-01 "10.0.0.1"
sh get_access_logs.sh sg-XXXXXXXX 2018-10-01 2020-01-01 "10.0.0.1" 100
sh get_access_logs.sh sg-XXXXXXXX 2018-10-01 2020-01-01 "" 100
```
