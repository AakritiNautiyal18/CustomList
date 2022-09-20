//
//  CommentItem.swift
//  CustomList
//
//  Created by Daffolap-mac-114 on 19/09/22.
//

import Foundation

struct CommentItem{
    let index:Int
    let id:String
    let title:String
    var isTextPresent:Bool{
        return text != ""
    }
    var text:String
    var showComment:Bool
    init(listItem: ListItem,index:Int) {
        self.id = listItem.id
        self.title = listItem.title
        self.text = ""
        self.index = index
        self.showComment = false
    }
}
