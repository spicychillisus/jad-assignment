// contains member data
package services;


public class Member {
	
	private String name;
	private Integer countryCode;
	private Integer phoneNum;
	private String email;
	private String passwordHash; // cannot save as a text, i will find the inbuilt package for it later
	
	public Member(String name, Integer countryCode, Integer phoneNum, String email, String passwordHash) {
		this.name = name;
		this.countryCode = countryCode;
		this.phoneNum = phoneNum;
		this.email = email;
		this.passwordHash = passwordHash;
	}
	
	public Member() {
		// empty
	}
	
	
	
	
}
