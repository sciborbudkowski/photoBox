//
//  Flickr.swift
//  photoBox
//
//  Created by Ścibor Budkowski on 13/04/2021.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let isPublic: Int
    let isFriend: Int
    let isFamily: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
    }
}

struct Photos: Decodable {
    
    let page: Int
    let pages: Int
    let perPage: Int
    let total: String
    let photo: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perPage = "perpage"
        case total
        case photo
    }
}

struct PhotoList: Decodable {
    
    let photos: Photos
    
    enum CodingKeys: String, CodingKey {
        case photos
    }
}

struct PhotoInfo: Decodable {
    
    let id: String
    let secret: String
    let server: String
    let farm: Int
    let dateUploaded: String
    let owner: PhotoOwner
    let title: PhotoTextContent
    let description: PhotoTextContent
    let location: PhotoLocation
    
    enum CodingKeys: String, CodingKey {
        case id
        case secret
        case server
        case farm
        case dateUploaded = "dateuploaded"
        case owner
        case title
        case description
        case location
    }
}


struct PhotoOwner: Decodable {
    
    let nsid: String
    let username: String
    let realname: String
    
    enum CodingKeys: String, CodingKey {
        case nsid
        case username
        case realname
    }
}

struct PhotoTextContent: Decodable {
    
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}

struct PhotoLocation: Decodable {
    
    let latitude: String
    let longitude: String
    let accuracy: String
    let locality: PhotoTextContent
    let neighbourhood: PhotoTextContent
    let region: PhotoTextContent
    let country: PhotoTextContent
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case accuracy
        case locality
        case neighbourhood
        case region
        case country
    }
}
