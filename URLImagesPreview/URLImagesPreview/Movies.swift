//
//  Movies.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 16, 2020

import Foundation

struct Movies : Codable {

        let array : [Int]?
        let booleanField : Bool?
        let custArray : [CustArray]?
        let nullField : AnyObject?
        let number : Int?
        let object : Object?
        let string : String?

        enum CodingKeys: String, CodingKey {
                case array = "Array"
                case booleanField = "Boolean"
                case custArray = "CustArray"
                case nullField = "Null"
                case number = "Number"
                case object = "Object"
                case string = "String"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                array = try values.decodeIfPresent([Int].self, forKey: .array)
                booleanField = try values.decodeIfPresent(Bool.self, forKey: .booleanField)
                custArray = try values.decodeIfPresent([CustArray].self, forKey: .custArray)
                nullField = try values.decodeIfPresent(AnyObject.self, forKey: .nullField)
                number = try values.decodeIfPresent(Int.self, forKey: .number)
                object = Object(from: decoder)
                string = try values.decodeIfPresent(String.self, forKey: .string)
        }

}
