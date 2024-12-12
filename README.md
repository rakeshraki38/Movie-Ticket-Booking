# Movie Ticket Booking System

This project is a web-based Movie Ticket Booking System that allows users to browse movies, select showtimes, and book tickets. The application is built using **JSP**, **CSS**, and a **MySQL database** for managing user and movie information.

## Features

- **User Authentication**: Login functionality to personalize the experience.
- **Dynamic Movie Listing**: Displays movies based on database entries.
- **Showtime Management**: Showtimes dynamically update, disabling past times.
- **Date Selection**: Users can select dates for viewing showtimes.
- **Seat Booking**: Redirects to a seat selection page for booking tickets.

## Prerequisites

Before running the application, ensure you have the following installed:

- Java Development Kit (JDK) 8 or higher
- Apache Tomcat 9 or higher
- MySQL Server
- IDE like Eclipse or IntelliJ IDEA

## Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/your-username/MovieTicketBooking.git
```

### Step 2: Configure the Database

1. Create a MySQL database:
   ```sql
   CREATE DATABASE MovieBooking;
   ```
2. Import the database schema from the `db-schema.sql` file included in the repository.

3. Update the database connection settings in `DB_Connection.java`:
   ```java
   private static final String DB_URL =     
   "jdbc:mysql://localhost:3306/MovieBooking";
   private static final String DB_USER = "root";
   private static final String DB_PASSWORD = "yourpassword";
   ```

### Step 3: Deploy the Application

1. Copy the project files into the `webapps` folder of your Apache Tomcat server.
2. Start the Tomcat server.
3. Access the application at `http://localhost:8080/MovieTicketBooking`.

## Usage

1. Open the application in your browser.
2. Register or log in to your account.
3. Browse movies and select a desired movie.
4. Choose a date and showtime (past showtimes are disabled).
5. Book your seat and confirm your ticket.

## Contributing

Contributions are welcome! Please fork this repository and submit a pull request with your changes.
