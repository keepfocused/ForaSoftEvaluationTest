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
    
    lazy   var searchBar:UISearchBar = UISearchBar()//(frame: CGRect(x: 0,y: 0,width: 375,height: 50))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  navigationItem.titleView = searchbar
        
        
        
        searchBar.placeholder = "Search albums"
        var leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        



        
        Alamofire.request("https://itunes.apple.com/lookup?amgArtistId=468749,5723&entity=album&limit=50").responseJSON(){(data) in
            
            
            //print(data)
            
            var json:Data? = nil
            
            let tempData = data.data
            
            json = tempData
            
            let parser = JSONResponseParser()
            
            self.albumsDataCollection = parser.performBasicAlbumParse(responseData: json)
            

 
            self.collectionView?.reloadData()
        }
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        

        //print(self.artBook.count)
        return (self.albumsDataCollection.count)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumCell
        
        
    
        // Configure the cell
        
        let tempAlbumData = self.albumsDataCollection[indexPath.row]
        
        let imageURL = tempAlbumData.artBookURL
        Alamofire.request(imageURL).responseJSON(){(data) in
    
    let tempData = data.data!

            let image = UIImage(data: tempData)
            cell3.albumImageView.image = image
            self.albumsDataCollection[indexPath.row].artBookImage = image
        }
        
        cell3.albumNameLabel.text = tempAlbumData.albumName
        cell3.artisNameLabel.text = tempAlbumData.artistName
        
        
        //self.collectionView?.reloadData()
    
        return cell3
    }

    // MARK: UICollectionViewDelegate

    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        let segueIdentifier = "albumDetailInfo"
        performSegue(withIdentifier: segueIdentifier, sender: nil)
        let nextViewController = AlbumDetailTableVC()
        
        navigationController?.pushViewController(nextViewController,
                                                 animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
       // self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = self.collectionView!.indexPath(for: cell)
        let selectedCell = indexPath?.row
        let passAlbumBasicData = self.albumsDataCollection[selectedCell!]
        if let destinationViewController = segue.destination as? AlbumDetailTableVC {
            destinationViewController.basicInfo = passAlbumBasicData
        }
    }
}
