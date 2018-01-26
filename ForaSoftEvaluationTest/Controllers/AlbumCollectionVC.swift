//
//  AlbumCollectionVC.swift
//  ForaSoftEvaluationTest
//
//  Created by Danil on 23.01.18.
//  Copyright © 2018 @Danil. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "AlbumCell"

class AlbumCollectionVC: UICollectionViewController {
    
    var artBook:[String]? = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
//        Alamofire.request(.GET, "https://api.500px.com/v1/photos").responseJSON() {
//            (_, _, data, _) in
//            print(data)
//        }
        
     //    https://itunes.apple.com/search?term=jack+johnson
        
        Alamofire.request("https://itunes.apple.com/search?term=jack+johnson").responseJSON(){(data) in
            
            
            //print(data)
            
            var json:Data? = nil
            
            if let result =  data.data {
                let tempJson = result as! Data
                
               // print("Test sest test data json")
               // print(tempJson)
                
                json = tempJson
            }
            
                
                
                var links = [String]()
                
                do {
                    if let data = json,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let blogs = json["results"] as? [[String: Any]] {
                        for blog in blogs {
                            if let url = blog["artworkUrl60"] as? String {
                                links.append(url)
                                
                            }
                        }
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                print("Try to parse json for image urls")
                print(links)
            
            self.artBook = links
            
            print("links count = \(links.count)")
            
            self.collectionView?.reloadData()

                
            
            

//
            



        
            
        
        }
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
//        let data:Data? = nil
//
//        var names = [String]()
//        
//        do {
//            if let data = data,
//                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
//                let blogs = json["blogs"] as? [[String: Any]] {
//                for blog in blogs {
//                    if let name = blog["name"] as? String {
//                        names.append(name)
//                    }
//                }
//            }
//        } catch {
//            print("Error deserializing JSON: \(error)")
//        }
//        
//        print(names)
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
        print(self.artBook?.count)
        return (self.artBook?.count)!
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumCell
        
        
    
        // Configure the cell
        
        let imageURL = self.artBook?[indexPath.row]
        Alamofire.request(imageURL!).responseJSON(){(data) in
    
    let tempData = data.data as! Data

            let image = UIImage(data: tempData)
            cell3.albumImageView.image = image
        }

        
        
        cell.backgroundColor = UIColor.red
        
        //self.collectionView?.reloadData()
    
        return cell3
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}
