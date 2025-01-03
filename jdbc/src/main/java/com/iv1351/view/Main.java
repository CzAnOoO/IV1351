package com.iv1351.view;

import com.iv1351.controller.Controller;
import com.iv1351.model.Instrument;
import com.iv1351.model.RentalException;

import java.sql.*;
import java.util.List;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        try {
            Controller controller = new Controller();

            while (true) {
                System.out.println("_________________________________");
                System.out.println();
                System.out.println("1. List instruments");
                System.out.println("2. Rent instrument");
                System.out.println("3. Terminate rental");
                System.out.println("4. Exit");
                System.out.print("\nChoose an option: ");
                int choice = scanner.nextInt();

                switch (choice) {
                    case 1:
                        System.out.println("_________________________________");
                        System.out.print("\nEnter instrument type: ");
                        String type = scanner.next();
                        List<Instrument> instruments = controller.listAvailableInstruments(type);
                        System.out.println();
                        if (instruments.isEmpty()) {
                            System.out.println("Could not find any \"" + type
                                    + "\" available for rent. Please check for any spelling errors.");
                        }
                        for (Instrument instrument : instruments) {
                            System.out.println("ID: " + instrument.getId() + ", Brand: " + instrument.getBrand()
                                    + ", Price: " + instrument.getPrice());
                        }
                        break;
                    case 2:
                        System.out.println("_________________________________");
                        System.out.print("\nEnter student ID: ");
                        int studentId = scanner.nextInt();
                        System.out.print("\nEnter instrument ID: ");
                        int instrumentId = scanner.nextInt();
                        try {
                            controller.rentInstrument(studentId, instrumentId);
                            System.out.println("\nInstrument rented successfully.");
                        } catch (RentalException e) {
                            System.out.println(e.getMessage());
                        }
                        break;
                    case 3:
                        System.out.println("_________________________________");
                        System.out.print("\nEnter rental ID: ");
                        int rentalId = scanner.nextInt();
                        System.out.print("\nEnter store number for returned instrument: "); 
                        int storeNumber = scanner.nextInt();
                        try {
                            controller.terminateRental(rentalId, storeNumber);
                            System.out.println("\nRental terminated successfully.");
                        } catch (RentalException e) {
                            System.out.println(e.getMessage());
                        }
                        break;
                    case 4:
                        System.out.println("_________________________________");
                        System.out.println("\nGoodbye!\n");
                        return;
                    default:
                        System.out.println("\nInvalid choice. Please try again.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        scanner.close();
    }
}