//
//  PhotoDetailViewController.swift
//  photoBox
//
//  Created by Ścibor Budkowski on 14/04/2021.
//

import UIKit
import Kingfisher

class PhotoDetailViewController: UIViewController {
    
    private var photo: Photo!
    private var photoDetail: PhotoDetail!
    private var photoUrl: URL!
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private let photoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 20)
        
        return label
    }()

    private let photoUsernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 16)
        
        return label
    }()
    
    private let photoDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 14)
        
        return label
    }()
    
    private let photoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 14)
        
        return label
    }()
    
    private let photoLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 12)
        
        return label
    }()
    
    private let viewModeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up.and.down.and.arrow.left.and.right"), for: .normal)
        // arrow.uturn.down.circle.fill
        button.backgroundColor = UIColor(named: "background")
        button.tintColor = UIColor.white
        button.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 35
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        button.addTarget(self, action: #selector(viewModeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let toggleInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        button.backgroundColor = UIColor(named: "background")
        button.tintColor = UIColor.white
        button.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 35
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        
        setupView()
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipedDown)))
    }
    
    public func configure(_ photo: Photo) {
        self.photo = photo
        
        let f = FlickrService()
        
        f.fetchPhotoInfo(for: self.photo.id) { [weak self] (info, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let info = info {
                self?.photoDetail = info
                self?.photoUrl = f.getPhotoUrl(photoInfo: info.photo)
                self?.imageView.kf.setImage(with: self?.photoUrl)
            }
        }
    }
    
    private func setupView() {
        view.addSubview(imageView)
        view.addSubview(photoTitleLabel)
        view.addSubview(photoDateLabel)
        view.addSubview(photoUsernameLabel)
        view.addSubview(photoLocationLabel)
        view.addSubview(photoDescriptionLabel)
        view.addSubview(viewModeButton)
        view.addSubview(toggleInfoButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        viewModeButton.translatesAutoresizingMaskIntoConstraints = false
        if DeviceOrientation.isPortrait() {
            viewModeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        }
        else {
            viewModeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
        viewModeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        viewModeButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        viewModeButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        toggleInfoButton.translatesAutoresizingMaskIntoConstraints = false
        if DeviceOrientation.isPortrait() {
            toggleInfoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        }
        else {
            toggleInfoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
        toggleInfoButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        toggleInfoButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        toggleInfoButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func updateControls() {
        
    }
    
    @objc private func viewModeButtonTapped() {
        if imageView.contentMode == .scaleAspectFill {
            UIView.transition(with: self.imageView,
                              duration: 1.0,
                              options: .transitionCrossDissolve, animations: {
                                self.imageView.contentMode = .scaleAspectFit
                              })
            return
        }
        
        if imageView.contentMode == .scaleAspectFit {
            UIView.transition(with: self.imageView,
                              duration: 1.0,
                              options: .transitionCrossDissolve, animations: {
                                self.imageView.contentMode = .scaleAspectFill
                              })
            return
        }
    }
    
    @objc private func swipedDown(sender: UIPanGestureRecognizer) {
        var viewTransform = CGPoint(x: 0, y: 0)
        
        switch sender.state {
        case .changed:
            viewTransform = sender.translation(in: view)
            UIView.animate(withDuration: 1.0,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut) {
                self.view.transform = CGAffineTransform(translationX: 0, y: viewTransform.y)
            }
            
        case .ended:
            if viewTransform.y > self.view.bounds.height / 2 {
                UIView.animate(withDuration: 1.0,
                               delay: 0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 1,
                               options: .curveEaseOut) {
                    self.view.transform = .identity
                }
            }
            else {
                dismiss(animated: true)
            }
            
        default:
            break
        }
    }
}
