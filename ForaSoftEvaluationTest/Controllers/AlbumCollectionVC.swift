//
//  AlbumCollectionVC.swift
//  ForaSoftEvaluationTest
//
//  Created by Danil on 23.01.18.
//  Copyright © 2018 @Danil. All rights reserved.
//

import UIKit
import Alamofire



class AlbumCollectionVC: UICollectionViewController {
    
    private var albumsDataCollection = [albumBasicInfo]()
    
    
    private let reuseIdentifier = "AlbumCell"
    private var selectedCell = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        
        Alamofire.request("https://itunes.apple.com/lookup?amgArtistId=468749,5723&entity=album&limit=50").responseJSON(){(data) in
            
            
            //print(data)
            
            var json:Data? = nil
            
            //if let result =  data.data {
            // let tempJson = result as! Data
            
            // print("Test sest test data json")
            // print(tempJson)
            
            //   json = tempJson
            // }
            let tempData = data.data
            
            json = tempData
            

                
                do {
                    if let data = json,
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
                            if let albumId = attribute["artistId"] as? Int {
                                basicAlbumData.albumID = albumID
                            }
                            self.
                        }
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                }

            
            self.collectionView?.reloadData()
        }
        
       // print("collection id array = \(self.albumsID)")
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        

        print(self.artBook.count)
        return (self.artBook.count)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumCell
        
        
    
        // Configure the cell
        
        let imageURL = self.artBook[indexPath.row]
        Alamofire.request(imageURL).responseJSON(){(data) in
    
    let tempData = data.data!

            let image = UIImage(data: tempData)
            cell3.albumImageView.image = image
        }
        
        cell3.albumNameLabel.text = self.albumNames[indexPath.row]
        cell3.artisNameLabel.text = self.artistNames[indexPath.row]

        
        
        cell.backgroundColor = UIColor.red
        
        //self.collectionView?.reloadData()
    
        return cell3
    }

    // MARK: UICollectionViewDelegate

    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        self.selectedCell = indexPath.row
        let segueIdentifier = "albumDetailInfo"
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("collection id array = \(self.albumsID)")
        let passAlbumId = self.albumsID[self.selectedCell]
        if let destinationViewController = segue.destination as? AlbumDetailTableVC {
            destinationViewController.albumId = passAlbumId
        }
    }

}
