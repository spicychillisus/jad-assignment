package services;

public class Service {
    // Private fields
    private int id;
    private String servicetitle;
    private String servicedescription;
    private double price;

    // Constructor
    public Service(int id, String servicetitle, String servicedescription, double price) {
        this.id = id;
        this.servicetitle = servicetitle;
        this.servicedescription = servicedescription;
        this.price = price;
    }

    // Getter for id
    public int getId() {
        return id;
    }

    // Setter for id
    public void setId(int id) {
        this.id = id;
    }

    // Getter for servicetitle
    public String getServicetitle() {
        return servicetitle;
    }

    // Setter for servicetitle
    public void setServicetitle(String servicetitle) {
        this.servicetitle = servicetitle;
    }

    // Getter for servicedescription
    public String getServicedescription() {
        return servicedescription;
    }

    // Setter for servicedescription
    public void setServicedescription(String servicedescription) {
        this.servicedescription = servicedescription;
    }

    // Getter for price
    public double getPrice() {
        return price;
    }

    // Setter for price
    public void setPrice(double price) {
        this.price = price;
    }
}
