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

CREATE SEQUENCE caldav_attachments_seq;

CREATE TABLE IF NOT EXISTS IF NOT EXISTS caldav_attachments (
  attachment_id int CHECK (attachment_id > 0) NOT NULL DEFAULT NEXTVAL ('caldav_attachments_seq'),
  event_id int CHECK (event_id > 0) NOT NULL DEFAULT '0',
  filename varchar(255) NOT NULL DEFAULT '',
  mimetype varchar(255) NOT NULL DEFAULT '',
  size int NOT NULL DEFAULT '0',
  data longtext NOT NULL,
  PRIMARY KEY (attachment_id)
)  ;

CREATE INDEX fk_caldav_attachments_event_id ON caldav_attachments (event_id);

CREATE SEQUENCE caldav_calendars_seq;

CREATE TABLE IF NOT EXISTS IF NOT EXISTS caldav_calendars (
  calendar_id int CHECK (calendar_id > 0) NOT NULL DEFAULT NEXTVAL ('caldav_calendars_seq'),
  user_id int CHECK (user_id > 0) NOT NULL DEFAULT '0',
  name varchar(255) NOT NULL,
  color varchar(8) NOT NULL,
  showalarms smallint NOT NULL DEFAULT '1',
  caldav_url varchar(1000) NOT NULL,
  caldav_tag varchar(255) DEFAULT NULL,
  caldav_user varchar(255) DEFAULT NULL,
  caldav_pass varchar(1024) DEFAULT NULL,
  caldav_oauth_provider varchar(255) DEFAULT NULL,
  readonly int NOT NULL DEFAULT '0',
  caldav_last_change timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (calendar_id)
)  ;

CREATE INDEX caldav_user_name_idx ON caldav_calendars (user_id,name);

CREATE SEQUENCE caldav_events_seq;

CREATE TABLE IF NOT EXISTS IF NOT EXISTS caldav_events (
  event_id int CHECK (event_id > 0) NOT NULL DEFAULT NEXTVAL ('caldav_events_seq'),
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
  recurrence varchar(1000) DEFAULT NULL,
  title bytea NOT NULL,
  description text NOT NULL,
  location varchar(255) NOT NULL DEFAULT '',
  categories varchar(255) NOT NULL DEFAULT '',
  url varchar(255) NOT NULL DEFAULT '',
  all_day smallint NOT NULL DEFAULT '0',
  free_busy smallint NOT NULL DEFAULT '0',
  priority smallint NOT NULL DEFAULT '0',
  sensitivity smallint NOT NULL DEFAULT '0',
  status varchar(32) NOT NULL DEFAULT '',
  alarms text,
  attendees text,
  notifyat timestamp(0) DEFAULT NULL,
  caldav_url varchar(1000) NOT NULL,
  caldav_tag varchar(255) DEFAULT NULL,
  caldav_last_change timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (event_id)
)  ;

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

REPLACE INTO `system` (name, value) SELECT ('texxasrulez-caldav_calendar', '2020072000');
