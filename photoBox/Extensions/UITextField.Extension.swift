//
//  UITextField.Extension.swift
//  photoBox
//
//  Created by Ścibor Budkowski on 21/04/2021.
//

import UIKit

class TextFieldWithPadding: UITextField {
    
    public var textPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        
        return rect.inset(by: textPadding)
    }
}
