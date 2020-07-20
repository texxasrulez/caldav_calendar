/**
 * CalDAV Client
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

CREATE TABLE caldav_calendars (
  [calendar_id] int CHECK ([calendar_id] > 0) NOT NULL IDENTITY,
  [user_id] int CHECK ([user_id] > 0) NOT NULL DEFAULT '0',
  [name] varchar(255) NOT NULL,
  [color] varchar(8) NOT NULL,
  [showalarms] smallint NOT NULL DEFAULT '1',

  [caldav_url] varchar(1000) NOT NULL,
  [caldav_tag] varchar(255) DEFAULT NULL,
  [caldav_user] varchar(255) DEFAULT NULL,
  [caldav_pass] varchar(1024) DEFAULT NULL,
  [caldav_oauth_provider] varchar(255) DEFAULT NULL,
  [readonly] int NOT NULL DEFAULT '0',
  [caldav_last_change] datetime2(0) NOT NULL DEFAULT GETDATE(),

  PRIMARY KEY([calendar_id])
 ,
  CONSTRAINT [rc_caldav_calendars_user_id] FOREIGN KEY ([user_id])
  REFERENCES users([user_id]) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE INDEX [caldav_user_name_idx] ON caldav_calendars ([user_id], [name]);

CREATE TABLE caldav_events (
  [event_id] int CHECK ([event_id] > 0) NOT NULL IDENTITY,
  [calendar_id] int CHECK ([calendar_id] > 0) NOT NULL DEFAULT '0',
  [recurrence_id] int CHECK ([recurrence_id] > 0) NOT NULL DEFAULT '0',
  [uid] varchar(255) NOT NULL DEFAULT '',
  [instance] varchar(16) NOT NULL DEFAULT '',
  [isexception] smallint NOT NULL DEFAULT '0',
  [created] datetime2(0) NOT NULL DEFAULT '1000-01-01 00:00:00',
  [changed] datetime2(0) NOT NULL DEFAULT '1000-01-01 00:00:00',
  [sequence] int CHECK ([sequence] > 0) NOT NULL DEFAULT '0',
  [start] datetime2(0) NOT NULL DEFAULT '1000-01-01 00:00:00',
  [end] datetime2(0) NOT NULL DEFAULT '1000-01-01 00:00:00',
  [recurrence] varchar(1000) DEFAULT NULL,
  [title] varbinary(128) NOT NULL,
  [description] varbinary(2048) NOT NULL,
  [location] varbinary(2048) NOT NULL DEFAULT '',
  [categories] varchar(255) NOT NULL DEFAULT '',
  [url] varchar(255) NOT NULL DEFAULT '',
  [all_day] smallint NOT NULL DEFAULT '0',
  [free_busy] smallint NOT NULL DEFAULT '0',
  [priority] smallint NOT NULL DEFAULT '0',
  [sensitivity] smallint NOT NULL DEFAULT '0',
  [status] varchar(32) NOT NULL DEFAULT '',
  [alarms] varchar(max) NULL DEFAULT NULL,
  [attendees] varchar(max) DEFAULT NULL,
  [notifyat] datetime2(0) DEFAULT NULL,

  [caldav_url] varchar(1000) NOT NULL,
  [caldav_tag] varchar(255) DEFAULT NULL,
  [caldav_last_change] datetime2(0) NOT NULL DEFAULT GETDATE(),

  PRIMARY KEY([event_id])
 ,
  CONSTRAINT [rc_caldav_events_calendar_id] FOREIGN KEY ([calendar_id])
  REFERENCES caldav_calendars([calendar_id]) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE INDEX [caldav_uid_idx] ON caldav_events ([uid]);
CREATE INDEX [caldav_recurrence_idx] ON caldav_events ([recurrence_id]);
CREATE INDEX [caldav_calendar_notify_idx] ON caldav_events ([calendar_id],[notifyat]);

CREATE TABLE caldav_attachments (
  [attachment_id] int CHECK ([attachment_id] > 0) NOT NULL IDENTITY,
  [event_id] int CHECK ([event_id] > 0) NOT NULL DEFAULT '0',
  [filename] varchar(255) NOT NULL DEFAULT '',
  [mimetype] varchar(255) NOT NULL DEFAULT '',
  [size] int NOT NULL DEFAULT '0',
  [data] varchar(max) NOT NULL,
  PRIMARY KEY([attachment_id]),
  CONSTRAINT [rc_caldav_attachments_event_id] FOREIGN KEY ([event_id])
  REFERENCES caldav_events([event_id]) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

REPLACE INTO `system` ([name], [value]) SELECT ('texxasrulez-calendar-caldav-version', '2020072000');
