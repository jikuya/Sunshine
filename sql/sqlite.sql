CREATE TABLE IF NOT EXISTS sessions (
    id           CHAR(72) PRIMARY KEY,
    session_data TEXT
);
CREATE TABLE IF NOT EXISTS users (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    nickname     CHAR(72), 
    email        CHAR(255),
    passwd       CHAR(255)
);
CREATE TABLE IF NOT EXISTS category_mst (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    name         CHAR(72)
);
INSERT OR IGNORE INTO category_mst ('id','name') VALUES
    (1, '肩こり'),
    (2, '頭痛'),
    (3, '腰痛'),
    (4, '眼精疲労');
CREATE TABLE IF NOT EXISTS publishes (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    category_id  INTEGER,
    type         INTEGER,
    title        CHAR(72),
    body         CHAR(255),
    author       INTEGER,
    link         TEXT
);
CREATE TABLE IF NOT EXISTS contents_type (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    name         CHAR(72)
);
INSERT OR IGNORE INTO contents_type ('id','name') VALUES
    (1, 'リンク'),
    (2, '動画'),
    (3, 'オリジナル'),
    (4, '有料');
