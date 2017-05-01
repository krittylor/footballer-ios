//
//  Field.swift
//  Football
//
//  Created by Admin User on 3/6/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import Foundation

class Field: NSObject {
    public var fieldName: String = ""
    public var locationName: String = ""
    public var cityName: String = ""
    public var fieldOwner: String = ""
    public var price: Int = 0x01
    public var longitude: Double = 0x00
    public var latitude: Double = 0x00
    public var photoUrls: NSArray = []
    init (fieldName: String, locationName: String, cityName: String, fieldOwner: String, price: Int, longitude: Double, latitude: Double, photoUrls: NSArray) {
        self.fieldName = fieldName
        self.locationName = locationName
        self.cityName = cityName
        self.price = price
        self.fieldOwner = fieldOwner
        self.longitude = longitude
        self.latitude = latitude
        self.photoUrls = photoUrls
    }
    
    func getField() -> Dictionary<String, Any>{
        let field = ["fieldName": self.fieldName,
                     "locationName": self.locationName,
                     "cityName": self.cityName,
                     "fieldOwner": self.fieldOwner,
                     "price": self.price,
                     "longitude": self.longitude,
        "latitude": self.latitude,
        "photoUrls": self.photoUrls ] as [String: Any]
        
        return field
    }
    
    convenience override init() {
        self.init(fieldName:  "", locationName: "", cityName: "", fieldOwner: "", price: 30, longitude: 0.0, latitude: 0.0, photoUrls: [])
    }
}
