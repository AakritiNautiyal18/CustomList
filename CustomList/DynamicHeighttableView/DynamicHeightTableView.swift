//
//  DynamicHeightTableView.swift
//  ACT Fibernet
//
//  Created by daffolapmac-136 on 18/10/21.
//  Copyright © 2021 ACT Fibernet. All rights reserved.
//

import UIKit

class DynamicHeightTableView: UITableView {

    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return contentSize
    }

}
