package com.iv1351.controller;

import com.iv1351.model.Instrument;
import com.iv1351.model.InstrumentDAO;
import com.iv1351.model.RentalException;

import java.sql.*;
import java.util.List;

public class Controller {
    private InstrumentDAO instrumentDAO;
    private Connection connection;

    // Connect database
    public Controller() throws SQLException {
        this.connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/soundgood", "postgres",
                "postgres");
        this.instrumentDAO = new InstrumentDAO(connection);
        // Prepare all statements 
        instrumentDAO.prepareStatements();
    }

    // 1. List instruments
    public List<Instrument> listAvailableInstruments(String type) throws SQLException { 
        try { 
            connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED); 
            connection.setAutoCommit(false); 
            List<Instrument> instruments = instrumentDAO.listAvailableInstruments(type); 
            connection.commit(); 
            return instruments; 
        } catch (SQLException e) {
            connection.rollback(); 
            throw e; 
        } finally { 
            connection.setAutoCommit(true); 
        } 
    }

    // 2. Rent instrument
    public boolean rentInstrument(int studentId, int instrumentId) throws SQLException, RentalException {
        try {
            connection.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);
            connection.setAutoCommit(false);

            // Lock 
            instrumentDAO.lockInstrumentForUpdate(instrumentId);

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
                throw new RentalException("\n !!A student can only rent a maximum of " + maxInstruments + " instruments at the same time.");
            }
            boolean isRented = instrumentDAO.isInstrumentRented(instrumentId);
            if (isRented) {
                /*
                * System.out.println("\n!!The instrument is already rented.");
                * return false;
                */
                throw new RentalException("\n!! The instrument is already rented.");
            }
            // Update store_number to NULL to indicate the instrument is rented 
            instrumentDAO.markInstrumentAsRented(instrumentId);
            // Create rental record
            instrumentDAO.createRental(studentId, instrumentId);

            connection.commit();
            return true;
        } catch (SQLException | RentalException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    // 3. Terminate rental
    public boolean terminateRental(int rentalId, int storeNumber) throws SQLException, RentalException {
        try {
            connection.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);
            connection.setAutoCommit(false);

            // Lock 
            instrumentDAO.lockRentalForUpdate(rentalId);

            if (!instrumentDAO.doesRentalExist(rentalId)) {
                throw new RentalException("\n!! Rental ID not found.");
            }
            if (instrumentDAO.isRentalCanceled(rentalId)) {
                throw new RentalException("\n!! The rental is already canceled.");
            }
            // Check if store number is available 
            if (!instrumentDAO.isStoreNumberAvailable(storeNumber)) { 
                throw new RentalException("\n!! Store number is already in use."); 
            }
            // Get instrument ID for the rental int 
            int instrumentId = instrumentDAO.getInstrumentIdByRentalId(rentalId);

            boolean result = instrumentDAO.terminateRental(rentalId);

            // Update store_number to indicate the instrument is returned 
            instrumentDAO.markInstrumentAsAvailable(instrumentId, storeNumber);

            connection.commit();
            return result;
        } catch (SQLException | RentalException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }
}
