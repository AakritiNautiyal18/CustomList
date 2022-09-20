//
//  PhotoItem.swift
//  CustomList
//
//  Created by Daffolap-mac-114 on 19/09/22.
//

import Foundation
import UIKit

struct PhotoItem{
    let index:Int
    let id:String
    let title:String
    var isPhotoAvailable:Bool
    var image:UIImage?
    
    init(listItem: ListItem, index:Int) {
        self.id = listItem.id
        self.title = listItem.title
        self.isPhotoAvailable = false
        self.index = index
    }
}
