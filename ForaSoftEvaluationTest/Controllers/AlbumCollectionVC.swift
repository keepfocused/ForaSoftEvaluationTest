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
    
    
    private var albumsDataCollection = [albumBasicInfo]()
    
    private let reuseIdentifier = "AlbumCell"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var responseData = Data() {
        didSet {
            
            let json:Data? = responseData
            
            let parser = JSONResponseParser()
            
            self.albumsDataCollection = parser.performBasicAlbumParse(responseData: json)
            
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
        performGetSomeAlbumsRequest(artistIdArray: initialArtistArray)
        
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
        
        let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumCell
        
        
    
        // Configure the cell
        
        if (self.albumsDataCollection.count > 0)
        {
            
            
            let tempAlbumData = self.albumsDataCollection[indexPath.row]
            
            let imageURL = tempAlbumData.artBookURL
            Alamofire.request(imageURL).responseJSON(){(data) in
                
                let tempData = data.data!
                
                let image = UIImage(data: tempData)
                cell3.albumImageView.image = image
                
                
                self.albumsDataCollection[indexPath.row].artBookImage = image
                
            }
            cell3.layer.cornerRadius = 15
            cell3.albumNameLabel.text = tempAlbumData.albumName
            cell3.artisNameLabel.text = tempAlbumData.artistName
        }
    
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
        
        print("button search pressed, dffirent place text = \(textForSearch)")
        
        self.albumsDataCollection.removeAll()
        
        self.collectionView?.reloadData()
        
    }
    
    // MARK: Network requests
    
    func performGetSomeAlbumsRequest(artistIdArray:Array<String>) {
        
        let artistIdValue = artistIdArray.joined(separator: ",")
        
        
        Alamofire.request("https://itunes.apple.com/lookup?amgArtistId=\(artistIdValue)&entity=album&limit=50").responseJSON(){(data) in
            
            let json:Data? = data.data
            
            self.responseData = json!
            
        }
    }
    
    func perfromSearchAlbumRequest(textForSearch:String)  {
        
        var newSearchString = textForSearch.replacingOccurrences(of: " ", with: "+")
        
        Alamofire.request("https://itunes.apple.com/search?term=\(newSearchString)&media=music&entity=album&attribute=albumTerm").responseJSON(){(data) in
            
            let json:Data? = data.data
            
            self.responseData = json!
        }
    }
}
