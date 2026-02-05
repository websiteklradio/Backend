CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(20) CHECK (
    role IN ('station_head', 'creative', 'rj', 'technical')
  ) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE scripts (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  is_live BOOLEAN DEFAULT FALSE,
  created_by INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_scripts_user
    FOREIGN KEY (created_by)
    REFERENCES users(id)
    ON DELETE CASCADE
);
CREATE TABLE announcements (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  created_by INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_announcements_user
    FOREIGN KEY (created_by)
    REFERENCES users(id)
    ON DELETE CASCADE
);
CREATE TABLE podcast_scripts (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  topic VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  assigned_to INTEGER,
  status VARCHAR(20) DEFAULT 'pending'
    CHECK (status IN ('pending', 'completed')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_podcast_user
    FOREIGN KEY (assigned_to)
    REFERENCES users(id)
    ON DELETE SET NULL
);
CREATE TABLE news (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  source VARCHAR(255),
  assigned_to INTEGER,
  saved BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_news_user
    FOREIGN KEY (assigned_to)
    REFERENCES users(id)
    ON DELETE SET NULL
);
CREATE TABLE song_suggestions (
  id SERIAL PRIMARY KEY,
  listener_name VARCHAR(255) NOT NULL,
  song_title VARCHAR(255) NOT NULL,
  movie VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER update_users_time
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_scripts_time
BEFORE UPDATE ON scripts
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_announcements_time
BEFORE UPDATE ON announcements
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_podcast_time
BEFORE UPDATE ON podcast_scripts
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_news_time
BEFORE UPDATE ON news
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_songs_time
BEFORE UPDATE ON song_suggestions
FOR EACH ROW EXECUTE FUNCTION update_timestamp();
