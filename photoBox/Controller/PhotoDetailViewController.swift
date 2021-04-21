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
    
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.6)
        view.layer.cornerRadius = 5.0
        
        return view
    }()
    
    private let photoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 20)
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()

    private let photoUsernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 16)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let photoDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 14)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let photoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 14)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let photoLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 12)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let viewModeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up.and.down.and.arrow.left.and.right"), for: .normal)
        button.backgroundColor = UIColor(named: "background")
        button.tintColor = UIColor.white
        button.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 35
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
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
    
    private let switchInfoColorButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "switch.2"), for: .normal)
        button.backgroundColor = UIColor(named: "background")
        button.tintColor = UIColor.white
        button.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 10
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        return button
    }()
    
    private let forwardUrlButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowshape.turn.up.forward.circle.fill"), for: .normal)
        button.backgroundColor = UIColor(named: "background")
        button.tintColor = UIColor.white
        button.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 10
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8034083407)
        
        addInteractionTargets()
        setupView()
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
                self?.setInfoLabels(info.photo)
            }
        }
    }
    
    private func addInteractionTargets() {
        viewModeButton.addTarget(self, action: #selector(viewModeButtonTapped), for: .touchUpInside)
        toggleInfoButton.addTarget(self, action: #selector(toggleInfoButtonTapped), for: .touchUpInside)
        switchInfoColorButton.addTarget(self, action: #selector(switchInfoColorTapped), for: .touchUpInside)
        forwardUrlButton.addTarget(self, action: #selector(switchInfoColorTapped), for: .touchUpInside)
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipedDown)))
    }
    
    private func setInfoLabels(_ photoInfo: PhotoInfo) {
        photoTitleLabel.text = photoInfo.title.content
        photoDescriptionLabel.text = photoInfo.description.content
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .medium
        photoDateLabel.text = df.string(from: Date(timeIntervalSince1970: Double(photoInfo.dateUploaded)!))
        if photoInfo.owner.realname != "" {
            photoUsernameLabel.text = "Photo by: \(photoInfo.owner.username) (\(photoInfo.owner.realname))"
        }
        else {
            photoUsernameLabel.text = "Photo by: \(photoInfo.owner.username)"
        }
        photoLocationLabel.text = "Location: \(photoInfo.location.country.content), \(photoInfo.location.region.content), \(photoInfo.location.neighbourhood.content), \(photoInfo.location.locality.content)"
    }
    
    private func setupView() {
        view.addSubview(imageView)
        view.addSubview(viewModeButton)
        view.addSubview(toggleInfoButton)
        view.addSubview(infoView)
        
        infoView.addSubview(photoTitleLabel)
        infoView.addSubview(photoDateLabel)
        infoView.addSubview(photoUsernameLabel)
        infoView.addSubview(photoLocationLabel)
        infoView.addSubview(photoDescriptionLabel)
        infoView.addSubview(switchInfoColorButton)
        infoView.addSubview(forwardUrlButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        switch LocalData.instance.photoViewMode {
        case "scaleAspectFit":
            imageView.contentMode = .scaleAspectFit
        case "scaleAspectFill":
            imageView.contentMode = .scaleAspectFill
        default:
            imageView.contentMode = .scaleAspectFill
        }
        
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
        
        infoView.isHidden = LocalData.instance.photoShowInfo
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        infoView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        infoView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        
        photoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        photoTitleLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 10).isActive = true
        photoTitleLabel.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: 10).isActive = true
        photoTitleLabel.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -10).isActive = true
        photoTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        photoDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        photoDescriptionLabel.topAnchor.constraint(equalTo: photoTitleLabel.bottomAnchor, constant: 5).isActive = true
        photoDescriptionLabel.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: 10).isActive = true
        photoDescriptionLabel.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -10).isActive = true
        photoDescriptionLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        photoDateLabel.translatesAutoresizingMaskIntoConstraints = false
        photoDateLabel.topAnchor.constraint(equalTo: photoDescriptionLabel.bottomAnchor, constant: 5).isActive = true
        photoDateLabel.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: 10).isActive = true
        photoDateLabel.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -10).isActive = true
        photoDateLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        photoUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        photoUsernameLabel.topAnchor.constraint(equalTo: photoDateLabel.bottomAnchor, constant: 5).isActive = true
        photoUsernameLabel.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: 10).isActive = true
        photoUsernameLabel.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -10).isActive = true
        photoUsernameLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        photoLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        photoLocationLabel.topAnchor.constraint(equalTo: photoUsernameLabel.bottomAnchor, constant: 5).isActive = true
        photoLocationLabel.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: 10).isActive = true
        photoLocationLabel.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -10).isActive = true
        photoLocationLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        switchInfoColorButton.translatesAutoresizingMaskIntoConstraints = false
        switchInfoColorButton.topAnchor.constraint(equalTo: photoLocationLabel.bottomAnchor, constant: 10).isActive = true
        switchInfoColorButton.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: 10).isActive = true
        switchInfoColorButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        switchInfoColorButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        forwardUrlButton.translatesAutoresizingMaskIntoConstraints = false
        forwardUrlButton.topAnchor.constraint(equalTo: photoLocationLabel.bottomAnchor, constant: 10).isActive = true
        forwardUrlButton.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -10).isActive = true
        forwardUrlButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        forwardUrlButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    @objc private func viewModeButtonTapped() {
        if imageView.contentMode == .scaleAspectFill {
            UIView.transition(with: self.imageView,
                              duration: 1.0,
                              options: .transitionCrossDissolve, animations: {
                                self.imageView.contentMode = .scaleAspectFit
                              })
            LocalData.instance.photoViewMode = "scaleAspectFit"
            return
        }
        
        if imageView.contentMode == .scaleAspectFit {
            UIView.transition(with: self.imageView,
                              duration: 1.0,
                              options: .transitionCrossDissolve, animations: {
                                self.imageView.contentMode = .scaleAspectFill
                              })
            LocalData.instance.photoViewMode = "scaleAspectFill"
            return
        }
    }
    
    @objc private func toggleInfoButtonTapped() {
        UIView.transition(with: self.infoView,
                          duration: 1.0,
                          options: .transitionCrossDissolve, animations: {
                            self.infoView.isHidden = !self.infoView.isHidden
                          })
        LocalData.instance.photoShowInfo = infoView.isHidden
    }
    
    @objc private func switchInfoColorTapped() {
        
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
