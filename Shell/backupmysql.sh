#!/bin/sh
#Database info
DB_USER="" #数据库用户
DB_PASS="" #密码
DB_HOST="" #数据库IP或主机名
DB_NAME1="" #要备份的数据库
DB_NAME2="" #要备份的数据库


BackupDir=/home/Data/mysqlbackup
LogFile=/home/Data/mysqlbackup/mysql_bak.log
DATE=`date +%Y%m%d%H%M%S`
echo " " >> $LogFile
echo " " >> $LogFile
echo "-------------------------------------------" >> $LogFile 
echo $(date +"%y-%m-%d %H:%M:%S") >> $LogFile 
echo "--------------------------" >> $LogFile 
cd $BackupDir
DumpFile1=${DB_NAME1}_$DATE.sql
GZDumpFile1=${DB_NAME1}_$DATE.sql.tar.gz
DumpFile2=${DB_NAME2}_$DATE.sql
GZDumpFile2=${DB_NAME2}_$DATE.sql.tar.gz
/usr/local/mysql/bin/mysqldump -u$DB_USER -p$DB_PASS  -h$DB_HOST $DB_NAME1 > $DumpFile1
echo "Dump $DB_NAME1 Done" >> $LogFile
tar czvf $GZDumpFile1 $DumpFile1 >> $LogFile 2>&1 
echo "[$GZDumpFile1]Backup Success!" >> $LogFile 
rm -f $DumpFile1

/usr/local/mysql/bin/mysqldump -u$DB_USER -p$DB_PASS  -h$DB_HOST $DB_NAME2 > $DumpFile2
echo "Dump $DB_NAME2 Done" >> $LogFile
tar czvf $GZDumpFile2 $DumpFile2 >> $LogFile 2>&1 
echo "[$GZDumpFile2]Backup Success!" >> $LogFile 
rm -f $DumpFile2

echo "Start copy to Ftp server ...." >> $LogFile 
ftp -i -n <<end_ftp 
open 127.0.0.1
user username password
binary
lcd  $BackupDir
prompt off 
mput $GZDumpFile1 $GZDumpFile2
close 
bye 
end_ftp

echo "Copy to  Ftp server done!!!" >> $LogFile 
echo "Backup OK!"
echo "please Check $BackupDir Directory!"
find $BackupDir -ctime +7 -exec rm {} \;
echo "delete file over 7 days"