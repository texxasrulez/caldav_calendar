/**
 * CalDAV Client
 *
 * @version @package_version@
 * @author Hugo Slabbert <hugo@slabnet.com>
 *
 * Copyright (C) 2014, Hugo Slabbert <hugo@slabnet.com>
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

CREATE TYPE caldav_type AS ENUM ('vcal','vevent','vtodo','');

CREATE TABLE IF NOT EXISTS caldav_props (
  obj_id int NOT NULL,
  obj_type caldav_type NOT NULL,
  url varchar(255) NOT NULL,
  tag varchar(255) DEFAULT NULL,
  username varchar(255) DEFAULT NULL,
  pass varchar(1024) DEFAULT NULL,
  last_change timestamp without time zone DEFAULT now() NOT NULL,
  PRIMARY KEY (obj_id, obj_type)
);

CREATE OR REPLACE FUNCTION upd_timestamp() RETURNS TRIGGER 
LANGUAGE plpgsql
AS
$$
BEGIN
    NEW.last_change = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

CREATE TRIGGER update_timestamp
  BEFORE INSERT OR UPDATE
  ON caldav_props
  FOR EACH ROW
  EXECUTE PROCEDURE upd_timestamp();


CREATE OR REPLACE FUNCTION update_caldav_last_change_column()
RETURNS TRIGGER AS $$
BEGIN
	   NEW.caldav_last_change = now(); 
	   RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TABLE IF NOT EXISTS "caldav_calendars" (
  "calendar_id" SERIAL,
  "user_id" BIGINT NOT NULL DEFAULT '0',
  "name" varchar(255) NOT NULL,
  "color" varchar(8) NOT NULL,
  "showalarms" SMALLINT NOT NULL DEFAULT '1',

  "caldav_url" varchar(1000) NOT NULL,
  "caldav_tag" varchar(255) DEFAULT NULL,
  "caldav_user" varchar(255) DEFAULT NULL,
  "caldav_pass" varchar(1024) DEFAULT NULL,
  "caldav_oauth_provider" varchar(255) DEFAULT NULL,
  "readonly" int NOT NULL DEFAULT '0',
  "caldav_last_change" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY("calendar_id"),
  CONSTRAINT "fk_caldav_calendars_user_id" FOREIGN KEY ("user_id")
  REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8 COLLATE utf8_general_ci */;
CREATE INDEX ON caldav_calendars (user_id, name);

ALTER SEQUENCE caldav_calendars_calendar_id_seq RENAME TO caldav_calendars_seq;

CREATE TRIGGER update_caldav_calendars_update_caldav_last_change_column BEFORE UPDATE
    ON caldav_calendars FOR EACH ROW EXECUTE PROCEDURE 
    update_caldav_last_change_column();

CREATE TABLE IF NOT EXISTS "caldav_events" (
  "event_id" SERIAL,
  "calendar_id" BIGINT NOT NULL DEFAULT '0',
  "recurrence_id" BIGINT NOT NULL DEFAULT '0',
  "uid" varchar(255) NOT NULL DEFAULT '',
  "instance" varchar(16) NOT NULL DEFAULT '',
  "isexception" SMALLINT NOT NULL DEFAULT '0',
  "created" timestamp NOT NULL DEFAULT '1000-01-01 00:00:00',
  "changed" timestamp NOT NULL DEFAULT '1000-01-01 00:00:00',
  "sequence" BIGINT NOT NULL DEFAULT '0',
  "start" timestamp NOT NULL DEFAULT '1000-01-01 00:00:00',
  "end" timestamp NOT NULL DEFAULT '1000-01-01 00:00:00',
  "recurrence" varchar(1000) DEFAULT NULL,
  "title" varchar(255) NOT NULL,
  "description" text NOT NULL,
  "location" varchar(255) NOT NULL DEFAULT '',
  "categories" varchar(255) NOT NULL DEFAULT '',
  "url" varchar(255) NOT NULL DEFAULT '',
  "all_day" SMALLINT NOT NULL DEFAULT '0',
  "free_busy" SMALLINT NOT NULL DEFAULT '0',
  "priority" SMALLINT NOT NULL DEFAULT '0',
  "sensitivity" SMALLINT NOT NULL DEFAULT '0',
  "status" varchar(32) NOT NULL DEFAULT '',
  "alarms" text NULL DEFAULT NULL,
  "attendees" text DEFAULT NULL,
  "notifyat" timestamp DEFAULT NULL,

  "caldav_url" varchar(1000) NOT NULL,
  "caldav_tag" varchar(255) DEFAULT NULL,
  "caldav_last_change" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY("event_id"),
  CONSTRAINT "fk_caldav_events_calendar_id" FOREIGN KEY ("calendar_id")
  REFERENCES "caldav_calendars"("calendar_id") ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8 COLLATE utf8_general_ci */;
CREATE INDEX ON caldav_events (uid);
CREATE INDEX ON caldav_events (recurrence_id);
CREATE INDEX ON caldav_events (calendar_id, notifyat);;

ALTER SEQUENCE caldav_events_event_id_seq RENAME TO caldav_events_seq;

CREATE TRIGGER update_caldav_events_update_caldav_last_change_column BEFORE UPDATE
    ON caldav_events FOR EACH ROW EXECUTE PROCEDURE 
    update_caldav_last_change_column();

CREATE TABLE IF NOT EXISTS "caldav_attachments" (
  "attachment_id" SERIAL,
  "event_id" BIGINT NOT NULL DEFAULT '0',
  "filename" varchar(255) NOT NULL DEFAULT '',
  "mimetype" varchar(255) NOT NULL DEFAULT '',
  "size" BIGINT NOT NULL DEFAULT '0',
  "data" TEXT NOT NULL,
  PRIMARY KEY("attachment_id"),
  CONSTRAINT "fk_caldav_attachments_event_id" FOREIGN KEY ("event_id")
  REFERENCES "caldav_events"("event_id") ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8 COLLATE utf8_general_ci */;

ALTER SEQUENCE caldav_attachments_attachment_id_seq RENAME TO caldav_attachments_seq;

INSERT INTO "system" ("name", "value") VALUES ('calendar-caldav-version', '2019010100');
