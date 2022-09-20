//
//  ListItem.swift
//  CustomList
//
//  Created by Daffolap-mac-114 on 19/09/22.
//

import Foundation

enum ItemType:String {
case PHOTO = "PHOTO"
case COMMENT = "COMMENT"
case SINGLE_CHOICE = "SINGLE_CHOICE"
}

struct ListItem: Decodable {
    
    let type:String
    let id:String
    let title:String
    let dataMap:[String: [String]]
}
