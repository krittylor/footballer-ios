//
//  ModelUser.swift
//  Football
//
//  Created by Admin User on 3/3/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import Foundation

class User {
    public var userName: String = ""
    public var email: String = ""
    public var userType: Int = 0x01
    private var password: String = ""
    public var id: String = ""
    init (uid: String, userName: String, email: String, password: String, userType: Int) {
        self.id = uid
        self.userName = userName
        self.email = email
        self.password = password
        self.userType = userType
    }
    func getUser() -> Dictionary<String, Any>{
        let user = ["id": id,
                    "userName": userName,
                    "email": email,
                    "password": password,
                    "userType": userType] as [String : Any]
        return user
    }
}
