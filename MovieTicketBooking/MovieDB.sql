CREATE DATABASE MovieDB;

USE MovieDB;

CREATE TABLE Managers (
    ManagerID INT AUTO_INCREMENT PRIMARY KEY,
    ManagerName VARCHAR(255) NOT NULL, 
    PASSWORD VARCHAR(255) NOT NULL, 
    Email VARCHAR(255) NOT NULL, 
    PhoneNumber VARCHAR(20), 
    UNIQUE (Email)
);
SELECT * FROM managers


CREATE TABLE Theaters (
    TheaterID INT AUTO_INCREMENT PRIMARY KEY,
    TheaterName VARCHAR(255) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    totalScreens INT NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DESC Theaters
SELECT * FROM theaters
ALTER TABLE Theaters ADD manager_email VARCHAR(100) NOT NULL;
ALTER TABLE Theaters ADD shows VARCHAR(100) NOT NULL;


CREATE TABLE Movies (
    MovieID INT AUTO_INCREMENT PRIMARY KEY,
    MovieTitle VARCHAR(255) NOT NULL,
    Genre VARCHAR(100),
    Duration INT NOT NULL,           -- Duration in minutes
    ImageSrc VARCHAR(255) NOT NULL,
    LANGUAGE VARCHAR(100),
    Director VARCHAR(250),
    Description TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM movies
DESC movies
ALTER TABLE Movies ADD manager_email VARCHAR(100) NOT NULL;
ALTER TABLE Movies ADD TheaterName VARCHAR(100) NOT NULL ;
ALTER TABLE movies ADD location VARCHAR(100) NOT NULL;
SELECT * FROM theaters


CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Phone VARCHAR(10) NOT NULL
);
SELECT * FROM Users

CREATE TABLE Screens (
    ScreenID INT AUTO_INCREMENT PRIMARY KEY,
    TheaterID INT NOT NULL,
    ScreenName VARCHAR(100) NOT NULL,
    SeatCapacity INT NOT NULL,
    
    FOREIGN KEY (TheaterID) REFERENCES Theaters(TheaterID)
);

ALTER TABLE Screens DROP FOREIGN KEY screens_ibfk_1;

ALTER TABLE Screens
ADD CONSTRAINT fk_theater_id FOREIGN KEY (TheaterID) REFERENCES Theaters(TheaterID)
ON DELETE CASCADE ON UPDATE CASCADE;


DROP TABLE Screens
SELECT CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME = 'Screens' AND COLUMN_NAME = 'TheaterID';

CONSTRAINT_NAME= screens_ibfk_1
SELECT * FROM Screens 


CREATE TABLE Shows (
    ShowID INT AUTO_INCREMENT PRIMARY KEY,
    ScreenID INT NOT NULL,
    MovieID INT NOT NULL,
    TheaterID INT NOT NULL,
    
    ScreenName VARCHAR(100),
    ShowTime VARCHAR NOT NULL,
    
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    FOREIGN KEY (ScreenID) REFERENCES Screens(ScreenID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (TheaterID) REFERENCES Theaters(TheaterID)ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)ON DELETE CASCADE ON UPDATE CASCADE
);

SELECT * FROM shows
-- Seats table
CREATE TABLE Seats (
    SeatID INT AUTO_INCREMENT PRIMARY KEY,
    ScreenID INT NOT NULL,
    SeatNumber INT NOT NULL,
    SeatType VARCHAR(60) NOT NULL, -- e.g., 'Royal', 'Executive'
    IsAvailable BOOLEAN DEFAULT TRUE,
    Fare DECIMAL(10, 2) NOT NULL, -- Store the fare for the seat
    
    FOREIGN KEY (ScreenID) REFERENCES Screens(ScreenID)
);	

CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    
    UserID INT NOT NULL,
    ScreenID INT NOT NULL,
    TheaterID INT NOT NULL,
    MovieID INT NOT NULL,
    ShowID INT NOT NULL,
    
    ScreenName VARCHAR(100) NOT NULL,
    ShowTime VARCHAR(100) NOT NULL,
    BookedDate VARCHAR(100) NOT NULL,
    SeatNumbers VARCHAR(500), -- Comma-separated seat numbers 
    
    BookingDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ScreenID) REFERENCES Screens(ScreenID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (TheaterID) REFERENCES Theaters(TheaterID)ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ShowID) REFERENCES Shows(ShowID)ON DELETE CASCADE ON UPDATE CASCADE
);

SELECT * FROM Bookings

stmt = conn.createStatement();
                    stmt.execute("SET @new_id = 0");
                    stmt.execute("UPDATE Movies SET MovieID = (@new_id := @new_id + 1)");


SELECT 
    m.MovieTitle, 
    m.Description, 
    m.Genre, 
    t.TheaterName, 
    t.Location, 
    b.ScreenName, 
    b.Showtime, 
    b.BookedDate, 
    b.SeatNumbers,
    u.Username,       -- Add Username from Users table
    u.Phone           -- Add Phone from Users table
FROM 
    movies m
JOIN 
    theaters t ON m.TheaterName= t.TheaterName  -- Assuming theaters table exists and relates to movies
JOIN 
    bookings b ON b.MovieID = m.MovieID
JOIN
    users u ON b.UserID = u.UserID           -- Join Users table to fetch Username and Phone
WHERE 
    b.UserID = (SELECT UserID FROM Users WHERE Email = ?)  -- Get UserID from email
    AND b.BookedDate >= CURDATE()  -- Ensure BookedDate is today or in the future
    AND (
        b.BookedDate > CURDATE()  -- If the booked date is in the future, don't check the time
        OR b.Showtime > NOW()      -- If the booked date is today, check if the showtime is in the future
    );

