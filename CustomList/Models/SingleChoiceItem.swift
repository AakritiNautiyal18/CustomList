//
//  SingleChoiceItem.swift
//  CustomList
//
//  Created by Daffolap-mac-114 on 19/09/22.
//

import Foundation

struct SingleChoiceItem{
    let index:Int
    let id:String
    let title:String
    var selectedOptionIndex:Int
    var options:[OptionModel]
    
    init(listItem: ListItem, index:Int) {
        self.id = listItem.id
        self.title = listItem.title
        self.selectedOptionIndex = -1
        self.index = index
        
        var tempOptionArray = [OptionModel]()
        for item in listItem.dataMap["options"] ?? []{
            let optionModel = OptionModel(isSelected: false, title: item)
            tempOptionArray.append(optionModel)
        }
        options = tempOptionArray
    }
}
