// parent class for all the cleaning service categories
package services;


public class CleaningService {
	
	private String name;
	private String description;
	private Double price;
	private Double maxPrice;
	private String imageUrl;
	
	// when there is a definite price range
	public CleaningService(String name, String description, Double price, Double maxPrice, String imageUrl) {
		this.name = name;
		this.description = description;
		this.price = price;
		this.maxPrice = maxPrice;
		this.imageUrl = imageUrl;
	}
	
	// when there is only a starting price and no max price that can be charged
	public CleaningService(String name, String description, Double price, String imageUrl) {
		this.name = name;
		this.description = description;
		this.price = price;
		this.imageUrl = imageUrl;
	}
	
	public CleaningService() {
		// empty constructor
	}
	
	public String displayServiceName() {
		return this.name;
	}
	
	public String displayServiceCover() {
		return this.imageUrl;
	}
	
	public String displayCleaningServicePrices() {
		String displayPrice = "";
		
		if (this.maxPrice == 0 || this.maxPrice == null) {
			displayPrice = String.format("From %d", this.price);
		}
		
		// only displays when there is no max price for the service
		displayPrice = String.format("From $%d to $%d", this.price, this.maxPrice);
		
		return displayPrice;
	}
	
	public String displayDescription() {
		return this.description;
	}
	
}
