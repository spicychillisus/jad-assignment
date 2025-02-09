package discount;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import pg.Config;

public class DiscountOwner {
	
	private int id;
	private int discountId;
	private int usageAllowed;
	private int userid;
    private String discountCode; // ✅ Add this field
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getDiscountId() {
		return discountId;
	}
	public void setDiscountId(int discountId) {
		this.discountId = discountId;
	}
	public int getUsageAllowed() {
		return usageAllowed;
	}
	public void setUsageAllowed(int usageAllowed) {
		this.usageAllowed = usageAllowed;
	}
	public int getUserid() {
		return userid;
	}
	public void setUserid(int userid) {
		this.userid = userid;
	}
	public String getDiscountCode() {  // ✅ Add getter for discountCode
        return discountCode;
    }
    public void setDiscountCode(String discountCode) {  // ✅ Add setter for discountCode
        this.discountCode = discountCode;
    }
	
	public String getDiscountCodeById(int discountid) throws SQLException {
		String discountCode = "";
		String sql = "";
		Config config = new Config();
		String url = config.getConnectionUrl();
		String username = config.getUser();
		String dbPassword = config.getPassword();
		Connection conn = DriverManager.getConnection(url, username, dbPassword);
		try {
			sql = "SELECT code FROM discounts WHERE id = ?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, discountid);
			ResultSet rs = ps.executeQuery();
			
			
			if (rs.next()) {
				discountCode = rs.getString("code");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return discountCode;
	}
	
	
}
