//
//  AlbumCollectionVC.swift
//  ForaSoftEvaluationTest
//
//  Created by Danil on 23.01.18.
//  Copyright © 2018 @Danil. All rights reserved.
//

import UIKit
import Alamofire

class AlbumCollectionVC: UICollectionViewController, UISearchBarDelegate {
    
    
    private var albumsDataCollection = [AlbumBasicInfo]()
    
    private let reuseIdentifier = "AlbumCell"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var responseData = Data() {
        didSet {
            
            let json:Data? = responseData
            
            self.albumsDataCollection = JSONResponseParser.sharedInstance.performBasicAlbumParse(responseData: json)
            
            self.collectionView?.reloadData()
            
        }
    }
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup Search Controller
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesSearchBarWhenScrolling = true
        self.navigationItem.searchController = searchController
        searchController.searchBar.returnKeyType = UIReturnKeyType.search
        self.searchController.searchBar.delegate = self
        
        
        let initialArtistArray = ["468749","5723"]
        
        NetworkManager.sharedInstance.getAlbumsById(artistIdArray: initialArtistArray, completion:{ (data) in
            
            self.responseData = data!
        })
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (self.albumsDataCollection.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumCell
        
        
        
        // Configure the cell
        
        if (self.albumsDataCollection.count > 0)
        {
            
            let tempAlbumData = self.albumsDataCollection[indexPath.row]
            
            let imageURL = tempAlbumData.artBookURL
            
            NetworkManager.sharedInstance.getImageByUrl(imageURL:imageURL, completion: { (responseImage) in
                
                let image = responseImage
                cell.albumImageView.image = image
                
                self.albumsDataCollection[indexPath.row].artBookImage = image
                
            })
            cell.layer.cornerRadius = 15
            cell.albumNameLabel.text = tempAlbumData.albumName
            cell.artisNameLabel.text = tempAlbumData.artistName
        }
        
        return cell
    }
    
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = self.collectionView!.indexPath(for: cell)
        let selectedCell = indexPath?.row
        let passAlbumBasicData = self.albumsDataCollection[selectedCell!]
        if let destinationViewController = segue.destination as? AlbumDetailTableVC {
            destinationViewController.basicInfo = passAlbumBasicData
        }
    }
    
    // MARK: Actions
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        guard let term = searchBar.text , term.isEmpty == false else {
            
            return
        }
        
        let textForSearch = self.searchController.searchBar.text!
        
        perfromSearchAlbumRequest(textForSearch:textForSearch )
        
        self.albumsDataCollection.removeAll()
        
        self.collectionView?.reloadData()
        
    }
    
    // MARK: Network requests
    
    func perfromSearchAlbumRequest(textForSearch:String)  {
        
        let newSearchString = textForSearch.replacingOccurrences(of: " ", with: "+")
        
        NetworkManager.sharedInstance.getAlbumsBySearchTerm(searchTerm:newSearchString, completion:{ (data) in
            
            self.responseData = data!
        })
    }
}
