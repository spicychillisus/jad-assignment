// contains member data
package members;


public class Member {
	
	private String name;
	private Integer countryCode;
	private Integer phoneNum;
	private String email;
	private String passwordHash; // cannot save as a text, i will find the inbuilt package for it later
	private String date;
	
	public Member(String name, Integer countryCode, Integer phoneNum, String email, String passwordHash, String date) {
		this.name = name;
		this.countryCode = countryCode;
		this.phoneNum = phoneNum;
		this.email = email;
		this.passwordHash = passwordHash;
	}
	
	public Member() {
		// empty
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getCountryCode() {
		return countryCode;
	}

	public void setCountryCode(Integer countryCode) {
		this.countryCode = countryCode;
	}

	public Integer getPhoneNum() {
		return phoneNum;
	}

	public void setPhoneNum(Integer phoneNum) {
		this.phoneNum = phoneNum;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}


	
	
	
	
}
