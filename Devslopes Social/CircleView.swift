//
//  CircleView.swift
//  Devslopes Social
//
//  Created by Donald Nguyen on 12/11/16.
//  Copyright © 2016 Donald Nguyen. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
    }
}
