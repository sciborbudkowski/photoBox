//
//  PhotoViewCell.swift
//  photoBox
//
//  Created by Ścibor Budkowski on 14/04/2021.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
