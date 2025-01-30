package pg;

public class Config {
    private String user = "neondb_owner";
    private String password = "DMJ4bZf3lFox";
    private String connectionUrl = "jdbc:postgresql://ep-floral-star-a1tkg3qp.ap-southeast-1.aws.neon.tech/neondb?sslmode=require";

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
