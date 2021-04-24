//
//  AlertView.swift
//  Cash
//
//  Created by Bioo on 04.11.2020.
//

import UIKit

protocol AlertDelegate: class {
    func leftButtonTapped()
    func rightButtonTapped()
}

class AlertView: UIView {
    
    @IBOutlet var summTextField: UITextField!
    @IBOutlet var comTextField: UITextField!
    @IBOutlet var ammButton: AlertButton!
    @IBOutlet var trinButton: AlertButton!
    
    weak var delegate: AlertDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    @IBAction func ammAction(_ sender: Any) {
        delegate?.leftButtonTapped()
    }
    
    @IBAction func trinAction(_ sender: Any) {
        delegate?.rightButtonTapped()
    }
    
}
