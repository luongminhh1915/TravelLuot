/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnect {

    protected Connection connection;
    
    public DBConnect() {
        try {
            String url = "jdbc:sqlserver://localhost:1433;databaseName=travel_luot;encrypt=true;trustServerCertificate=true;";
            String user = "sa";
            String pass = "123456";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(dal.DBConnect.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
    public Connection getConnection() {
        return connection;
    }
     public static void main(String[] args) {
        DBConnect conn= new DBConnect();
        System.out.println(conn.connection);
    }
}