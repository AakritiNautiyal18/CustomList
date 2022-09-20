//
//  OptionTableViewCell.swift
//  CustomList
//
//  Created by Daffolap-mac-114 on 19/09/22.
//

import UIKit

protocol OptionDelegate:AnyObject{
    func optionSelected(optionIndex: Int)
}

class OptionTableViewCell: UITableViewCell {
    @IBOutlet private weak var radioButtonImageView: UIImageView!
    @IBOutlet private weak var optionTitlelabel: UILabel!
    private var option:OptionModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cellSetup(with option: OptionModel){
        self.option = option
        designCell()
    }
}

private extension OptionTableViewCell{
    
    func designCell(){
        if let option = option{
            optionTitlelabel.text = option.title
            if option.isSelected{
                radioButtonImageView.image = UIImage(named: "radio-button-selected")
            } else {
                radioButtonImageView.image = UIImage(named: "radio-button-unselected")
            }
        }
    }
}
