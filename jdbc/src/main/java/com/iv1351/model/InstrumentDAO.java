package com.iv1351.model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InstrumentDAO {
    private Connection connection;
    private PreparedStatement listAvailableInstrumentsStmt;
    private PreparedStatement doesStudentExistStmt;
    private PreparedStatement doesInstrumentExistStmt;
    private PreparedStatement countStudentRentalsStmt;
    private PreparedStatement getMaxInstrumentsPerStudentStmt;
    private PreparedStatement isInstrumentRentedStmt;
    private PreparedStatement createRentalStmt;
    private PreparedStatement terminateRentalStmt;
    private PreparedStatement doesRentalExistStmt;
    private PreparedStatement isRentalCanceledStmt;
    private PreparedStatement lockInstrumentForUpdateStmt;
    private PreparedStatement lockRentalForUpdateStmt;
    private PreparedStatement markInstrumentAsRentedStmt;
    private PreparedStatement getInstrumentIdByRentalIdStmt; 
    private PreparedStatement markInstrumentAsAvailableStmt;
    private PreparedStatement isStoreNumberAvailableStmt;

    public InstrumentDAO(Connection connection) {
        this.connection = connection;
    }

    public void prepareStatements() throws SQLException {
        listAvailableInstrumentsStmt = connection.prepareStatement("SELECT * FROM \"Instrument\" WHERE LOWER(instrument_type) = LOWER(?) AND instrument_id NOT IN (SELECT instrument_id FROM \"Instrument_rental\" WHERE rental_status = TRUE)");
        doesStudentExistStmt = connection.prepareStatement("SELECT COUNT(*) FROM \"Student\" WHERE student_id = ?");
        doesInstrumentExistStmt = connection.prepareStatement("SELECT COUNT(*) FROM \"Instrument\" WHERE instrument_id = ?");
        countStudentRentalsStmt = connection.prepareStatement("SELECT COUNT(*) FROM \"Instrument_rental\" WHERE student_id = ? AND rental_status = TRUE");
        getMaxInstrumentsPerStudentStmt = connection.prepareStatement("SELECT config_value FROM config WHERE config_key = 'max_instruments_per_student'");
        isInstrumentRentedStmt = connection.prepareStatement("SELECT COUNT(*) FROM \"Instrument_rental\" WHERE instrument_id = ? AND rental_status = TRUE");
        createRentalStmt = connection.prepareStatement("INSERT INTO \"Instrument_rental\" (student_id, instrument_id, start_date, rental_status) VALUES (?, ?, CURRENT_DATE, TRUE)");
        terminateRentalStmt = connection.prepareStatement("UPDATE \"Instrument_rental\" SET rental_status = FALSE, end_date = CURRENT_DATE WHERE rental_id = ?");
        doesRentalExistStmt = connection.prepareStatement("SELECT COUNT(*) FROM \"Instrument_rental\" WHERE rental_id = ?");
        isRentalCanceledStmt = connection.prepareStatement("SELECT rental_status FROM \"Instrument_rental\" WHERE rental_id = ?");
        lockInstrumentForUpdateStmt = connection.prepareStatement("SELECT * FROM \"Instrument\" WHERE instrument_id = ? FOR UPDATE");
        lockRentalForUpdateStmt = connection.prepareStatement("SELECT * FROM \"Instrument_rental\" WHERE rental_id = ? FOR UPDATE");
        markInstrumentAsRentedStmt = connection.prepareStatement("UPDATE \"Instrument\" SET store_number = NULL WHERE instrument_id = ?");
        getInstrumentIdByRentalIdStmt = connection.prepareStatement("SELECT instrument_id FROM \"Instrument_rental\" WHERE rental_id = ?"); 
        markInstrumentAsAvailableStmt = connection.prepareStatement("UPDATE \"Instrument\" SET store_number = ? WHERE instrument_id = ?"); 
        isStoreNumberAvailableStmt = connection.prepareStatement("SELECT COUNT(*) FROM \"Instrument\" WHERE store_number = ?");
    }

    // ------- 1. List instruments ------- //
    public List<Instrument> listAvailableInstruments(String type) throws SQLException {
        List<Instrument> instruments = new ArrayList<>();
        listAvailableInstrumentsStmt.setString(1, type);
        try (ResultSet rs = listAvailableInstrumentsStmt.executeQuery()) {
            while (rs.next()) {
                Instrument instrument = new Instrument();
                instrument.setId(rs.getInt("instrument_id"));
                instrument.setType(rs.getString("instrument_type"));
                instrument.setBrand(rs.getString("brand"));
                instrument.setPrice(rs.getFloat("price_per_month"));
                instruments.add(instrument);
            }
        }
        return instruments;
    }

    // ------- 2. Rent instrument ------- //
    public boolean doesStudentExist(int studentId) throws SQLException {
        doesStudentExistStmt.setInt(1, studentId);
        try (ResultSet rs = doesStudentExistStmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }

    public boolean doesInstrumentExist(int instrumentId) throws SQLException {
        doesInstrumentExistStmt.setInt(1, instrumentId);
        try (ResultSet rs = doesInstrumentExistStmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }

    public int countStudentRentals(int studentId) throws SQLException {
        countStudentRentalsStmt.setInt(1, studentId);
        try (ResultSet rs = countStudentRentalsStmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        }
    }

    public int getMaxInstrumentsPerStudent() throws SQLException, RentalException {
        try (ResultSet rs = getMaxInstrumentsPerStudentStmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("config_value");
            } else {
                throw new RentalException("\n!! Configuration for 'max_instruments_per_student' not found.");
            }
        }
    }

    public boolean isInstrumentRented(int instrumentId) throws SQLException {
        isInstrumentRentedStmt.setInt(1, instrumentId);
        try (ResultSet rs = isInstrumentRentedStmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }

    public void createRental(int studentId, int instrumentId) throws SQLException {
        createRentalStmt.setInt(1, studentId);
        createRentalStmt.setInt(2, instrumentId);
        createRentalStmt.executeUpdate();
    }

    public void lockInstrumentForUpdate(int instrumentId) throws SQLException {
        lockInstrumentForUpdateStmt.setInt(1, instrumentId);
        lockInstrumentForUpdateStmt.executeQuery();
    }

    public void markInstrumentAsRented(int instrumentId) throws SQLException { 
        markInstrumentAsRentedStmt.setInt(1, instrumentId); 
        markInstrumentAsRentedStmt.executeUpdate(); 
    }

    // ------- 3. Terminate rental ------- //
    public boolean terminateRental(int rentalId) throws SQLException {
        terminateRentalStmt.setInt(1, rentalId);
        int affectedRows = terminateRentalStmt.executeUpdate();
        return affectedRows > 0;
    }

    public void lockRentalForUpdate(int rentalId) throws SQLException {
        lockRentalForUpdateStmt.setInt(1, rentalId);
        lockRentalForUpdateStmt.executeQuery();
    }

    public boolean doesRentalExist(int rentalId) throws SQLException {
        doesRentalExistStmt.setInt(1, rentalId);
        try (ResultSet rs = doesRentalExistStmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }

    public boolean isRentalCanceled(int rentalId) throws SQLException {
        isRentalCanceledStmt.setInt(1, rentalId);
        try (ResultSet rs = isRentalCanceledStmt.executeQuery()) {
            if (rs.next()) {
                return !rs.getBoolean("rental_status");
            }
            return false;
        }
    }

    public int getInstrumentIdByRentalId(int rentalId) throws SQLException { 
        getInstrumentIdByRentalIdStmt.setInt(1, rentalId); 
        try (ResultSet rs = getInstrumentIdByRentalIdStmt.executeQuery()) { 
            if (rs.next()) { 
                return rs.getInt("instrument_id"); 
            } else {
                throw new SQLException("\n!! Instrument ID not found for Rental ID: " + rentalId); 
            }
        } 
    } 

    public void markInstrumentAsAvailable(int instrumentId, int storeNumber) throws SQLException {
        markInstrumentAsAvailableStmt.setInt(1, storeNumber); 
        markInstrumentAsAvailableStmt.setInt(2, instrumentId); 
        markInstrumentAsAvailableStmt.executeUpdate();
    }
    
    public boolean isStoreNumberAvailable(int storeNumber) throws SQLException { 
        isStoreNumberAvailableStmt.setInt(1, storeNumber); 
        try (ResultSet rs = isStoreNumberAvailableStmt.executeQuery()) { 
            if (rs.next()) { 
                return rs.getInt(1) == 0; 
            } 
            return false; 
        } 
    }
}
