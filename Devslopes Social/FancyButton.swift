//
//  FancyButton.swift
//  Devslopes Social
//
//  Created by Donald Nguyen on 12/11/16.
//  Copyright © 2016 Donald Nguyen. All rights reserved.
//

import UIKit

class FancyButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)

        imageView?.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //this point the frame size has been known
        layer.cornerRadius = self.frame.width / 2
    }

}
