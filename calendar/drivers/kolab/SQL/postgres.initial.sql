/**
 * Roundcube Calendar Kolab backend
 *
 * @author Gene Hawkins <texxasrulez@yahoo.com>
 * @author Sergey Sidlyarenko
 * @licence GNU AGPL
 **/

CREATE TABLE IF NOT EXISTS kolab_alarms (
  alarm_id VARCHAR(255) NOT NULL,
  user_id int CHECK (user_id > 0) NOT NULL,
  notifyat TIMESTAMP(0) DEFAULT NULL,
  dismissed SMALLINT CHECK (dismissed > 0) NOT NULL DEFAULT '0',
  PRIMARY KEY(alarm_id,user_id),
  CONSTRAINT rc_kolab_alarms_user_id FOREIGN KEY (user_id)
    REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE TABLE IF NOT EXISTS itipinvitations (
  token VARCHAR(64) NOT NULL,
  event_uid VARCHAR(255) NOT NULL,
  user_id int CHECK (user_id > 0) NOT NULL DEFAULT '0',
  event TEXT NOT NULL,
  expires TIMESTAMP(0) DEFAULT NULL,
  cancelled SMALLINT CHECK (cancelled > 0) NOT NULL DEFAULT '0',
  PRIMARY KEY(token)
 ,
  CONSTRAINT rc_itipinvitations_user_id FOREIGN KEY (user_id)
    REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE INDEX uid_idx ON itipinvitations (event_uid,user_id);

REPLACE INTO system (name, value) SELECT ('texxasrulez-kolab-version', '2020072000');
