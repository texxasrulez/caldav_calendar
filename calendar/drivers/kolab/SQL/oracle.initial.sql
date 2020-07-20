/**
 * Roundcube Calendar Kolab backend
 *
 * @author Gene Hawkins <texxasrulez@yahoo.com>
 * @author Sergey Sidlyarenko
 * @licence GNU AGPL
 **/

CREATE TABLE kolab_alarms (
  alarm_id VARCHAR2(255) NOT NULL,
  user_id number(10) CHECK (user_id > 0) NOT NULL,
  notifyat TIMESTAMP(0) DEFAULT NULL,
  dismissed NUMBER(3) DEFAULT '0' CHECK (dismissed > 0) NOT NULL,
  PRIMARY KEY(alarm_id,user_id),
  CONSTRAINT rc_kolab_alarms_user_id FOREIGN KEY (user_id)
    REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE TABLE itipinvitations (
  token VARCHAR2(64) NOT NULL,
  event_uid VARCHAR2(255) NOT NULL,
  user_id number(10) DEFAULT '0' CHECK (user_id > 0) NOT NULL,
  event CLOB NOT NULL,
  expires TIMESTAMP(0) DEFAULT NULL,
  cancelled NUMBER(3) DEFAULT '0' CHECK (cancelled > 0) NOT NULL,
  PRIMARY KEY(token)
 ,
  CONSTRAINT rc_itipinvitations_user_id FOREIGN KEY (user_id)
    REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE INDEX uid_idx ON itipinvitations (event_uid,user_id);

REPLACE INTO dbms_scheduler.create_job(job_name => '_job', job_type => 'EXECUTABLE', job_action => (, enabled => true)name, value) SELECT  'texxasrulez-kolab-version', '2020072000'  FROM dual;
