//
//  PhotoDetailViewController.swift
//  photoBox
//
//  Created by Ścibor Budkowski on 14/04/2021.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    private var photo: PhotoInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
    
    public func configure(_ id: String) {
        let f = FlickrService()
        f.fetchPhotoInfo(for: id) { [weak self] (info, error) in
            if let error = error {
                print(error)
                return
            }
            
            self?.photo = info
            dump(info)
        }
    }
}
