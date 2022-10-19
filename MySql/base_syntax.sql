# database start ----------------------------------------------
CREATE DATABASE test;
DROP DATABASE test;

# with charset ， collate
# collate  utf8_bin 区分大小写 ， #utf8_general_ci 不区分大小写
CREATE DATABASE test1 IF NOT EXISTS DEFAULT CHARSET SET utf8 COLLATE utf8_bin;

# list all databases
SHOW DATABASES

# 备份数据库
mysqldump -u "username" -p -b "db1" "db2" "db..."

UPDATE mysql.`user` SET authentication_string=password(`7q8w9e`) where user=root;


# 修改密码
ALTER user 'root'@'%' IDENTIFIED BY '7q8w9e'