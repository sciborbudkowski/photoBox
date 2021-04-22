//
//  ViewController.swift
//  photoBox
//
//  Created by Ścibor Budkowski on 13/04/2021.
//

import UIKit
import CoreLocation
import MapKit
import Jelly

class MainViewController: UIViewController {
    
    var physicalLocation: CLLocationCoordinate2D?
    var currentLocation: CLLocationCoordinate2D?
    var annotation: MKPointAnnotation?
    var photoList: PhotoList?
    var didHitApi = false
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    let locationManager = CLLocationManager()
    
    private let mapView: MKMapView = {
        let view = MKMapView()
        
        return view
    }()
    
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "background")
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 20.0)
        
        label.textColor = .white
        label.text = "photoBox"
        
        return label
    }()

    private let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        button.tintColor = UIColor.white
        button.contentMode = .scaleToFill
        
        return button
    }()

    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        button.tintColor = UIColor.white
        button.contentMode = .scaleToFill
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = UIColor.white
        button.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let searchBar: UISearchBar = {
        let field = UISearchBar()
        field.tintColor = UIColor(named: "background")
        field.barTintColor = UIColor(named: "background")
        field.backgroundImage = UIImage()
        field.searchTextField.backgroundColor = .white
        field.searchTextField.textColor = UIColor(named: "background")
        field.isHidden = true
        
        return field
    }()
    
    private let searchResultsTable: UITableView = {
        let view = UITableView()
        
        return view
    }()
    
    private let backToUserLocationButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        button.backgroundColor = UIColor(named: "background")
        button.tintColor = UIColor.white
        button.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 35
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        button.addTarget(self, action: #selector(backToUserLocationButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let showPhotographiesButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
        button.backgroundColor = UIColor(named: "background")
        button.tintColor = UIColor.white
        button.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 35
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        button.addTarget(self, action: #selector(showPhotographiesButtonTapped), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetCurrentLocation()
        
        view.backgroundColor = .systemBackground
        
        setupView()
        setupGestures()
        
        searchResultsTable.delegate = self
        searchResultsTable.dataSource = self
        searchBar.delegate = self
        searchCompleter.delegate = self
    }
    
    private func GetCurrentLocation() {
        requestLocation { [weak self] location in
            self?.currentLocation = location
            self?.physicalLocation = location
        }
    }
    
    private func requestLocation(completion: @escaping(CLLocationCoordinate2D?) -> ()) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        if let location = locationManager.location {
            completion(location.coordinate)
        }
    }
    
    private func setupView() {
        view.addSubview(mapView)
        view.addSubview(topView)
        view.addSubview(backToUserLocationButton)
        view.addSubview(showPhotographiesButton)
        view.addSubview(searchResultsTable)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        if DeviceOrientation.isPortrait() {
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        }
        else {
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        }
        topView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        topView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        CenterMapWithAnnotation()
        
        backToUserLocationButton.translatesAutoresizingMaskIntoConstraints = false
        if DeviceOrientation.isPortrait() {
            backToUserLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        }
        else {
            backToUserLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
        backToUserLocationButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        backToUserLocationButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        backToUserLocationButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        showPhotographiesButton.translatesAutoresizingMaskIntoConstraints = false
        if DeviceOrientation.isPortrait() {
            showPhotographiesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        }
        else {
            showPhotographiesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
        showPhotographiesButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        showPhotographiesButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        showPhotographiesButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        topView.addSubview(titleLabel)
        topView.addSubview(menuButton)
        topView.addSubview(settingsButton)
        topView.addSubview(searchButton)
        topView.addSubview(searchBar)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.sizeToFit()
        titleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        
//        menuButton.translatesAutoresizingMaskIntoConstraints = false
//        menuButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
//        menuButton.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 10).isActive = true
//        menuButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        menuButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
//        settingsButton.translatesAutoresizingMaskIntoConstraints = false
//        settingsButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
//        settingsButton.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -10).isActive = true
//        settingsButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        settingsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
//        searchButton.rightAnchor.constraint(equalTo: settingsButton.leftAnchor, constant: 10).isActive = true
        searchButton.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -10).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
//        searchBar.leftAnchor.constraint(equalTo: menuButton.rightAnchor).isActive = true
//        searchBar.rightAnchor.constraint(equalTo: searchButton.leftAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: topView.leftAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: searchButton.leftAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        searchResultsTable.translatesAutoresizingMaskIntoConstraints = false
        searchResultsTable.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        searchResultsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        searchResultsTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchResultsTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchResultsTable.isHidden = true
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(mapViewTouchedLong))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        mapView.addGestureRecognizer(tap)
    }
    
    private func CenterMapWithAnnotation() {
        if let location = self.currentLocation {
            mapView.centerToLocation(location)
            
            self.annotation = MKPointAnnotation()
            self.annotation?.coordinate = location
            mapView.addAnnotation(self.annotation!)
            
            GetPhotoList(coordinate: location)
        }
    }
    
    @objc private func mapViewTouchedLong(sender: UIGestureRecognizer) {
        if sender.state == .ended {
            for annotation in mapView.annotations {
                mapView.removeAnnotation(annotation)
            }
            
            let touchPoint = sender.location(in: mapView)
            let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = DropablePinout(coordinate: touchCoordinate, identifier: "")
            mapView.addAnnotation(annotation)
            
            self.currentLocation = touchCoordinate
            mapView.centerToCoordinates(touchCoordinate)
            GetPhotoList(coordinate: touchCoordinate)
        }
    }
    
    @objc private func showPhotographiesButtonTapped() {
        let photoViewController = PhotoViewController()
        guard let photoList = self.photoList else { return }
        photoViewController.configure(photoList, currentLocation!)
        ModalViewController.show(self, modal: photoViewController, size: 310)
    }
    
    @objc private func backToUserLocationButtonTapped() {
        GetCurrentLocation()
        CenterMapWithAnnotation()
    }
    
    @objc private func searchButtonTapped() {
        UIView.transition(with: searchBar,
                          duration: 1,
                          options: .curveLinear) {
            self.searchBar.isHidden = !self.searchBar.isHidden
            self.searchBar.becomeFirstResponder()
        }
    }
    
    private func GetPhotoList(coordinate: CLLocationCoordinate2D) {
        let f = FlickrService()
        f.fetchPhotoList(coordinates: coordinate) { [weak self] (list, error) in
            self?.didHitApi = true
            
            if let error = error {
                print(error)
                return
            }
            
            if let list = list {
                self?.photoList = list
            }
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied:
            print("LocationManager didChangeAuthorization denied")
            
        case .notDetermined:
            print("LocationManager didChangeAuthorization notDetermined")
            
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            
        case .authorizedAlways:
            locationManager.requestLocation()
            
        case .restricted:
            print("LocationManager didChangeAuthorization restricted")
            
        default:
            print("LocationManager didChangeAuthorization")
        }
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResults[indexPath.row].title
        cell.detailTextLabel?.text = searchResults[indexPath.row].subtitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchResultsTable.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { [weak self] (response, error) in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else { return }
            self?.currentLocation = coordinate
            self?.CenterMapWithAnnotation()
            self?.GetPhotoList(coordinate: coordinate)
            self?.searchBar.text = nil
            self?.searchResultsTable.isHidden = true
            self?.searchBar.isHidden = true
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            searchResultsTable.isHidden = false
        }
        else {
            searchResultsTable.isHidden = true
        }
        searchCompleter.queryFragment = searchText
    }
}


extension MainViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTable.reloadData()
    }
}
