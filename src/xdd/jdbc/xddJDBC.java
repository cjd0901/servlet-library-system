package xdd.jdbc;
import java.sql.*;
public class xddJDBC {
	private static String driverName;
	private static String url;
	private static String user;
	private static String pwd;
	static {
		config();
	}
	private static void config() {
		driverName = "com.mysql.cj.jdbc.Driver";
		url = "jdbc:mysql://localhost:3306/j2ee_library?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai";
		user = "root";
		pwd = "User@123";
	}
	// 获取连接
	public static Connection getConnection() {
		Connection conn = null;
		try {
			if(conn == null) {
				Class.forName(driverName);
				conn = DriverManager.getConnection(url,user,pwd);
			}
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return conn;
	}
	// 获取接口
	public static PreparedStatement getPst(Connection conn,String sql) {
		PreparedStatement pst = null;
		try {
			pst = conn.prepareStatement(sql);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return pst;
	}
	// 获取结果集
	public static ResultSet query(PreparedStatement pst, Object... params) {
		ResultSet rs = null;
		
		try {
			if(params.length>0) {
				for(int i=0;i<params.length;i++) {
					pst.setObject(i+1, params[i]);
				}
				rs = pst.executeQuery();
			}else {
				rs = pst.executeQuery();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rs;
	}
	
	public static int execute(PreparedStatement pst, Object... params) {
		int x = -1;
		try {
			if(params.length>0) {
				for(int i=0;i<params.length;i++) {
					pst.setObject(i+1, params[i]);
				}
				x = pst.executeUpdate();
			}else {
				x = pst.executeUpdate();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return x;
	}
	
	public static void close(Connection conn, PreparedStatement pst, ResultSet rs) {
        if (rs != null)
            try {
                rs.close();
            } catch (SQLException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        if (pst != null)
            try {
                pst.close();
            } catch (SQLException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        if (conn != null)
            try {
                conn.close();
            } catch (SQLException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
    } 
	
	public static void close(Connection conn, PreparedStatement pst) {
        if (pst != null)
            try {
                pst.close();
            } catch (SQLException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        if (conn != null)
            try {
                conn.close();
            } catch (SQLException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }

    } 
}
