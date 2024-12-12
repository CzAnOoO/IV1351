package com.iv1351.controller;

import com.iv1351.model.Instrument;
import com.iv1351.model.InstrumentDAO;
import com.iv1351.model.RentalException;

import java.sql.*;
import java.util.List;

public class Controller {
    private InstrumentDAO instrumentDAO;

    // Connect database
    public Controller() throws SQLException {
        Connection connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/soundgood", "postgres",
                "postgres");
        this.instrumentDAO = new InstrumentDAO(connection);
    }

    // 1. List instruments
    public List<Instrument> listAvailableInstruments(String type) throws SQLException {
        return instrumentDAO.listAvailableInstruments(type);
    }

    // 2. Rent instrument
    public boolean rentInstrument(int studentId, int instrumentId) throws SQLException, RentalException {
        if (!instrumentDAO.doesStudentExist(studentId)) {
            /*
             * System.out.println("\n!!Student ID not found.");
             * return false;
             */
            throw new RentalException("\n!! Student ID not found.");
        }
        if (!instrumentDAO.doesInstrumentExist(instrumentId)) {
            /*
             * System.out.println("\n!!Instrument ID not found.");
             * return false;
             */
            throw new RentalException("\n!! Instrument ID not found.");
        }

        int maxInstruments = instrumentDAO.getMaxInstrumentsPerStudent();
        int currentRentals = instrumentDAO.countStudentRentals(studentId);
        if (currentRentals >= maxInstruments) {
            /*
             * System.out.println("\n!!A student can only rent a maximum of " +
             * maxInstruments + " instruments at the same time.");
             * return false;
             */
            throw new RentalException(
                    "\n !!A student can only rent a maximum of " + maxInstruments + " instruments at the same time.");
        }
        boolean isRented = instrumentDAO.isInstrumentRented(instrumentId);
        if (isRented) {
            /*
             * System.out.println("\n!!The instrument is already rented.");
             * return false;
             */
            throw new RentalException("\n!! The instrument is already rented.");
        }
        instrumentDAO.createRental(studentId, instrumentId);
        return true;
    }

    // 3. Terminate rental
    public boolean terminateRental(int rentalId) throws SQLException, RentalException {
        if (!instrumentDAO.doesRentalExist(rentalId)) {
            throw new RentalException("\n!! Rental ID not found.");
        }
        if (instrumentDAO.isRentalCanceled(rentalId)) {
            throw new RentalException("\n!! The rental is already canceled.");
        }
        return instrumentDAO.terminateRental(rentalId);
    }
}
