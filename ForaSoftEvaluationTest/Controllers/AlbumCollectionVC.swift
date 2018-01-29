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
    
   private var artBook = [String]()
   private var artistNames = [String]()
   private var albumNames = [String]()
   private var albumsID = [String]()
   private let reuseIdentifier = "AlbumCell"
   private var selectedCell = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        
     //    https://itunes.apple.com/lookup?amgArtistId=468749,5723&entity=album&limit=50
        
        //search album by text
//        Alamofire.request("https://itunes.apple.com/search?term=TEXT&attribute=albumTerm").responseJSON(){(data) in
        
        
        
        //golden hit best top platinum Heart & Soul  Love you  My hot dream Feel American life

        Alamofire.request("https://itunes.apple.com/lookup?amgArtistId=468749,5723&entity=album&limit=50").responseJSON(){(data) in
        
            
        //    print(data)
            
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
                        let blogs = json["results"] as? [[String: Any]] {
                        for blog in blogs {
                            if let url = blog["artworkUrl100"] as? String {
                                self.artBook.append(url)
                                
                            }
                            if let artistName = blog["artistName"] as? String {
                                self.artistNames.append(artistName)
                                
                            }
                            if let albumName = blog["collectionName"] as? String {
                                self.albumNames.append(albumName)
                            }
                            if let albumId = blog["artistId"] as? Int {
                                self.albumsID.append(String(albumId))
                                //print("AAAAAAAAAAAAAAAAAAAAAAAAAAAA")
                              //  print("album id = \(albumId)")
                            }
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
        
        print("count of rows = ")
        print(self.artBook.count)
        return (self.artBook.count)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumCell
        
        
    
        // Configure the cell
        
        let imageURL = self.artBook[indexPath.row]
        Alamofire.request(imageURL).responseJSON(){(data) in
    
    let tempData = data.data as! Data

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
