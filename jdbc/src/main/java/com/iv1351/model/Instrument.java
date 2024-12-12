package com.iv1351.model;

public class Instrument {
    private int id;
    private String type;
    private String brand;
    private float price;

    public Instrument() {
    }

    public Instrument(int id, String type, String brand, float price) {
        this.id = id;
        this.type = type;
        this.brand = brand;
        this.price = price;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

}

