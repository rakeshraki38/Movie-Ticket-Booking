package model;

public class Seat {
    private int seatID;
    private int seatNumber;
    private String seatType;
    private boolean isAvailable;
    private double fare;

    // Constructor
    public Seat(int seatID, int seatNumber, String seatType, boolean isAvailable, double fare) {
        this.seatID = seatID;
        this.seatNumber = seatNumber;
        this.seatType = seatType;
        this.isAvailable = isAvailable;
        this.fare = fare;
    }

    // Getters and Setters
    public int getSeatID() { return seatID; }
    public void setSeatID(int seatID) { this.seatID = seatID; }
    public int getSeatNumber() { return seatNumber; }
    public void setSeatNumber(int seatNumber) { this.seatNumber = seatNumber; }
    public String getSeatType() { return seatType; }
    public void setSeatType(String seatType) { this.seatType = seatType; }
    public boolean isAvailable() { return isAvailable; }
    public void setAvailable(boolean available) { isAvailable = available; }
    public double getFare() { return fare; }
    public void setFare(double fare) { this.fare = fare; }
}
