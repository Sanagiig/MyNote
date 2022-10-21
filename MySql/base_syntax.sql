# database start ----------------------------------------------
CREATE DATABASE test;
DROP DATABASE test;

# with charset ， collate
# collate  utf8_bin 区分大小写 ， #utf8_general_ci 不区分大小写
CREATE DATABASE test1 IF NOT EXISTS DEFAULT CHARSET SET utf8 COLLATE utf8_bin;

# list all databases
SHOW DATABASES

# 备份数据库
mysqldump -u "username" -p -B "db1" "db2" "db..." > ./bak.sql

# 恢复数据库
mysql -u -p
    source /tmp/bak.sql

UPDATE mysql.`user` SET authentication_string=password(`7q8w9e`) where user=root;


# 修改密码
ALTER user 'root'@'%' IDENTIFIED BY '7q8w9e'



# table start ----------------------------------------------
# 自增长 auto
# PRIMARY KEY ，主键唯一且不能重复（同时也是主键索引）
# UNIQUE 唯一列, 默认可以为null（可以多个 NULL）
# FOREIGN KEY id REFERENCES tb 外键 
-- 1.添加数据时，A表的外键 不存在于B表（主键或 UNIQUE），则无法添加。
-- 2.删除数据时，B 主键（或 UNIQUE 约束）如果被 A 作为外键引用无法直接删除B，要先删除A，再删除B
-- 3. 表的类型必须时 INNODB 才能使用外键
-- 4. 外键与对应的主键类型必须一致，长度可以不同
-- 5. 外键必须是存在对应主键，或者为 NULL
# NOT NULL 非空约束
# auto_increment = 10 指定自增长，如果当前数据 大于指定数，则按最大的数来增加
# CREATE INDEX index_name ON table(column) 创建索引
-- 1.索引本身会占用空间
-- 复合主键
CREATE TABLE test(
	id int PRIMARY KEY auto_increment = startNum,
	name VARCHAR(10),
 class INT UNIQUE,
	PRIMARY KEY (id,name),
 FOREIGN KEY (class_id) REFERENCES class_tb(id)
) CHARACTER SET utf8 COLLATE utf8_bin ENGINE INNODB

# CHECK 检查数据是否合法
CREATE TABLE t(
	sex VARCHAR(6) CHECK (sex IN('man','woman')),
	sal DOUBLE CHECK (sal >1000 and sal < 2000)
)

CREATE TABLE core(
	id int PRIMARY KEY,
	name VARCHAR(10),
	c1 INT,
	c2 INT,
	c3 INT
) CHARACTER SET utf8 COLLATE utf8_bin ENGINE INNODB

# 复制表结构
CREATE TABLE employee_copy LIKE employee;

# 添加字段
ALTER TABLE test3 ADD field INT
# 更改表字段
ALTER table test3 CHANGE field3 field4 CHAR(4)	
# 修改表字段类型
ALTER table test3 MODIFY  field4 INT
# 删除表字段
ALTER table test3 DROP  field4 

# 查看表结构
SHOW CREATE TABLE core;
# 索引类型 start ----------------------------------------------
-- 1. 主键索引 （PRIMARY KEY）
CREATE TABLE T1(id INT PRIMARY KEY )
-- 2. 唯一索引 (UNIQUE)
CREATE TABLE T1(id INT UNIQUE )
-- 3. 普通索引 (INDEX)
-- 4. 全文索引 （FULLTEXT)[ 适用于MyISAM ]
-- --	开发中考虑使用：全文搜索 Solr 和 ElasticSearch (ES)
-- 查询表是否有索引
SHOW indexes FROM core;
show INDEX FROM core;
SHOW KEYS FROM core;
# 查看信息
DESC core;
# 创建索引
CREATE [ UNIQUE ] INDEX index_name ON tb(`column`);
ALTER TABLE tb ADD [ UNIQUE ] INDEX index_name (`column`);
ALTER TABLE tb ADD PRIMARY KEY `column`
# 删除索引
DROP INDEX index_name ON tb
ALTER TABLE tb DROP [PRIMARY KEY] | INDEX index_name

-- 栗子
CREATE INDEX core_name ON core(name);
CREATE UNIQUE INDEX core_c2 ON core(c2);
ALTER TABLE core ADD INDEX 
ALTER TABLE core ADD UNIQUE INDEX core_c3 (c3)
DROP INDEX core_c1 ON core;
ALTER TABLE core DROP INDEX core_c2;
# 字段类型 start ----------------------------------------------
# 整形 有符号/无符号 （UNSIGNED）
# bit(M)		[1~64 byte]
# tinyint 	[1 byte]
# smallint 	[2 byte]
# mediumint [3 byte]
# int				[4 byte]
# bigint 		[8 byte]

CREATE TABLE bit (
	num bit(9)
)

INSERT INTO bit VALUES(222)

SELECT * FROM bit WHERE num = 222;

DROP TABLE bit;

# 小数类型 （UNSIGNED）
# float 					[4 byte]
# double 					[8 byte]
# decimal(m,d) 		[不确定 byte]
-- 	# 可以支持更加精确的小数位，M是整数 + 小数位数（精度）的总数， D 是小数点（标度）后面的位数
-- 	# 如果 D是0，则表示没有小数点或分数部分。
-- 	# M最大是65，D最大是30，如果D被省略，默认是0.如果M被省略默认是 10.

CREATE TABLE `decimal` (
	num DECIMAL(5,2)
)

INSERT INTO `decimal` VALUES
(1000) 	 # 不可，D = 2
(10.111) # 不可，D = 2

SELECT * FROM bit WHERE num = 222;

DROP TABLE bit;

# 文本类型
# char 			[0-255 byte ]
# varchar 	[0-65535 (0~ 2^16-1) byte] [ascii 最大65535个字符， utf8编码最大 21844（65535 / 3）个字符, 使用 1-3 个字节用于记录大小] [根据不同 charset]
# text 			[0~2^16-1 byte]
# longtext 	[0~2^32-1 byte]

CREATE TABLE `varchar`(
	name VARCHAR(65535)
)
ALTER TABLE `varchar` 
CHANGE  name name VARCHAR(32766);


# 二进制数据类型
# blob 			[0~2^16-1 byte]
# longblog  [0~2^32-1 byte]

# 日期类型
# year			[1 byte]
# date 			[年月日 3 byte]
# time 			[时分秒 3 byte]
# datetime 	[年月日 时分秒 8 byte]
# timestamp [时间戳 4 byte]


# CRUD start ----------------------------------------------
-- INSER
INSERT INTO `test3` VALUES(1,'xixi','2020-12-04 11:11:11')
INSERT INTO `test3` (id,name,birthday) VALUES(1,'xixi','2020-12-04 11:11:11')
INSERT INTO `test3` VALUES(1,NULL,'3276-12-04 11:11:11'),(1,NULL,'3276-12-04 11:11:11')

-- UPDATE
UPDATE `test3` SET birthday = '2020-11-2' WHERE name='xixi'
UPDATE `test3` SET name = CONCAT(name,'qq') ,birthday = '1990-11-11' WHERE name='xixi'
UPDATE `test3` SET name = REPLACE(name,'qq','') 


-- DELETE
# NULL 值必须用 IS 判断
DELETE FROM `test3` WHERE name IS NULL


-- SELECT
SELECT name,birthday from test3 
SELECT * from test3 
# 字段值相同去重
SELECT DISTINCT * from core  
# 统计总数
SELECT name,(c1 + c2 + c3) as `sum core` from core;
# 统计平均
SELECT name,(c1 + c2 + c3)/3 as `avg core` from core;
# 额外增加
SELECT name,(c1 + c2 + c3 + 10)/3 as `avg core + 10` from core;

# 条件查询
SELECT * from core WHERE c1 > 20;
# 累加条件
SELECT * from core WHERE (c1 + c2 + c3) > 80;
# 字段比较查询
SELECT * from core WHERE c1 > c2;
# 字段比较查询2
SELECT * from core WHERE (c1 + c2 + c3) > 200 AND c1 < c2;
# 模糊查询 , % 表示多个字符 ， _ 表示单个字符
SELECT * from core WHERE name like '%1%';

# 区间查询 ([a,b] 大于/小于等于)
SELECT * from core WHERE c3 BETWEEN 11 AND 22;
# 集合查询
SELECT * from core WHERE c3 in (11,23);
# 排序 (asc 升序[小-> 大] ，desc 降序[大 -> 小])
SELECT * from core ORDER BY c3 DESC
SELECT * from core ORDER BY c3 ASC , c1 DESC;
# 统计排序
SELECT name,(c1 + c2 + c3) as sum from core WHERE c3 > 20 ORDER BY sum  DESC ;
# 分页查询 SELECT ... LIMIT start, rows
SELECT * from employee LIMIT 0,3

# 分组查询 GROUP BY + HAVING
-- GROUP BY 就是根据某几个字段的值的不同分成不同的N个组，汇聚成N条数据
-- HAVING 是分组查询后的过滤条件（GROUP BY 不能使用 WHERE）

-- CREATE TABLE dept (
-- 	name VARCHAR(20),
-- 	job VARCHAR(20),
-- 	no INT
-- ) CHARACTER SET utf8 COLLATE utf8_bin ENGINE INNODB;

-- CREATE TABLE employee(
-- 	name VARCHAR(10),
-- 	job VARCHAR(20),
-- 	sal FLOAT,
-- 	comm FLOAT,
-- 	deptno INT
-- ) CHARACTER SET utf8 COLLATE utf8_bin ENGINE INNODB;
-- 
-- CREATE TABLE sal_level(
-- 	grad VARCHAR(10),
-- 	losal DECIMAL(17,2),
-- 	hisal DECIMAL(17,2)
-- ) CHARACTER SET utf8 COLLATE utf8_bin ENGINE INNODB;

-- INSERT INTO dept VALUES 
-- ('d1',1),
-- ('d2',2),
-- ('d3',3);
-- 
-- INSERT INTO employee VALUES
-- ('小明1','做1',1000,0,1),
-- ('小明2','做2',2000,0,1),
-- ('小明3','做3',1000,1000,1),
-- ('小明4','做3',3000,-500,1),
-- ('小明5','做2',2000,100,1),
-- ('小明6','做1',1000,3000,1);
-- 
-- INSERT INTO sal_level VALUES
-- ('1级',1000,1500),
-- ('2级',1501,2000),
-- ('3级',2001,2500),
-- ('4级',2501,3000),
-- ('5级',3001,3500),
-- ('6级',3501,4000);

# 根据人员，查每个部门平均工资
SELECT AVG(sal),MAX(sal),deptno FROM employee GROUP BY deptno;
# 根据人员，查每个部门，不同岗位的平均工资
SELECT AVG(sal),MAX(sal),deptno,job FROM employee GROUP BY deptno,job;
# 查询平均工资低于2000 的 部门号
SELECT AVG(sal) as asal,MAX(sal) as msal,deptno FROM employee GROUP BY deptno HAVING asal > 1500;
# 查询员工总数，以及获得补助的员工数 （comm）
SELECT COUNT(*),count(comm) from employee;
SELECT COUNT(*),COUNT(IF(comm,TRUE,NULL)) from employee;
# 查询员工总数，以及没有获得补助的员工数 （comm）
SELECT COUNT(*),COUNT(IF(comm,NULL,TRUE)) from employee;
SELECT COUNT(*),COUNT(*) - COUNT(comm) from employee;
# 查询现有员工的不同岗位的岗位数
SELECT job,COUNT( job) FROM employee GROUP BY job;
# 统计员工岗位数
SELECT COUNT(DISTINCT job) FROM employee;
# 求最大差额
SELECT MAX(sal) - MIN(sal) from employee;


# 多表查询
# dept 的每一条记录与 employee 的每一条记录组合
SELECT * from  dept,employee;
SELECT * from  dept,employee WHERE dept.no = employee.deptno;

# 匹配员工工资级别
SELECT employee.`name`,grad, (sal + comm) from employee,sal_level 
	WHERE employee.sal + employee.comm 
	BETWEEN losal and hisal;
	
# 自连接表（匹配同一张表的某个字段[ 上下级关系 ]）
# 全匹配
SELECT * FROM employee e1,employee e2;
# 查询 员工上级名称
SELECT e1.name as 名称 , e2.`name` as 领导 from employee e1,employee e2 
	WHERE e1.mgr = e2.id;

# 子查询
# 查询 同小明1 同一部门的员工
SELECT * FROM employee WHERE deptno = (
	SELECT deptno FROM employee WHERE name = '小明1'
);

# 查询和部门1 的工作相同的员工（不含部门1）
SELECT * FROM employee WHERE deptno <> 1 AND job in (
	SELECT DISTINCT job from dept WHERE deptno = 1
)

# 临时表
# 查询所有分类里面最贵的猫
SELECT * FROM (
	SELECT cat_id , MAX(shop_price) as max_price 
	FROM ecs_goods
	GROUP BY cat_id
) temp,ecs_goods
WHERE temp.cat_id = ecs_goods.cat_id 
AND temp.max_price = ecs_goods.shop_price

# 在多行子查询中使用 all 操作符
# 查询工资比部门1所有员工都高的员工信息
SELECT * FROM employee WHERE sal > ALL(
	SELECT sal FROM employee WHERE deptno = 3
)

# 比任意一个高
SELECT * FROM employee WHERE sal > ANY(
	SELECT sal FROM employee WHERE deptno = 3
)

SELECT * FROM employee WHERE sal > ALL(
	SELECT max(sal) FROM employee WHERE deptno = 3
)
# 比任意一个高
SELECT * FROM employee WHERE sal > ALL(
	SELECT min(sal) FROM employee WHERE deptno = 3
)

# 多列子查询
# 查询与小明1 部门&岗位完全相同的人
SELECT employee.`name` FROM (
	SELECT id,deptno,job from employee WHERE id = 5
) tmp ,employee 
WHERE employee.id <> tmp.id AND employee.deptno = tmp.deptno AND employee.job = tmp.job;

SELECT employee.`name` FROM  employee WHERE (deptno,job) = (
	SELECT deptno,job from employee WHERE id = 5
) 
AND employee.id <> 5

# 查询每个部门比本部门平均工资高的人
SELECT name,employee.deptno,sal from (
	SELECT deptno, AVG(sal) as avg_sal from employee GROUP BY deptno
)  avg_t, employee 
WHERE sal >= avg_t.avg_sal AND avg_t.deptno = employee.deptno

# 表自我复制（蠕虫复制）
INSERT INTO employee_copy (name,job,sal,comm,deptno)
SELECT name,job,sal,comm,deptno from employee

INSERT INTO employee_copy (name,job,sal,comm,deptno)
SELECT name,job,sal,comm,deptno from employee_copy


# 表数据去重
CREATE TABLE employee_copy2 LIKE employee
INSERT INTO employee_copy2 (name,job,sal,comm,deptno,id)
SELECT DISTINCT * FROM employee_copy

TRUNCATE TABLE employee_copy
INSERT INTO employee_copy (name,job,sal,comm,deptno,id) 
SELECT DISTINCT name,job,sal,comm,deptno,id FROM employee_copy2
DROP TABLE employee_copy2

# 总结
-- 整体结构
SELECT COUNT(*) as totalNum,deptno,MAX(sal) as msal FROM employee 
	GROUP BY deptno HAVING msal > 1000 
	ORDER BY msal ASC
	LIMIT 0,2;

# 合并查询 start ----------------------------------------------
-- union all 将两个查询结果合并，不会去重
SELECT * FROM employee WHERE sal <=1500
UNION ALL
SELECT * FROM employee WHERE sal >= 1000
-- union 会自动去重
SELECT * FROM employee WHERE sal <=1500
UNION
SELECT * FROM employee WHERE sal >= 1000

-- 外连接
# 查询没有员工的部门
SELECT * FROM dept WHERE no NOT IN(
	SELECT DISTINCT deptno FROM employee
)
-- 左外连接（左侧的表完全显示）
select employee.name,deptno,dept.name FROM employee LEFT JOIN dept ON employee.deptno = dept.`no`
select employee.name,no,dept.name  FROM  dept LEFT JOIN employee ON employee.deptno = dept.`no`
-- 右外连接（右侧的表完全显示）
select employee.name,deptno,dept.name FROM employee right JOIN dept ON employee.deptno = dept.`no`
select employee.name,no,dept.name  FROM  dept right JOIN employee ON employee.deptno = dept.`no`
-- 内连接 （交集）
select employee.name,deptno,dept.name FROM employee inner JOIN dept ON employee.deptno = dept.`no`


# 函数 start ----------------------------------------------
-- COUNT 统计行 （statistic）
SELECT COUNT(*) as count from core ;
-- 满足条件的列的行数, 会排除 NULL 值 == SELECT COUNT(*) as count from core WHERE name IS NOT NULL; 
SELECT COUNT(name) from core;

-- SUM(column) 统计总数
SELECT SUM(c3) from core;
-- 求平均
SELECT SUM(c3) / COUNT(c3) as avg from core;

-- AVG 求平均
SELECT AVG(c3) from core;

-- MAX 最大值 -- MIN 最小值
SELECT MAX(c2) from core;
SELECT MAX(c2),MIN(c2) from core;
SELECT MAX(c1 + c2 + c3),MIN(c1 + c2 + c3) from core;

-- CHARSET(str) 返回字符串字符集
-- CONCAT(str1,str2,...)
-- INSTR(str,substr) 返回 sub 再 str 的位置，没有则返回0
-- UCASE(str)
-- LCASE(str)
-- LEFT(str,len) 从 str 左边提取 len 个字符
-- LENGTH(str) str 长度
-- REPLACE(str,from_str,to_str)
-- STRCMP(expr1,expr2) 比较字符串大小 1 大于，0 等于， -1 小于
-- SUBSTRING(str FROM pos FOR len) 从 str 的 pos 取 len 个字符
-- LTRIM(str) , RTRIM(str)

# 数学函数
-- ABS(X)
-- CEILING(X)
-- FLOOR(X)
-- CONV(N,from_base,to_base) from进制转换成 to 
-- FORMAT(X,D) 保留 D 个小数位
-- HEX(N_or_S) 转16进制（str or num）
-- LEAST(value1,value2,...) 取最小值
-- MOD(N,M)
-- RAND([seed]) 范围 0 <= v <= 1.0

# 日期函数
-- CURRENT_DATE()
-- CURRENT_TIME()
-- CURRENT_TIMESTAMP()
-- DATE(expr)  返回datetime 的日期部分
-- DATE_ADD(date,INTERVAL expr unit) date 中加上 日期或时间
-- DATE_SUB(date,INTERVAL expr unit) date 中减去 日期或时间
-- DATEDIFF(expr1,expr2) 日期差（天）
-- TIMEDIFF(expr1,expr2) 时间差 （时分秒）
-- NOW()
-- YEAR(date) , MONTH(date), DATE(expr), FROM_UNIXTIME(unix_timestamp,'%Y-%m-%d %H:%i:%s') 
-- UNIX_TIMESTAMP() 从 1970 到现在的秒数
SELECT CURRENT_DATE FROM DUAL;
SELECT CURRENT_DATE;
SELECT DATE_ADD('2019-12-11 22:00:00', INTERVAL 1 DAY) FROM DUAL
SELECT DATEDIFF('2019-12-12 23:00:00','2019-12-11 22:00:00') 
SELECT TIMEDIFF('2019-12-12 23:00:00','2019-12-11 22:00:00')  
# 剩余天数
SELECT DATEDIFF( DATE_ADD('1993-06-03', INTERVAL 365 * 80 DAY),NOW())
SELECT FROM_UNIXTIME(UNIX_TIMESTAMP(),'%Y-%m-%d %H:%i:%s')

# 加密 & 系统 函数
-- USER() 查询当前用户 & ip
-- DATABASE() 当前使用的数据库
-- MD5(str)
-- PASSWORD(str) 
SELECT USER()
SELECT DATABASE()
SELECT LENGTH( MD5('123'))


# 条件表达式
-- IF(expr1,val1,val2)
-- IFNULL(expr1,expr2) 第一个为null 则返回 expr2 否则返回 expr1
-- SELECT CASE WHEN exp1 THEN exp2 WHEN exp3 THEN exp4 ELSE exp5 END
SELECT case WHEN NULL THEN 1 ELSE 3 END
SELECT IFNULL(null,'ma')


# 事务 start ----------------------------------------------
# 事务是用于保证数据的一致性，它由一组相关的dml语句组成，该组的dml语句要么全部成功，要么全部失败。
# 事务在提交之前，只有当前会话能够查看到生效
-- 1.如果开启了事务，ROLLBACK 默认回到事务开启的状态
-- 2.事务只有在 INNODB 存储引擎才可以使用， MyISAM 不行
START TRANSACTION  开始事务
SAVEPOINT savepoint_name  		-- 设置保存点名
ROLLBACK TO savepoint_name 		-- 回退事务
ROLLUP 												-- 回退所有事务
COMMIT												-- 提交事务，所有的操作生效，不能回退
# 修改自动提交
SET autocommit = 1 | 0 | ON | OFF;
SHOW VARIABLES LIKE 'autocommit';
# 栗子

CREATE TABLE ttt(
	id INT auto_increment PRIMARY KEY,
	name VARCHAR(30),
	KEY(name)
)
START TRANSACTION
SAVEPOINT a;
INSERT INTO ttt VALUES(NULL,"aaa");

SAVEPOINT b;
INSERT INTO ttt VALUES(NULL,"bbb");

ROLLBACK TO b;
ROLLBACK TO a;
ROLLBACK;
COMMIT;

SELECT * from ttt;

# 隔离级别 start ----------------------------------------------
# 事务隔离界别
-- 1. 多个连接开启各自事务操作数据库中数据时，数据库系统要负责隔离操作，以保证各个连接在获取数据时的准确性
-- 2. 如果不考虑隔离，可能会发生如下问题：
-- -- -- 1.脏读：当一个事务读取另一个事务尚未提交修改的数据
-- -- -- 2.不可重复读：同一查询在同一事务中多次进行，由于其他提交事务所作的修改或删除，每次返回不同的结果集时发生不可重复读
-- -- -- （A,B 两个会话正在执行事务，A commit 了B查询过的数据，B再次查询时，结果变了[因为B前面查询的是A修改前的数据集]）
-- -- -- 3.幻读：同一查询在同一事务中多次进行，由于其他提交事务所做的插入操作，每次返回不同的结果集时发生
事务隔离级别								脏读	不可重复读	幻读	枷锁读
读未提交（read-uncommitted）	是			是			是			否
读已提交（read-committed）		否			是			是			否
可重复读（repeatable-read）		否			否			是			否
串行化（serializable）				否			否			否			是

# 栗子
SELECT @@transaction_isolation -- 查询隔离级别
SET SESSION TRANSACTION ISOLATION LEVEL UNCOMMITTED -- 设置会话隔离级别
SET GLOBAL TRANSACTION ISOLATION LEVEL UNCOMMITTED -- 设置全局隔离级别


# 表类型和存储引擎 start ----------------------------------------------
-- 1.表类型由存储引擎决定，主要有 INNODB, MyISAM， memory 等
-- 2.数据表主要支持6种类型,CSV,MEMORY,ARCHIVE,MRG_MYISAM,MYIAM,INNOBDB
-- 3.这6种类型又分为两类
-- -- -- 1.事务安全，如 INNODB
-- -- -- 2.非事务安全,其余5种

-- 引擎区别
# INNODB : 唯一支持外键，支持事务，较慢
# myisam : 添加速度快，支持表级锁
# memory : 存在内存，执行速度快（没 IO 读写），默认支持索引（hash 索引）,硬盘只存表结构

-- 修改存储引擎 
ALTER TABLE tb ENGINE = `xx`
#栗子
SHOW ENGINES  -- 查看所有引擎


# 视图 view
-- 视图是一个虚拟表，其内容由查询定义。同真实的表一样，视图包含列，其数据来自对应的真实表（基表）
-- 视图和基表关系的示意图
-- 可以基于视图创建视图
-- 视图可以基于多张表的数据，免去 join

# 栗子
CREATE VIEW view_name (field1,field2) as SELECT ...
ALTER VIEW view_name (f1,f2,f3) as SELECT ...
SHOW CREATE VIEW view_name
DROP VIEW view_name1,view_name2

CREATE VIEW view_name (f1,f2,f3) as SELECT name,sal,job FROM employee ;
# 修改视图数据
UPDATE view_name SET xx = 1 WHERE xx = 2


# mysql 管理 start ----------------------------------------------
-- 1. ‘user'@'192.168.1.%' 可以模糊指定登录IP
CREATE USER 'test'@'localhost' IDENTIFIED BY '123456'
SET PASSWORD = PASSWORD(new pass) -- 修改自己密码

ALTER USER 'test'@'localhost' IDENTIFIED WITH mysql_native_password  BY '123456' -- 修改其他用户密码

# 给用户分配权限
-- 1. 不指定host 则为 %

grant 权限列表 ON 库.表  TO 'user'@'login_loc' IDENTIFIED BY '密码' -- 分配权限
GRANT SELECT,INSERT  ON test.ttt TO 'test'@'localhost' WITH GRANT OPTION; -- 多个权限, 并允许其授权
GRANT ALL PRIVILEGES ON *.* TO 'test'@'localhost' WITH GRANT OPTION;
REVOKE ALL PRIVILEGES ON *.* FROM 'test'@'localhost'; -- 收回权限
REVOKE GRANT OPTION ON *.* FROM user_name; #收回赋权权限
flush privileges; #操作完后重新刷新权限