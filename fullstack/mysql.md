## MySQL遇到的问题

### 奇怪的导入问题

现象：已经存在库，希望通过mysqldump从其他数据源全量更新数据，但是报错"MySQL Cannot Add Foreign Key Constraint", 但是出错行上并没有Foreign Key.

```sql
DROP TABLE IF EXISTS `cwd_application`;
CREATE TABLE `cwd_application` (
  `ID` decimal(18,0) NOT NULL,
  `application_name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `lower_application_name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `updated_date` datetime DEFAULT NULL,
  `active` decimal(9,0) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `application_type` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `credential` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_application_name` (`lower_application_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
```

原因： 待查
做法:  "drop database", 重新导入
