//
//  ViewController.swift
//  SticKit
//
//  Created by Alper Canımoğlu on 14.12.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var stickitLabel: UILabel!
    @IBOutlet private weak var stickerPackTableView: UITableView!
    @IBOutlet private weak var appLogoImageView: UIImageView!
    
    private var albumList = [Album]()
    private var selectedAlbum : Album?
    private var idList = [UUID]()
    private var myNewStickPack : String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stickerPackTableView.delegate = self
        stickerPackTableView.dataSource = self
        appLogoImageView.layer.cornerRadius = 10
        
        stickerPackTableView.reloadData()
        getData()
    }
    
    func getData(){
        do {
            self.albumList = try context.fetch(Album.fetchRequest())
            
            DispatchQueue.main.async {
                self.stickerPackTableView.reloadData()
            }
        } catch {
            print("Error-getData!")
        }
    }
    
    func createNewAlbum(albumName: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newAlbum = Album(context: context)
        newAlbum.albumName = self.myNewStickPack
        newAlbum.id = UUID()
        
        do {
            try context.save()
            print("Saved!")
        } catch {
            print(error.localizedDescription)
        }
        self.stickerPackTableView.reloadData()
        getData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStickCollection" {
            let collectionDestinationVC = segue.destination as! StickerCollectionViewController
            collectionDestinationVC.selectedCollectionAlbum = selectedAlbum
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stickerPackCell = stickerPackTableView.dequeueReusableCell(withIdentifier: "stickerPackCell", for: indexPath) as! StickerPackTableViewCell
        let album = self.albumList[indexPath.row]
        stickerPackCell.stickerPackLabel.text = album.albumName
        if let photoCount = album.photos?.count {
            stickerPackCell.stickerPackItemCountLabel.text = "\(photoCount) items"
        }
        stickerPackCell.stickerPackImage.layer.cornerRadius = 10
        return stickerPackCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedAlbum = self.albumList[indexPath.row]
        performSegue(withIdentifier: "toStickCollection", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let albumtoRemove = self.albumList[indexPath.row]
            if let photos = albumtoRemove.photos {
                for photo in photos {
                    context.delete(photo as! NSManagedObject)
                }
            }
                    
            context.delete(albumtoRemove)
                    
            do {
                try context.save()
                self.albumList.remove(at: indexPath.row)
                self.stickerPackTableView.reloadData()
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func addNewStickPackButtonTapped(_ sender: Any) {
        
        let popUp = UIAlertController(title: "New Album", message: nil, preferredStyle: UIAlertController.Style.alert)
        popUp.addTextField { (textField) in
            textField.placeholder = "Album Name:"
        }
        
        let saveButtonAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default) {(saveButton) in
            if let stickPackName = popUp.textFields?.first?.text, !stickPackName.isEmpty {
                self.myNewStickPack = stickPackName
                
                // MARK - CoreData
                self.createNewAlbum(albumName: self.myNewStickPack!)
            }
        }
        
        let cancelButtonAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {(cancelButton) in
            //do nothing
        }
        
        cancelButtonAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
        saveButtonAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        
        popUp.addAction(saveButtonAction)
        popUp.addAction(cancelButtonAction)
        self.present(popUp, animated: true)
    }
}
