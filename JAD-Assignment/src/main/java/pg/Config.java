package pg;

public class Config {
	private String user = "neondb_owner";
	private String password = "5Dgya7KkJQor";
	private String connectionUrl = "jdbc:postgresql://ep-yellow-sunset-a5h4poax.us-east-2.aws.neon.tech:5432/neondb";
	
	public String getUser() {
		return user;
	}
	public String getPassword() {
		return password;
	}
	public String getConnectionUrl() {
		return connectionUrl;
	}
	
	
}
