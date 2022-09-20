//
//  ImagePreviewViewController.swift
//  CustomList
//
//  Created by Daffolap-mac-114 on 20/09/22.
//

import UIKit

class ImagePreviewViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = image {
            imageView.image = image
        }
    }
    
    @IBAction func dismissPreview(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
