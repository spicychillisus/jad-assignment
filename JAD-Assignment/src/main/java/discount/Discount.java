package discount;

import java.sql.Timestamp;
import com.fasterxml.jackson.annotation.JsonFormat;  

// bean :D
public class Discount {
	
	private int id;
	private String code;
	private double discountValue;
	private String description;
	
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")  
	private Timestamp startDate;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")  
	private Timestamp endDate;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")  
	private Timestamp createdAt;
	
	public Discount(int id, String code, double discountValue, String description, Timestamp startDate, Timestamp endDate, Timestamp createdAt) {
		this.id = id;
		this.code = code;
		this.discountValue = discountValue;
		this.description = description;
		this.startDate = startDate;
		this.endDate = endDate;
		this.createdAt = createdAt;
	}
	
	public Discount() {
		// empty constructor
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public double getDiscountValue() {
		return discountValue;
	}
	public void setDiscountValue(double discountValue) {
		this.discountValue = discountValue;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")  
	public Timestamp getStartDate() {
		return startDate;
	}
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")  
	public void setStartDate(Timestamp startDate) {
		this.startDate = startDate;
	}
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")  
	public Timestamp getEndDate() {
		return endDate;
	}
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")  
	public void setEndDate(Timestamp endDate) {
		this.endDate = endDate;
	}
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")  
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")  
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	
	
	

	
	
}
