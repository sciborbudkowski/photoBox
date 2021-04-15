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
    
    public func fetchPhotoList(coordinates: CLLocationCoordinate2D, page: Int = 1, completion: @escaping(PhotoList?, Error?) -> ()) {
        let url = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(API_KEY)&lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&radius=1&radius_units=km&per_page=24&format=json&nojsoncallback=1&page=\(page)"
        let request = AF.request(URL(string: url)!)
        
        request.responseDecodable(of: PhotoList.self) { (response) in
            guard let list = response.value else {
                completion(nil, response.error)
                return
            }
            
            completion(list, nil)
        }
    }
    
    public func fetchPhotoInfo(for id: String, completion: @escaping(PhotoDetail?, Error?) -> ()) {
        let url = "https://api.flickr.com/services/rest/?api_key=\(API_KEY)&method=flickr.photos.getInfo&photo_id=\(id)&format=json&nojsoncallback=1"
        print(url)
        let request = AF.request(URL(string: url)!)
        
        request.responseDecodable(of: PhotoDetail.self) { (response) in
            guard let info = response.value else {
                completion(nil, response.error)
                return
            }
            
            completion(info, nil)
        }
    }
    
    public func getPhotoUrl(photoInfo: PhotoInfo) -> URL {
        //let postURL: String = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!).jpg"
        let url = "https://farm\(photoInfo.farm).staticflickr.com/\(photoInfo.server)/\(photoInfo.id)_\(photoInfo.secret).jpg"
        
        return URL(string: url)!
    }
}
