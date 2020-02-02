CREATE TABLE calendar_oauth_states (
  provider VARCHAR(255) NOT NULL,
  client_config_id VARCHAR(255) NOT NULL,
  user_id VARCHAR(255) NOT NULL,
  scope VARCHAR(255) NOT NULL,
  issue_time INTEGER NOT NULL,
  state VARCHAR(255) NOT NULL PRIMARY KEY,
  CONSTRAINT calendar_oauth_states_unique_key UNIQUE (provider, client_config_id, user_id, scope)
);

CREATE TABLE calendar_oauth_access_tokens (
  provider VARCHAR(255) NOT NULL,
  client_config_id VARCHAR(255) NOT NULL,
  user_id VARCHAR(255) NOT NULL,
  scope VARCHAR(255) NOT NULL,
  issue_time INTEGER NOT NULL,
  access_token VARCHAR(255) NOT NULL,
  token_type VARCHAR(255) NOT NULL,
  expires_in INTEGER DEFAULT NULL,
  CONSTRAINT calendar_oauth_access_tokens_unique_key UNIQUE (provider, client_config_id, user_id, scope)
);

CREATE TABLE calendar_oauth_refresh_tokens (
  provider VARCHAR(255) NOT NULL,
  client_config_id VARCHAR(255) NOT NULL,
  user_id VARCHAR(255) NOT NULL,
  scope VARCHAR(255) NOT NULL,
  issue_time INTEGER NOT NULL,
  refresh_token VARCHAR(255) DEFAULT NULL,
  CONSTRAINT calendar_oauth_refresh_tokens_unique_key UNIQUE (provider, client_config_id, user_id, scope)
);

INSERT INTO "system" (name, value) VALUES ('calendar-version', '2016011300');
