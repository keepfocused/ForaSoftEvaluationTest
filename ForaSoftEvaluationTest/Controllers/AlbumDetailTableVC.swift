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
    
    public var basicInfo = albumBasicInfo()
    private var detailInfo = albumDetailInfo()
    
    private var songs = [singleTrack]()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //879273552
//        //&entity=album"
        
        let albumId = self.basicInfo.albumId
        
        
        
        Alamofire.request("https://itunes.apple.com/lookup?id=\(albumId)&entity=song").responseJSON(){(data) in
            
            
            var json:Data? = nil
            
            let tempData = data.data
            
            json = tempData

            
            let parser = JSONResponseParser()
            
            let (tracksArray, parsedDetailData) = parser.perfromDetailInfoParse(responseData: json)
            
            self.songs = tracksArray
            self.detailInfo = parsedDetailData
 
            self.tableView.reloadData()
            
    }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
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
            let detailCell = tableView.dequeueReusableCell(withIdentifier: self.albumInfoIdentifier, for: indexPath) as! AlbumDetailCell
            detailCell.albumNameLabel.text = self.basicInfo.albumName
            detailCell.artistNameLabel.text = self.basicInfo.artistName
            detailCell.albumImageView.image = self.basicInfo.artBookImage
            detailCell.priceLabel.text = "price: $ \(self.detailInfo.price)"
            detailCell.genreLabel.text = self.detailInfo.genre
            
            return detailCell

            
        case 1:
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
            return 228
        case 1:
            return 50
        default:
            break
        }
        return 1
    }


}
