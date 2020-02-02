/**
 * iCAL Client
 *
 * @version @package_version@
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

CREATE SEQUENCE ical_calendars_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE TABLE ical_calendars (
  calendar_id int DEFAULT nextval('ical_calendars_seq'::text) NOT NULL PRIMARY KEY,
  user_id int NOT NULL
    REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
  name varchar(255) NOT NULL,
  color varchar(8) NOT NULL,
  showalarms smallint NOT NULL DEFAULT '1',

  ical_url varchar(255) NOT NULL,
  ical_user varchar(255) DEFAULT NULL,
  ical_pass varchar(1024) DEFAULT NULL,
  ical_last_change timestamp with time zone DEFAULT now() NOT NULL
);

CREATE INDEX ical_user_name_idx ON ical_calendars (user_id, name);

CREATE SEQUENCE ical_events_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE TABLE ical_events (
  event_id int DEFAULT nextval('ical_events_seq'::text) NOT NULL PRIMARY KEY,
  calendar_id int NOT NULL
    REFERENCES ical_calendars(calendar_id) ON DELETE CASCADE ON UPDATE CASCADE,
  recurrence_id int NOT NULL DEFAULT 0,
  uid varchar(255) NOT NULL,
  instance varchar(16) NOT NULL DEFAULT '',
  isexception smallint NOT NULL DEFAULT 0,
  created timestamp with time zone DEFAULT now() NOT NULL,
  changed timestamp with time zone DEFAULT now() NOT NULL,
  sequence int NOT NULL DEFAULT 0,
  "start" timestamp with time zone DEFAULT now() NOT NULL,
  "end" timestamp with time zone DEFAULT now() NOT NULL,
  recurrence varchar(255) DEFAULT NULL,
  title varchar(255) NOT NULL,
  description text NOT NULL,
  location varchar(255) NOT NULL DEFAULT '',
  categories varchar(255) NOT NULL DEFAULT '',
  url varchar(255) NOT NULL DEFAULT '',
  all_day smallint NOT NULL DEFAULT 0,
  free_busy smallint NOT NULL DEFAULT 0,
  priority smallint NOT NULL DEFAULT 0,
  sensitivity smallint NOT NULL DEFAULT 0,
  status varchar(32) NOT NULL DEFAULT '',
  alarms text NULL DEFAULT NULL,
  attendees text DEFAULT NULL,
  notifyat timestamp DEFAULT NULL,

  ical_url varchar(255) NOT NULL,
  ical_last_change timestamp with time zone DEFAULT now() NOT NULL
);

CREATE INDEX ical_uid_idx ON caldav_events (uid);
CREATE INDEX ical_recurrence_idx ON caldav_events (recurrence_id);
CREATE INDEX ical_calendar_notify_idx ON caldav_events (calendar_id,notifyat);

CREATE SEQUENCE ical_attachments_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE TABLE ical_attachments (
  attachment_id int DEFAULT nextval('ical_attachments_seq'::text) NOT NULL PRIMARY KEY,
  event_id int NOT NULL
    REFERENCES ical_events(event_id) ON DELETE CASCADE ON UPDATE CASCADE,
  filename varchar(255) NOT NULL DEFAULT '',
  mimetype varchar(255) NOT NULL DEFAULT '',
  size int NOT NULL DEFAULT 0,
  data text NOT NULL
);

CREATE INDEX ical_attachments_event_id_idx ON ical_attachments (event_id);

INSERT INTO "system" (name, value) VALUES ('calendar-ical-version', '2015022700');
