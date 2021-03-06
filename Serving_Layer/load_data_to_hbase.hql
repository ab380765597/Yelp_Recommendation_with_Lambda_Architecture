CREATE EXTERNAL TABLE yelp_business_wrc_not_orc_3(
    title String,
    url String,
    categories String,
    review_count long , 
    rating double, 
    is_closed String,
    address String,
    city String
    )
COMMENT 'intermediate non orc table, DATA ABOUT businesss on yelp, added with calculated rating by all users and active users(> 10 reviews)'
ROW FORMAT
DELIMITED FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n';

-- LOAD DATA INPATH 'hdfs:///user/cloudera/pyspark/business_w_active_review_count' OVERWRITE INTO TABLE yelp_business_wrc_not_orc_2;
LOAD DATA INPATH 'hdfs:///apps/hive/warehouse/yelp_business_wrc_not_orc' OVERWRITE INTO TABLE yelp_business_wrc_not_orc_2;

CREATE TABLE yelp_business_wrc_hbase_sync_2(
    title String,
    categories String,
    review_count BIGINT, 
    stars String, 
    open String,
    full_address String,
    city String,
    state String,
    longitude String,
    latitude String
    )
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
with SERDEPROPERTIES ("hbase.columns.mapping" = ":key, business:name, business:categories, business:review_count, 
    business:stars, business:open, business:full_address, business:city, business:state, business:longitude, business:latitude, business:review_count_active_user, business:review_count_all_user")
TBLPROPERTIES ("hbase.table.name" = "yelp_business_wrc_hbase_sync_2");

INSERT OVERWRITE TABLE yelp_business_wrc_hbase_sync_2 SELECT * FROM yelp_business_wrc_not_orc_2;
