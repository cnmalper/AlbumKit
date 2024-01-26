//
//  StickerCollectionViewController.swift
//  SticKit
//
//  Created by Alper Canımoğlu on 15.12.2023.
//

import UIKit
import CropViewController
import CoreData

class StickerCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet private weak var stickerPackNameLabel: UILabel!
    @IBOutlet private weak var allTheStickersLabel: UILabel!
    @IBOutlet private weak var stickerCollectionView: UICollectionView!
    @IBOutlet private weak var addNewStickButtonOutlet: UIButton!
    var selectedCollectionAlbum : Album?
    var photosItemList = [Photo]()
    var uiImageList = [UIImage]()
    var selectedImage: UIImage?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stickerCollectionView.dataSource = self
        stickerCollectionView.delegate = self
        addNewStickButtonOutlet.layer.cornerRadius = 10
        stickerCollectionView.reloadData()
        
        if let albumText = selectedCollectionAlbum?.albumName as? String {
            stickerPackNameLabel.text = albumText
        }
        if let selectedNewAlbum = selectedCollectionAlbum {
            retrieveDataToCollection(chosenCollectionAlbum: selectedNewAlbum)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.stickerCollectionView.reloadData()
        if let selectedNewAlbum = selectedCollectionAlbum {
            retrieveDataToCollection(chosenCollectionAlbum: selectedNewAlbum)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddNewStick" {
            let destinationTOCropVC = segue.destination as! TOCropViewController
            destinationTOCropVC.selectedCropAlbum = self.selectedCollectionAlbum
        }
        
        else if segue.identifier == "toFullView" {
            let destinationFullviewVC = segue.destination as! FullImageViewController
            destinationFullviewVC.chosenImage = self.selectedImage
        }
    }
    
    func retrieveDataToCollection(chosenCollectionAlbum: Album){
        do {
            self.photosItemList.removeAll(keepingCapacity: false)
            let fetchRequest : NSFetchRequest<Photo> = Photo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "album == %@", chosenCollectionAlbum)
            self.photosItemList = try context.fetch(fetchRequest)
            
            for photo in photosItemList {
                if let photoData = photo.value(forKey: "photo") as? Data {
                    let image = UIImage(data: photoData)
                    self.uiImageList.append(image!)
                }
            }
            
            DispatchQueue.main.async {
                self.stickerCollectionView.reloadData()
            }
        } catch {
            print("Error!-retrieveDataToCollection")
        }
    }
    
    // MARK - CollectionView Protocols
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let stickerCell = stickerCollectionView.dequeueReusableCell(withReuseIdentifier: "stickerCollectionCell", for: indexPath) as! StickerCollectionViewCell
        let photo = self.uiImageList[indexPath.row]
        stickerCell.stickerImage.image = photo
        
        stickerCell.stickerImage.layer.cornerRadius = 10
        return stickerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = self.uiImageList[indexPath.row]
        performSegue(withIdentifier: "toFullView", sender: nil)
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func addNewStickTappedButton(_ sender: Any) {
        performSegue(withIdentifier: "goToAddNewStick", sender: nil)
    }
}
