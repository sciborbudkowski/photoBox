//
//  FlickrAF.swift
//  photoBox
//
//  Created by Ścibor Budkowski on 13/04/2021.
//

import Foundation
import Alamofire
import MapKit

class FlickrService {
    
    func fetchPhotoList(for coordinates: CLLocationCoordinate2D, completion: @escaping(PhotoList?, Error?) -> ()) {
        let url = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(API_KEY)&lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&radius=1&radius_units=km&per_page=24&format=json&nojsoncallback=1"
        let request = AF.request(URL(string: url)!)
        
        request.responseDecodable(of: PhotoList.self) { (response) in
            guard let list = response.value else {
                completion(nil, response.error)
                return
            }
            
            completion(list, nil)
        }
    }
    
    func fetchPhotoInfo(for id: String, completion: @escaping(PhotoInfo?, Error?) -> ()) {
        let url = "https://api.flickr.com/services/rest/?api_key=\(API_KEY)&method=flickr.photos.getInfo&photo_id=\(id)&nojsoncallback=1"
        let request = AF.request(URL(string: url)!)
        
        request.responseDecodable(of: PhotoInfo.self) { (response) in
            guard let info = response.value else {
                completion(nil, response.error)
                return
            }
            
            completion(info, nil)
        }
    }
}
