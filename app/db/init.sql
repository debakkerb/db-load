CREATE TABLE IF  NOT EXISTS blogposts
(
    id      INTEGER      NOT NULL PRIMARY KEY AUTO_INCREMENT,
    title   VARCHAR(100) NOT NULL,
    intro   TEXT         NOT NULL,
    content TEXT         NOT NULL,
    created DATETIME     NOT NULL
);