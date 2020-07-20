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

CREATE TABLE calendars (
  calendar_id number(10) CHECK (calendar_id > 0) NOT NULL,
  user_id number(10) DEFAULT '0' CHECK (user_id > 0) NOT NULL,
  name varchar2(255) NOT NULL,
  color varchar2(8) NOT NULL,
  showalarms number(3) DEFAULT '1' NOT NULL,
  PRIMARY KEY(calendar_id)
 ,
  CONSTRAINT rc_calendars_user_id FOREIGN KEY (user_id)
    REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

-- Generate ID using sequence and trigger
CREATE SEQUENCE calendars_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER calendars_seq_tr
 BEFORE INSERT ON calendars FOR EACH ROW
 WHEN (NEW.calendar_id IS NULL)
BEGIN
 SELECT calendars_seq.NEXTVAL INTO :NEW.calendar_id FROM DUAL;
END;
/

CREATE INDEX user_name_idx ON calendars (user_id, name);

CREATE TABLE events (
  event_id number(10) CHECK (event_id > 0) NOT NULL,
  calendar_id number(10) DEFAULT '0' CHECK (calendar_id > 0) NOT NULL,
  recurrence_id number(10) DEFAULT '0' CHECK (recurrence_id > 0) NOT NULL,
  uid varchar2(255) DEFAULT '' NOT NULL,
  instance varchar2(16) DEFAULT '' NOT NULL,
  isexception number(3) DEFAULT '0' NOT NULL,
  created timestamp(0) DEFAULT TO_TIMESTAMP('1000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF') NOT NULL,
  changed timestamp(0) DEFAULT TO_TIMESTAMP('1000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF') NOT NULL,
  sequence number(10) DEFAULT '0' CHECK (sequence > 0) NOT NULL,
  start timestamp(0) DEFAULT TO_TIMESTAMP('1000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF') NOT NULL,
  end timestamp(0) DEFAULT TO_TIMESTAMP('1000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF') NOT NULL,
  recurrence varchar2(255) DEFAULT NULL,
  title raw(128) NOT NULL,
  description raw(2048) NOT NULL,
  location varchar2(255) DEFAULT '' NOT NULL,
  categories varchar2(255) DEFAULT '' NOT NULL,
  url varchar2(255) DEFAULT '' NOT NULL,
  all_day number(3) DEFAULT '0' NOT NULL,
  free_busy number(3) DEFAULT '0' NOT NULL,
  priority number(3) DEFAULT '0' NOT NULL,
  sensitivity number(3) DEFAULT '0' NOT NULL,
  status clob DEFAULT '' NOT NULL,
  alarms clob DEFAULT NULL,
  attendees clob DEFAULT NULL,
  notifyat timestamp(0) DEFAULT NULL,
  PRIMARY KEY(event_id)
 ,
  CONSTRAINT rc_events_calendar_id FOREIGN KEY (calendar_id)
    REFERENCES calendars(calendar_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

-- Generate ID using sequence and trigger
CREATE SEQUENCE events_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER events_seq_tr
 BEFORE INSERT ON events FOR EACH ROW
 WHEN (NEW.event_id IS NULL)
BEGIN
 SELECT events_seq.NEXTVAL INTO :NEW.event_id FROM DUAL;
END;
/

CREATE INDEX uid_idx ON events (uid);
CREATE INDEX recurrence_idx ON events (recurrence_id);
CREATE INDEX calendar_notify_idx ON events (calendar_id,notifyat);

CREATE TABLE attachments (
  attachment_id number(10) CHECK (attachment_id > 0) NOT NULL,
  event_id number(10) DEFAULT '0' CHECK (event_id > 0) NOT NULL,
  filename varchar2(255) DEFAULT '' NOT NULL,
  mimetype varchar2(255) DEFAULT '' NOT NULL,
  size number(10) DEFAULT '0' NOT NULL,
  data clob NOT NULL,
  PRIMARY KEY(attachment_id),
  CONSTRAINT rc_attachments_event_id FOREIGN KEY (event_id)
    REFERENCES events(event_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

-- Generate ID using sequence and trigger
CREATE SEQUENCE attachments_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER attachments_seq_tr
 BEFORE INSERT ON attachments FOR EACH ROW
 WHEN (NEW.attachment_id IS NULL)
BEGIN
 SELECT attachments_seq.NEXTVAL INTO :NEW.attachment_id FROM DUAL;
END;
/

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

CREATE INDEX uid_idx ON itipinvitations (user_id,event_uid);

REPLACE INTO `system` (name, value) SELECT  'texxasrulez-caldav-version', '2020072000'  FROM dual;
