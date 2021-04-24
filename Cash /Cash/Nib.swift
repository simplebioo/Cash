//
//  File.swift
//  Cash
//
//  Created by Bioo on 05.11.2020.
//

import Foundation
import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
}
