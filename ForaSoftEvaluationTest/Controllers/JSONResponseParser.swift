//
//  JSONResponseParser.swift
//  ForaSoftEvaluationTest
//
//  Created by Danil on 29.01.18.
//  Copyright © 2018 @Danil. All rights reserved.
//

import UIKit

class JSONResponseParser: NSObject {
    
    public func perfromDetailInfoParse (responseData:Data?) -> (Array<singleTrack>, albumDetailInfo)
    {
        var resultArray = [singleTrack]()
        var resultDetailInfo = albumDetailInfo()

        
        do {
            if let data = responseData,
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let attributes = json["results"] as? [[String: Any]] {
                for attribute in attributes {
                    var track:singleTrack = singleTrack()
                    if let trackName = attribute["trackName"] as? String {
                        track.trackName = trackName
                    }
                    if let genre = attribute["primaryGenreName"] as? String {
                        resultDetailInfo.genre = genre
                    }
                    if let price = attribute["collectionPrice"] as? Float {
                        if (price > 0){
                            resultDetailInfo.price = String(price)
                        }
                    }
                    
                    if (track.trackName != "")
                    {
                        resultArray.append(track)
                    }
                    
                }
            }
        } catch {
            print("Error deserializing JSON: ")//\(error)")
        }
        
        return (resultArray, resultDetailInfo)
    }
    
    public func performBasicAlbumParse (responseData:Data?) -> Array<albumBasicInfo>
    {

        var albumsDataCollection = [albumBasicInfo]()
        
        do {
            if let data = responseData,
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let attributes = json["results"] as? [[String: Any]] {
                for attribute in attributes {
                    
                    var basicAlbumData = albumBasicInfo()
                    
                    if let imageURL = attribute["artworkUrl100"] as? String {
                        basicAlbumData.artBookURL = imageURL
                    }
                    if let artistName = attribute["artistName"] as? String {
                        basicAlbumData.artistName = artistName
                        
                    }
                    if let albumName = attribute["collectionName"] as? String {
                        basicAlbumData.albumName = albumName
                    }
                    if let albumId = attribute["collectionId"] as? Int {
                        basicAlbumData.albumId = String(albumId)
                    }
                    if (basicAlbumData.artBookURL != "" && basicAlbumData.albumName != "")
                    {
                        albumsDataCollection.append(basicAlbumData)
                    }
                }
            }
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        return albumsDataCollection
        
    }
}
