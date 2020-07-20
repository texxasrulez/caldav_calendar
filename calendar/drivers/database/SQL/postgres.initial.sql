/**
 * Roundcube Calendar
 *
 * Plugin to add a calendar to Roundcube.
 *
 * @author Gene Hawkins <texxasrulez@yahoo.com>
 * @author Lazlo Westerhof
 * @author Thomas Bruederli
 * @licence GNU AGPL
 * @copyright (c) 2010 Lazlo Westerhof - Netherlands
 * @copyright (c) 2014 Kolab Systems AG
 *
 */

CREATE SEQUENCE calendars_seq;

CREATE TABLE IF NOT EXISTS calendars (
  calendar_id int CHECK (calendar_id > 0) NOT NULL DEFAULT NEXTVAL ('calendars_seq'),
  user_id int CHECK (user_id > 0) NOT NULL DEFAULT '0',
  name varchar(255) NOT NULL,
  color varchar(8) NOT NULL,
  showalarms smallint NOT NULL DEFAULT '1',
  PRIMARY KEY(calendar_id)
 ,
  CONSTRAINT rc_calendars_user_id FOREIGN KEY (user_id)
    REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE INDEX user_name_idx ON calendars (user_id, name);

CREATE SEQUENCE events_seq;

CREATE TABLE IF NOT EXISTS events (
  event_id int CHECK (event_id > 0) NOT NULL DEFAULT NEXTVAL ('events_seq'),
  calendar_id int CHECK (calendar_id > 0) NOT NULL DEFAULT '0',
  recurrence_id int CHECK (recurrence_id > 0) NOT NULL DEFAULT '0',
  uid varchar(255) NOT NULL DEFAULT '',
  instance varchar(16) NOT NULL DEFAULT '',
  isexception smallint NOT NULL DEFAULT '0',
  created timestamp(0) NOT NULL DEFAULT '1000-01-01 00:00:00',
  changed timestamp(0) NOT NULL DEFAULT '1000-01-01 00:00:00',
  sequence int CHECK (sequence > 0) NOT NULL DEFAULT '0',
  start timestamp(0) NOT NULL DEFAULT '1000-01-01 00:00:00',
  end timestamp(0) NOT NULL DEFAULT '1000-01-01 00:00:00',
  recurrence varchar(255) DEFAULT NULL,
  title bytea NOT NULL,
  description bytea NOT NULL,
  location varchar(255) NOT NULL DEFAULT '',
  categories varchar(255) NOT NULL DEFAULT '',
  url varchar(255) NOT NULL DEFAULT '',
  all_day smallint NOT NULL DEFAULT '0',
  free_busy smallint NOT NULL DEFAULT '0',
  priority smallint NOT NULL DEFAULT '0',
  sensitivity smallint NOT NULL DEFAULT '0',
  status text NOT NULL DEFAULT '',
  alarms text DEFAULT NULL,
  attendees text DEFAULT NULL,
  notifyat timestamp(0) DEFAULT NULL,
  PRIMARY KEY(event_id)
 ,
  CONSTRAINT rc_events_calendar_id FOREIGN KEY (calendar_id)
    REFERENCES calendars(calendar_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE INDEX uid_idx ON events (uid);
CREATE INDEX recurrence_idx ON events (recurrence_id);
CREATE INDEX calendar_notify_idx ON events (calendar_id,notifyat);

CREATE SEQUENCE attachments_seq;

CREATE TABLE IF NOT EXISTS attachments (
  attachment_id int CHECK (attachment_id > 0) NOT NULL DEFAULT NEXTVAL ('attachments_seq'),
  event_id int CHECK (event_id > 0) NOT NULL DEFAULT '0',
  filename varchar(255) NOT NULL DEFAULT '',
  mimetype varchar(255) NOT NULL DEFAULT '',
  size int NOT NULL DEFAULT '0',
  data longtext NOT NULL,
  PRIMARY KEY(attachment_id),
  CONSTRAINT rc_attachments_event_id FOREIGN KEY (event_id)
    REFERENCES events(event_id) ON DELETE CASCADE ON UPDATE CASCADE
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

CREATE INDEX uid_idx ON itipinvitations (user_id,event_uid);

REPLACE INTO `system` (name, value) SELECT ('texxasrulez-caldav-version', '2020072000');
