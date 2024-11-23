// parent class for all the cleaning service categories
package services;


public class CleaningService {
	
	private String name;
	private String description;
	private Double price;
	private Double maxPrice;
	
	// when there is only a starting price and no max price that can be charged
	public CleaningService(String name, String description, Double price) {
		this.name = name;
		this.description = description;
		this.price = price;
	}
	
	public CleaningService() {
		// empty constructor
	}
	
	public String displayServiceName() {
		return this.name;
	}
	
	public String displayCleaningServicePrices() {
		String displayPrice = "";
		
		// only displays when there is no max price for the service
		displayPrice = String.format("From $%d to $%d", this.price, this.maxPrice);
		
		return displayPrice;
	}
	
	public String displayDescription() {
		return this.description;
	}
	

	
}
