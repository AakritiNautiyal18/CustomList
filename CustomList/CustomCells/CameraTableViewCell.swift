//
//  CameraTableViewCell.swift
//  CustomList
//
//  Created by Daffolap-mac-114 on 19/09/22.
//

import UIKit

protocol PhotoDelegate:AnyObject{
    func openCamera(for itemIndex: Int)
    func openPicture(for itemIndex: Int)
    func removePhoto(for itemIndex: Int)
}

class CameraTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var crossView: UIView!
    
    private weak var delegate:PhotoDelegate?
    private var photoItem: PhotoItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //tap gesture for capturing or displaying image
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(tapOnImage))
        gesture1.numberOfTapsRequired = 1
        gesture1.cancelsTouchesInView = false
        photoImageView.addGestureRecognizer(gesture1)
        
        //tap gesture for cross button
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(crossButtonTapped))
        gesture2.numberOfTapsRequired = 1
        gesture2.cancelsTouchesInView = true
        crossView.addGestureRecognizer(gesture2)
        
    }
    
    func cellSetup(with itemDetails: PhotoItem, and delegate: PhotoDelegate){
        photoItem = itemDetails
        self.delegate = delegate
        designCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

private extension CameraTableViewCell{
    
    func designCell(){
        if let photoItem = photoItem {
            titleLabel.text = photoItem.title
            if photoItem.isPhotoAvailable{
                crossView.isHidden = false
                photoImageView.image = photoItem.image
            }else{
                crossView.isHidden = true
                photoImageView.image = UIImage(named: "placeholder")
            }
        }
    }
    
    @objc func tapOnImage(){
        if let photoItem = photoItem{
            if photoItem.isPhotoAvailable {
            delegate?.openPicture(for: photoItem.index)
        } else {
            delegate?.openCamera(for: photoItem.index)
        }
        }
    }
    
    
    @objc func crossButtonTapped() {
        if let photoItem = photoItem{
            delegate?.removePhoto(for: photoItem.index)
        }
    }
}
