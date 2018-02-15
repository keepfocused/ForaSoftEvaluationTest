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
    
    public var basicInfo = AlbumBasicInfo()
    private var detailInfo = AlbumDetailInfo()
    
    private var songs = [SingleTrack]()
    
    
    //MARK: Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let albumId = self.basicInfo.albumId
        
        NetworkManager.sharedInstance.getDetailInfoByAlbumId(albumId: albumId, completion: { (data) in
            
            let json = data!
            
            let (tracksArray, parsedDetailData) = JSONResponseParser.sharedInstance.perfromDetailInfoParse(responseData: json)
            
            self.songs = tracksArray
            self.detailInfo = parsedDetailData
            
            self.tableView.reloadData()
            
        })
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
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
        
        //Configure cell
        
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
            let songCell = tableView.dequeueReusableCell(withIdentifier: self.songIdentifier, for: indexPath) as! SongCell
            let track = self.songs[indexPath.row]
            songCell.trackNameLabel?.text = track.trackName
            songCell.numberOfTrackLabel.text = String(indexPath.row + 1)
            return songCell
            
        default: break
            
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "")!
        return cell
    }
    
    // MARK: Table view delegate
    
    
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
