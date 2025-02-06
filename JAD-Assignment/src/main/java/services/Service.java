package services;

public class Service {
	private int serviceid;
	private String servicetitle;
	private String servicedescription;
	private double price;
	private String category;
	private Double rating;
	private int demand;
	
	
	public Service(int serviceid, String servicetitle, String servicedescription, double price, String category,
			Double rating, int demand) {
		//super();
		this.serviceid = serviceid;
		this.servicetitle = servicetitle;
		this.servicedescription = servicedescription;
		this.price = price;
		this.category = category;
		this.rating = rating;
		this.demand = demand;
	}
	
	
	public Service() {
		//super();
	}


	public int getServiceid() {
		return serviceid;
	}
	public void setServiceid(int serviceid) {
		this.serviceid = serviceid;
	}
	public String getServicetitle() {
		return servicetitle;
	}
	public void setServicetitle(String servicetitle) {
		this.servicetitle = servicetitle;
	}
	public String getServicedescription() {
		return servicedescription;
	}
	public void setServicedescription(String servicedescription) {
		this.servicedescription = servicedescription;
	}
	public double getPrice() {
		return price;
	}
	public void setPrice(double price) {
		this.price = price;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public Double getRating() {
		return rating;
	}
	public void setRating(Double rating) {
		this.rating = rating;
	}
	public int getDemand() {
		return demand;
	}
	public void setDemand(int demand) {
		this.demand = demand;
	}
	
	
}
