/**
 * iCAL Client
 *
 * @author Gene Hawkins <texxasrulez@yahoo.com>
 * @version @package-version@
 * @author Daniel Morlock <daniel.morlock@awesome-it.de>
 *
 * Copyright (C) Awesome IT GbR <info@awesome-it.de>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

CREATE TABLE ical_calendars (
  calendar_id number(10) CHECK (calendar_id > 0) NOT NULL,
  user_id number(10) DEFAULT '0' CHECK (user_id > 0) NOT NULL,
  name varchar2(255) NOT NULL,
  color varchar2(8) NOT NULL,
  showalarms number(3) DEFAULT '1' NOT NULL,

  ical_url varchar2(1000) NOT NULL,
  ical_tag varchar2(255) DEFAULT NULL,
  ical_user varchar2(255) DEFAULT NULL,
  ical_pass varchar2(1024) DEFAULT NULL,
  ical_oauth_provider varchar2(255) DEFAULT NULL,
  readonly number(10) DEFAULT '0' NOT NULL,
  ical_last_change timestamp(0) DEFAULT SYSTIMESTAMP NOT NULL,

  PRIMARY KEY(calendar_id)
 ,
  CONSTRAINT rc_ical_calendars_user_id FOREIGN KEY (user_id)
  REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

-- Generate ID using sequence and trigger
CREATE SEQUENCE ical_calendars_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER ical_calendars_seq_tr
 BEFORE INSERT ON ical_calendars FOR EACH ROW
 WHEN (NEW.calendar_id IS NULL)
BEGIN
 SELECT ical_calendars_seq.NEXTVAL INTO :NEW.calendar_id FROM DUAL;
END;
/

CREATE INDEX ical_user_name_idx ON ical_calendars (user_id, name);

CREATE TABLE ical_events (
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
  description raw(128) NOT NULL,
  location varchar2(255) DEFAULT '' NOT NULL,
  categories varchar2(255) DEFAULT '' NOT NULL,
  url varchar2(255) DEFAULT '' NOT NULL,
  all_day number(3) DEFAULT '0' NOT NULL,
  free_busy number(3) DEFAULT '0' NOT NULL,
  priority number(3) DEFAULT '0' NOT NULL,
  sensitivity number(3) DEFAULT '0' NOT NULL,
  status varchar2(32) DEFAULT '' NOT NULL,
  alarms clob DEFAULT NULL NULL,
  attendees clob DEFAULT NULL,
  notifyat timestamp(0) DEFAULT NULL,

  ical_url varchar2(255) NOT NULL,
  ical_tag varchar2(255) DEFAULT NULL,
  ical_last_change timestamp(0) DEFAULT SYSTIMESTAMP NOT NULL,

  PRIMARY KEY(event_id)
 ,
  CONSTRAINT rc_ical_events_calendar_id FOREIGN KEY (calendar_id)
  REFERENCES ical_calendars(calendar_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

-- Generate ID using sequence and trigger
CREATE SEQUENCE ical_events_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER ical_events_seq_tr
 BEFORE INSERT ON ical_events FOR EACH ROW
 WHEN (NEW.event_id IS NULL)
BEGIN
 SELECT ical_events_seq.NEXTVAL INTO :NEW.event_id FROM DUAL;
END;
/

CREATE INDEX ical_uid_idx ON ical_events (uid);
CREATE INDEX ical_recurrence_idx ON ical_events (recurrence_id);
CREATE INDEX ical_calendar_notify_idx ON ical_events (calendar_id,notifyat);

CREATE TABLE ical_attachments (
  attachment_id number(10) CHECK (attachment_id > 0) NOT NULL,
  event_id number(10) DEFAULT '0' CHECK (event_id > 0) NOT NULL,
  filename varchar2(255) DEFAULT '' NOT NULL,
  mimetype varchar2(255) DEFAULT '' NOT NULL,
  size number(10) DEFAULT '0' NOT NULL,
  data clob NOT NULL,
  PRIMARY KEY(attachment_id),
  CONSTRAINT rc_ical_attachments_event_id FOREIGN KEY (event_id)
  REFERENCES ical_events(event_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

-- Generate ID using sequence and trigger
CREATE SEQUENCE ical_attachments_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER ical_attachments_seq_tr
 BEFORE INSERT ON ical_attachments FOR EACH ROW
 WHEN (NEW.attachment_id IS NULL)
BEGIN
 SELECT ical_attachments_seq.NEXTVAL INTO :NEW.attachment_id FROM DUAL;
END;
/

REPLACE INTO `system` (name, value) SELECT  'texxasrulez-ical-version', '2020072000'  FROM dual;
