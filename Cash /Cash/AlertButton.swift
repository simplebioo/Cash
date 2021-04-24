//
//  AlertButton.swift
//  Cash
//
//  Created by Bioo on 04.11.2020.
//

import UIKit

@IBDesignable
class AlertButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 22
    }

}
