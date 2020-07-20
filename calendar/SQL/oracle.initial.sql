/**
 * Roundcube CalDav Calendar
 *
 * @author Gene Hawkins <texxasrulez@yahoo.com>
 *
 * @licence GNU AGPL
 **/

CREATE TABLE calendar_oauth_states (
  provider VARCHAR2(255) NOT NULL,
  client_config_id VARCHAR2(255) NOT NULL,
  user_id VARCHAR2(255) NOT NULL,
  scope VARCHAR2(255) NOT NULL,
  issue_time NUMBER(10) NOT NULL,
  state VARCHAR2(255) NOT NULL,
  UNIQUE (provider_id, client_config_id, user_id, scope),
  PRIMARY KEY (state)
);

CREATE TABLE calendar_oauth_access_tokens (
  provider VARCHAR2(255) NOT NULL,
  client_config_id VARCHAR2(255) NOT NULL,
  user_id VARCHAR2(255) NOT NULL,
  scope VARCHAR2(255) NOT NULL,
  issue_time NUMBER(10) NOT NULL,
  access_token VARCHAR2(255) NOT NULL,
  token_type VARCHAR2(255) NOT NULL,
  expires_in NUMBER(10) DEFAULT NULL,
  UNIQUE (provider_id, client_config_id, user_id, scope)
);

CREATE TABLE calendar_oauth_refresh_tokens (
  provider VARCHAR2(255) NOT NULL,
  client_config_id VARCHAR2(255) NOT NULL,
  user_id VARCHAR2(255) NOT NULL,
  scope VARCHAR2(255) NOT NULL,
  issue_time NUMBER(10) NOT NULL,
  refresh_token VARCHAR2(255) DEFAULT NULL,
  UNIQUE (provider_id, client_config_id, user_id, scope)
);

REPLACE INTO `system` (name, value) SELECT  'texxasrulez-calendar-version', '2020072000'  FROM dual;
