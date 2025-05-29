package com.example.demo.utils;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordHashUtil {
    //use BCrypt to hash the password


    //method to hash the password
    public static String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    //method to check the hashed password
    public static boolean checkPassword(String password, String hashedPassword) {
        return BCrypt.checkpw(password, hashedPassword);
    }

}
