//
//  AlbumDetailTableVC.swift
//  ForaSoftEvaluationTest
//
//  Created by Danil on 24.01.18.
//  Copyright © 2018 @Danil. All rights reserved.
//

import UIKit
import Alamofire

class AlbumDetailTableVC: UITableViewController {
    
    //https://itunes.apple.com/us/album/in-between-dreams/879273552?uo=4
    
    public var albumId = ""
    
    var songs = [singleTrack]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //879273552
//        //&entity=album"
        
        
        Alamofire.request("https://itunes.apple.com/lookup?id=\(self.albumId)&entity=song").responseJSON(){(data) in
            

            print(data)
            
            var json:Data? = nil
            
//            if let result =  data.data {
//                let tempJson = result as! Data
//                
//                // print("Test sest test data json")
//               //  print(tempJson)
//                
//                json = tempJson
//            }
//        }
            let tempData = data.data
            json = tempData

//collectionName collectionPrice trackTimeMillis
        
        do {
            if let data = json,
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let blogs = json["results"] as? [[String: Any]] {
                for blog in blogs {
                    var track:singleTrack = singleTrack(trackName: "", trackLength: "")
                    if let trackName = blog["trackName"] as? String {
                        //self.songs.append(trackName)
                        track.trackName = trackName
                    }
                    if let trackLength = blog["trackTimeMillis"] as? String {
                        track.trackLength = trackLength
                    }
                    self.songs.append(track)
                    
       
                }
            }
        } catch {
            print("Error deserializing JSON: ")//\(error)")
        }
        
        print("Try to print songs ")
        print(self.songs)
            
            self.tableView.reloadData()
            
            
            //                    if let artistName = blog["artistName"] as? String {
            //
            //                    }
            //                    if let artistName = blog["albumName"] as? String {
            //
            //                    }
            //                    if let genre = blog["primaryGenreName"] as? String {
            //
            //                    }
            //                    if let genre = blog["artworkUrl60"] as? String {
            //                        
            //                    }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return self.songs.count
        default:
            return 0
        }
    }
    
   private let  albumImageIdentifier =  "albumImage"
   private let albumInfoIdentifier =    "albumInfo"
   private let songIdentifier =         "song"

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
 
        
        //albumImage    albumInfo   song
        
        switch indexPath.section {
        case 0:
            let albumCell = tableView.dequeueReusableCell(withIdentifier: self.albumImageIdentifier, for: indexPath) as! AlbumImageCell
           // albumCell.backgor
            return albumCell

           
        case 1:
            let detailCell = tableView.dequeueReusableCell(withIdentifier: self.albumInfoIdentifier, for: indexPath) as! AlbumDetailCell
            return detailCell

            
        case 2:
            let songCell = tableView.dequeueReusableCell(withIdentifier: self.songIdentifier, for: indexPath) as! songCell
            let track = self.songs[indexPath.row]
            songCell.trackNameLabel?.text = track.trackName
            songCell.numberOfTrackLabel.text = String(indexPath.row + 1)
            return songCell

            
        default: break
            
            
        }
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "")!
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 200
        case 1:
            return 228
        case 2:
            return 50
        default:
            break
        }
        return 1
    }


}
