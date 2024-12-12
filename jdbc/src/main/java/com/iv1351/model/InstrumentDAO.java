package com.iv1351.model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InstrumentDAO {
    private Connection connection;

    public InstrumentDAO(Connection connection) {
        this.connection = connection;
    }

    // ------- 1. List instruments ------- //
    public List<Instrument> listAvailableInstruments(String type) throws SQLException {
        String query = "SELECT * FROM \"Instrument\" WHERE LOWER(instrument_type) = LOWER(?) AND instrument_id NOT IN (SELECT instrument_id FROM \"Instrument_rental\" WHERE rental_status = TRUE)";
        List<Instrument> instruments = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, type);
            ResultSet rs = stmt.executeQuery();
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
        String query = "SELECT COUNT(*) FROM \"Student\" WHERE student_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }

    public boolean doesInstrumentExist(int instrumentId) throws SQLException {
        String query = "SELECT COUNT(*) FROM \"Instrument\" WHERE instrument_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, instrumentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }

    public int countStudentRentals(int studentId) throws SQLException {
        String query = "SELECT COUNT(*) FROM \"Instrument_rental\" WHERE student_id = ? AND rental_status = TRUE";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        }
    }

    public int getMaxInstrumentsPerStudent() throws SQLException, RentalException {
        String query = "SELECT config_value FROM config WHERE config_key = 'max_instruments_per_student'";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("config_value");
            } else {
                throw new RentalException("\n!! Configuration for 'max_instruments_per_student' not found.");
            }
        }
    }

    public boolean isInstrumentRented(int instrumentId) throws SQLException {
        String query = "SELECT COUNT(*) FROM \"Instrument_rental\" WHERE instrument_id = ? AND rental_status = TRUE";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, instrumentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }

    public void createRental(int studentId, int instrumentId) throws SQLException {
        String query = "INSERT INTO \"Instrument_rental\" (student_id, instrument_id, start_date, rental_status) VALUES (?, ?, CURRENT_DATE, TRUE)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, instrumentId);
            stmt.executeUpdate();
        }
    }

    // 3. Terminate rental
    public boolean terminateRental(int rentalId) throws SQLException {
        String query = "UPDATE \"Instrument_rental\" SET rental_status = FALSE, end_date = CURRENT_DATE WHERE rental_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, rentalId);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    public boolean doesRentalExist(int rentalId) throws SQLException {
        String query = "SELECT COUNT(*) FROM \"Instrument_rental\" WHERE rental_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, rentalId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }

    public boolean isRentalCanceled(int rentalId) throws SQLException {
        String query = "SELECT rental_status FROM \"Instrument_rental\" WHERE rental_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, rentalId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return !rs.getBoolean("rental_status");
            }
            return false;
        }
    }
}
