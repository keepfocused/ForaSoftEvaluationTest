//
//  File.swift
//  ForaSoftEvaluationTest
//
//  Created by Danil on 15.02.2018.
//  Copyright © 2018 @Danil. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage


class NetworkManager {
    
    public static let sharedInstance = NetworkManager()
    
    
    ///Retrieves initial albums
    ///
    /// - Parameters:
    ///   - artistIdArray: Array of string with iTunes artist ids
    /// - Returns: Raw data for overrided setter for AlbumCollectionVc.responseData
    
    public func getAlbumsById (artistIdArray:Array<String>, completion: @escaping (Data?) -> Void) {
        
        let artistIdValue = artistIdArray.joined(separator: ",")
        
        Alamofire.request("https://itunes.apple.com/lookup?amgArtistId=\(artistIdValue)&entity=album&limit=50").responseJSON(){(data) in
            
            let json:Data? = data.data
            
            completion (json)
        }
    }
    
    ///Retrieves albums by search text
    ///
    /// - Parameters:
    ///   - textForSearch: input text in searchbar
    /// - Returns: Raw data for overrided setter for AlbumCollectionVc.responseData
    
    public func getAlbumsBySearchTerm (searchTerm:String, completion: @escaping (Data?) -> Void) {
        
        Alamofire.request("https://itunes.apple.com/search?term=\(searchTerm)&media=music&entity=album&attribute=albumTerm").responseJSON(){(data) in
            
            let json:Data? = data.data
            
            completion (json)
        }
    }
    
    public func getDetailInfoByAlbumId (albumId:String, completion: @escaping (Data?) -> Void) {
        
        Alamofire.request("https://itunes.apple.com/lookup?id=\(albumId)&entity=song").responseJSON(){(data) in
        
        let json:Data? = data.data
        
        completion (json)

        }
    }
    
    
    public func getImageByUrl (imageURL:String, completion: @escaping (UIImage?) -> Void) {
        
        Alamofire.request(imageURL).responseImage(){(image) in
            
            let image:Image? = image.value
            
            completion (image)
            
            
        }
    }
}
