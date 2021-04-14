//
//  PhotoViewController.swift
//  photoBox
//
//  Created by Ścibor Budkowski on 14/04/2021.
//

import UIKit
import Kingfisher

class PhotoViewController: UIViewController {
    
    private var photos: PhotoList!
    
    private let photoView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
        view.register(PhotoViewCell.self, forCellWithReuseIdentifier: PhotoViewCell.identifier)
        view.backgroundColor = .clear
        
        return view
    }()
    
    private let pageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 14.0)
        label.textColor = .label
        label.text = "Page #x# of #y#"
        
        return label
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left.circle.fill"), for: .normal)
        button.tintColor = UIColor(named: "background")
        
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
        button.tintColor = UIColor(named: "background")
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        
        photoView.delegate = self
        photoView.dataSource = self
        
        setupView()
    }
    
    public func configure(_ photos: PhotoList) {
        self.photos = photos
    }
    
    private func setupView() {
        view.addSubview(leftButton)
        view.addSubview(pageLabel)
        view.addSubview(rightButton)
        view.addSubview(photoView)
        
        pageLabel.translatesAutoresizingMaskIntoConstraints = false
        pageLabel.sizeToFit()
        pageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        pageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageLabel.text = String(format: "Page %d of %d", photos.photos.page, photos.photos.pages)
        
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        leftButton.rightAnchor.constraint(equalTo: pageLabel.leftAnchor, constant: -5).isActive = true
        leftButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        leftButton.heightAnchor.constraint(equalToConstant: 20).isActive = true

        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        rightButton.leftAnchor.constraint(equalTo: pageLabel.rightAnchor, constant: 5).isActive = true
        rightButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: 20).isActive = true

        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.topAnchor.constraint(equalTo: pageLabel.bottomAnchor, constant: 10).isActive = true
        photoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        photoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        photoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
    }
}

extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.photos.photo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewCell.identifier, for: indexPath) as? PhotoViewCell else { return UICollectionViewCell() }
        let image = photos.photos.photo[indexPath.row]
        let imageUrl = "https://farm\(image.farm).staticflickr.com/\(image.server)/\(image.id)_\(image.secret).jpg"
        if let url = URL(string: imageUrl) {
            let imageView = UIImageView()
            imageView.kf.setImage(with: url)
            imageView.frame.size = CGSize(width: 65, height: 65)
            imageView.contentMode = .scaleToFill
            cell.addSubview(imageView)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PhotoDetailViewController()
        vc.configure(photos.photos.photo[indexPath.row].id)
        ModalViewController.show(self, modal: vc, size: view.bounds.height)
    }
}