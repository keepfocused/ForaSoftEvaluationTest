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
    
    var songs = [String]()
    
    
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
            
            print("oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo")
            print("Album detailed data Album detailed data Album detailed data Album detailed data ")
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


        
        do {
            if let data = json,
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let blogs = json["results"] as? [[String: Any]] {
                for blog in blogs {
                    if let trackName = blog["trackName"] as? String {
                        self.songs.append(trackName)
                    }
                    if let
                    
                    
                }
            }
        } catch {
            print("Error deserializing JSON: ")//\(error)")
        }
        
        print("Try to print songs ")
        print(self.songs)
            
            self.tableView.reloadData()

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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let albumImageIdentifier = "albumImage"
        let albumInfoIdentifier = "albumInfo"
        let songIdentifier = "song"
        
        //albumImage    albumInfo   song
        
        switch indexPath.section {
        case 0:
            let albumCell = tableView.dequeueReusableCell(withIdentifier: albumImageIdentifier, for: indexPath) as! AlbumImageCell
           // albumCell.backgor
            return albumCell

           
        case 1:
            let detailCell = tableView.dequeueReusableCell(withIdentifier: albumInfoIdentifier, for: indexPath) as! AlbumDetailCell
            return detailCell

            
        case 2:
            let songCell = tableView.dequeueReusableCell(withIdentifier: songIdentifier, for: indexPath) as! songCell
            songCell.textLabel?.text = self.songs[indexPath.row]
            return songCell

            
        default: break
            
            
        }
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "")!
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
