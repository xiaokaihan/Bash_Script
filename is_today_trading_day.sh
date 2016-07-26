#!/bin/sh
#############################################################################
###
###             start.sh
###             - Cronjob run at 7:xx AM on every Mon-Fri to start server
###
###
#############################################################################
###########################
#       CONFIGURATION
###########################
# DB & local path
# export path：设置环境变量
#脚本一旦出错，马上退出
set -o errexit
ORACLE_HOME=/users/oracle/OraHome10g;export ORACLE_HOME
DBCONN=GOEX_ADMIN/GOEX_ADMIN@192.168.1.191:1421/MFTST;export DBCONN
BASE_PATH=/home/ps/test_eric/key_test/holiday_test/onenineone
SCRIPT_PATH=$BASE_PATH
# Do not edit below
NLS_LANG=.AL32UTF8;export NLS_LANG
REPORT_DATE=`date +%Y%m%d`
#传参到shell
REPORT_MARKET=$1

STATUS=
SCRIPT_OUTPUT=

###########################
#       START
###########################

echo Host: `hostname`
echo Script: $0
echo ============================

# Cleanup previously generated files
echo [`date "+%Y/%m/%d %H:%M:%S"`] Remove previously generated files

# Check if today is holiday (local)
echo [`date "+%Y/%m/%d %H:%M:%S"`] Check if today is holiday
echo [`date "+%Y/%m/%d %H:%M:%S"`] $ORACLE_HOME/bin/sqlplus -l -s xxx @$SCRIPT_PATH/is_local_holiday.sql $REPORT_DATE $REPORT_MARKET
#传参到oracle, -l:only login once, -s:silent Mode
SCRIPT_OUTPUT=`$ORACLE_HOME/bin/sqlplus -l -s $DBCONN @$SCRIPT_PATH/is_local_holiday.sql $REPORT_DATE $REPORT_MARKET`
echo [`date "+%Y/%m/%d %H:%M:%S"`] Result: $SCRIPT_OUTPUT

if echo "$SCRIPT_OUTPUT" | grep HOLIDAY=Y > /dev/null ; then
        echo [`date '+%Y/%m/%d %H:%M:%S'`] Today is local holiday. Skip process.
        STATUS=SKIP
elif echo "$SCRIPT_OUTPUT" | grep HOLIDAY=N > /dev/null ; then
        echo [`date '+%Y/%m/%d %H:%M:%S'`] Today is not local holiday. Proceed.
        STATUS=PROCEED
else
        echo [`date '+%Y/%m/%d %H:%M:%S'`] [ERROR] Holiday script error.
        STATUS=ERROR
fi

if [ "$STATUS" = "PROCEED" ] ; then
        # Start up
        echo [`date '+%Y/%m/%d %H:%M:%S'`] Starting OCG / OMD Server....
        #### Start OCG/OMD Server
        exit 0
else
        exit 1
fi
