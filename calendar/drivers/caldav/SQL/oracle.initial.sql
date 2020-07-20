/**
 * CalDAV Client
 *
 * @author Gene Hawkins <texxasrulez@yahoo.com>
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

CREATE TABLE IF NOT EXISTS caldav_attachments (
  attachment_id number(10) CHECK (attachment_id > 0) NOT NULL,
  event_id number(10) DEFAULT '0' CHECK (event_id > 0) NOT NULL,
  filename varchar2(255) DEFAULT '' NOT NULL,
  mimetype varchar2(255) DEFAULT '' NOT NULL,
  size number(10) DEFAULT '0' NOT NULL,
  data clob NOT NULL,
  PRIMARY KEY (attachment_id)
)  ;

-- Generate ID using sequence and trigger
CREATE SEQUENCE caldav_attachments_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER caldav_attachments_seq_tr
 BEFORE INSERT ON caldav_attachments FOR EACH ROW
 WHEN (NEW.attachment_id IS NULL)
BEGIN
 SELECT caldav_attachments_seq.NEXTVAL INTO :NEW.attachment_id FROM DUAL;
END;
/

CREATE INDEX fk_caldav_attachments_event_id ON caldav_attachments (event_id);

CREATE TABLE IF NOT EXISTS caldav_calendars (
  calendar_id number(10) CHECK (calendar_id > 0) NOT NULL,
  user_id number(10) DEFAULT '0' CHECK (user_id > 0) NOT NULL,
  name varchar2(255) NOT NULL,
  color varchar2(8) NOT NULL,
  showalarms number(3) DEFAULT '1' NOT NULL,
  caldav_url varchar2(1000) NOT NULL,
  caldav_tag varchar2(255) DEFAULT NULL,
  caldav_user varchar2(255) DEFAULT NULL,
  caldav_pass varchar2(1024) DEFAULT NULL,
  caldav_oauth_provider varchar2(255) DEFAULT NULL,
  readonly number(10) DEFAULT '0' NOT NULL,
  caldav_last_change timestamp(0) DEFAULT SYSTIMESTAMP NOT NULL,
  PRIMARY KEY (calendar_id)
)  ;

-- Generate ID using sequence and trigger
CREATE SEQUENCE caldav_calendars_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER caldav_calendars_seq_tr
 BEFORE INSERT ON caldav_calendars FOR EACH ROW
 WHEN (NEW.calendar_id IS NULL)
BEGIN
 SELECT caldav_calendars_seq.NEXTVAL INTO :NEW.calendar_id FROM DUAL;
END;
/

CREATE INDEX caldav_user_name_idx ON caldav_calendars (user_id,name);

CREATE TABLE IF NOT EXISTS caldav_events (
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
  recurrence varchar2(1000) DEFAULT NULL,
  title raw(128) NOT NULL,
  description clob NOT NULL,
  location varchar2(255) DEFAULT '' NOT NULL,
  categories varchar2(255) DEFAULT '' NOT NULL,
  url varchar2(255) DEFAULT '' NOT NULL,
  all_day number(3) DEFAULT '0' NOT NULL,
  free_busy number(3) DEFAULT '0' NOT NULL,
  priority number(3) DEFAULT '0' NOT NULL,
  sensitivity number(3) DEFAULT '0' NOT NULL,
  status varchar2(32) DEFAULT '' NOT NULL,
  alarms clob,
  attendees clob,
  notifyat timestamp(0) DEFAULT NULL,
  caldav_url varchar2(1000) NOT NULL,
  caldav_tag varchar2(255) DEFAULT NULL,
  caldav_last_change timestamp(0) DEFAULT SYSTIMESTAMP NOT NULL,
  PRIMARY KEY (event_id)
)  ;

-- Generate ID using sequence and trigger
CREATE SEQUENCE caldav_events_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER caldav_events_seq_tr
 BEFORE INSERT ON caldav_events FOR EACH ROW
 WHEN (NEW.event_id IS NULL)
BEGIN
 SELECT caldav_events_seq.NEXTVAL INTO :NEW.event_id FROM DUAL;
END;
/

CREATE INDEX caldav_uid_idx ON caldav_events (uid);
CREATE INDEX caldav_recurrence_idx ON caldav_events (recurrence_id);
CREATE INDEX caldav_calendar_notify_idx ON caldav_events (calendar_id,notifyat);

ALTER TABLE caldav_attachments
  ADD CONSTRAINT fk_caldav_attachments_event_id FOREIGN KEY (event_id) REFERENCES caldav_events (event_id) ON DELETE CASCADE ON UPDATE CASCADE;
  
ALTER TABLE caldav_calendars
  ADD CONSTRAINT fk_caldav_calendars_user_id FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE ON UPDATE CASCADE;
  
ALTER TABLE caldav_events
  ADD CONSTRAINT fk_caldav_events_calendar_id FOREIGN KEY (calendar_id) REFERENCES caldav_calendars (calendar_id) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

REPLACE INTO `system` (name, value) SELECT  'texxasrulez-caldav_calendar', '2020072000'  FROM dual;
