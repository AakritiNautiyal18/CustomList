//
//  SingleChoiceTableViewCell.swift
//  CustomList
//
//  Created by Daffolap-mac-114 on 19/09/22.
//

import UIKit

protocol SingleChoiceDelegate:AnyObject{
    func optionSelected(for itemIndex: Int, optionIndex: Int)
}

class SingleChoiceTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var optionsTableView: DynamicHeightTableView!
    
    private weak var delegate:SingleChoiceDelegate?
    private var singleChoiceItem:SingleChoiceItem?
    private var options = [OptionModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        optionsTableView.register(UINib(nibName: "OptionTableViewCell", bundle: nil), forCellReuseIdentifier: "OptionCell")
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cellSetup(with itemDetails: SingleChoiceItem, and delegate: SingleChoiceDelegate){
        singleChoiceItem = itemDetails
        options = itemDetails.options
        self.delegate = delegate
        designCell()
        optionsTableView.reloadData()
    }
}

private extension SingleChoiceTableViewCell{
    func designCell(){
        if let singleChoiceItem = singleChoiceItem {
            titleLabel.text = singleChoiceItem.title
        }
        
    }
}

extension SingleChoiceTableViewCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as? OptionTableViewCell{
            cell.cellSetup(with:options[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionIndex = indexPath.row
        
        if let singleChoiceItem = singleChoiceItem{
            delegate?.optionSelected(for: singleChoiceItem.index, optionIndex: optionIndex)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
    
}
