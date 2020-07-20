/**
 * Roundcube Calendar
 *
 * Plugin to add a calendar to Roundcube.
 *
 * @author Gene Hawkins <texxasrulez@yahoo.com>
 * @author Lazlo Westerhof
 * @author Thomas Bruederli
 * @author Albert Lee
 * @licence GNU AGPL
 * @copyright (c) 2010 Lazlo Westerhof - Netherlands
 * @copyright (c) 2014 Kolab Systems AG
 *
 **/

CREATE TABLE IF NOT EXISTS IF NOT EXISTS calendars (
  `calendar_id` int CHECK (`calendar_id` > 0) NOT NULL AUTO_INCREMENT,
  `user_id` int CHECK (`user_id` > 0) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `color` varchar(8) NOT NULL,
  `showalarms` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY(`calendar_id`)
 ,
  CONSTRAINT `fk_calendars_user_id` FOREIGN KEY (`user_id`)
    REFERENCES users(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE INDEX `user_name_idx` ON calendars (`user_id`, `name`);

CREATE TABLE IF NOT EXISTS IF NOT EXISTS events (
  `event_id` int CHECK (`event_id` > 0) NOT NULL AUTO_INCREMENT,
  `calendar_id` int CHECK (`calendar_id` > 0) NOT NULL DEFAULT '0',
  `recurrence_id` int CHECK (`recurrence_id` > 0) NOT NULL DEFAULT '0',
  `uid` varchar(255) NOT NULL DEFAULT '',
  `instance` varchar(16) NOT NULL DEFAULT '',
  `isexception` tinyint NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `changed` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `sequence` int CHECK (`sequence` > 0) NOT NULL DEFAULT '0',
  `start` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `end` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `recurrence` varchar(255) DEFAULT NULL,
  `title` varbinary(128) NOT NULL,
  `description` text NOT NULL,
  `location` varchar(255) NOT NULL DEFAULT '',
  `categories` varchar(255) NOT NULL DEFAULT '',
  `url` varchar(255) NOT NULL DEFAULT '',
  `all_day` tinyint NOT NULL DEFAULT '0',
  `free_busy` tinyint NOT NULL DEFAULT '0',
  `priority` tinyint NOT NULL DEFAULT '0',
  `sensitivity` tinyint NOT NULL DEFAULT '0',
  `status` varchar(32) NOT NULL DEFAULT '',
  `alarms` text DEFAULT NULL,
  `attendees` text DEFAULT NULL,
  `notifyat` datetime DEFAULT NULL,
  PRIMARY KEY(`event_id`)
 ,
  CONSTRAINT `fk_events_calendar_id` FOREIGN KEY (`calendar_id`)
    REFERENCES calendars(`calendar_id`) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE INDEX `uid_idx` ON events (`uid`);
CREATE INDEX `recurrence_idx` ON events (`recurrence_id`);
CREATE INDEX `calendar_notify_idx` ON events (`calendar_id`,`notifyat`);

CREATE TABLE IF NOT EXISTS IF NOT EXISTS attachments (
  `attachment_id` int CHECK (`attachment_id` > 0) NOT NULL AUTO_INCREMENT,
  `event_id` int CHECK (`event_id` > 0) NOT NULL DEFAULT '0',
  `filename` varchar(255) NOT NULL DEFAULT '',
  `mimetype` varchar(255) NOT NULL DEFAULT '',
  `size` int NOT NULL DEFAULT '0',
  `data` longtext NOT NULL,
  PRIMARY KEY(`attachment_id`),
  CONSTRAINT `fk_attachments_event_id` FOREIGN KEY (`event_id`)
    REFERENCES events(`event_id`) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE TABLE IF NOT EXISTS IF NOT EXISTS itipinvitations (
  `token` VARCHAR(64) NOT NULL,
  `event_uid` VARCHAR(255) NOT NULL,
  `user_id` int CHECK (`user_id` > 0) NOT NULL DEFAULT '0',
  `event` TEXT NOT NULL,
  `expires` DATETIME DEFAULT NULL,
  `cancelled` TINYINT CHECK (`cancelled` > 0) NOT NULL DEFAULT '0',
  PRIMARY KEY(`token`)
 ,
  CONSTRAINT `fk_itipinvitations_user_id` FOREIGN KEY (`user_id`)
    REFERENCES users(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE INDEX `uid_idx` ON itipinvitations (`user_id`,`event_uid`);

REPLACE INTO `system` (`name`, `value`) SELECT ('texxasrulez-caldav-version', '2020072000');
