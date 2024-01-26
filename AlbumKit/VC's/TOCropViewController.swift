//
//  TOCropViewController.swift
//  SticKit
//
//  Created by Alper Canımoğlu on 25.12.2023.
//

import UIKit
import CoreImage
import CropViewController
import CoreData

class TOCropViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate {
    
    @IBOutlet private weak var croppedImage : UIImageView!
    @IBOutlet private weak var filterSegmentButton : UIButton!
    @IBOutlet private weak var saveButtonOutlet: UIButton!
    private var filterRemovedImage : UIImage?
    var selectedCropAlbum : Album?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButtonOutlet.layer.cornerRadius = 10
        
        addFilterTappedButton()

        imagePicker()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imagePicker))
        self.croppedImage.isUserInteractionEnabled = true
        self.croppedImage.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func imagePicker(){
        //image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true)
        
        showCrop(image: image)
    }
    
    func showCrop(image: UIImage){
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = true
        vc.toolbarPosition = .top
        vc.doneButtonTitle = "Done"
        vc.cancelButtonTitle = "Quit"
        vc.doneButtonColor = UIColor.systemBlue
        vc.cancelButtonColor = UIColor.systemRed
        vc.delegate = self
        
        present(vc, animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true)
        print("Did crop?")
        
        self.croppedImage.contentMode = .scaleAspectFit
        self.croppedImage.image = image
    }
    
    func saveNewImage(croppedImage: UIImage) {
        guard let chosenAlbum = selectedCropAlbum else { return }
        
        let newPhoto = Photo(context: context)
        if let photoData = self.croppedImage.image!.jpegData(compressionQuality: 0.5) {
            newPhoto.photo = photoData
            newPhoto.photoID = UUID()
            newPhoto.album = selectedCropAlbum
            selectedCropAlbum?.addToPhotos(newPhoto)
            
            do {
                try context.save()
                print("saved successfully")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func saveCroppedImageButtonTapped(_ sender: Any) {
        if let lastImage = croppedImage.image {
            saveNewImage(croppedImage: lastImage)
        }
        dismiss(animated: true)
    }
    
    @IBAction func clearImage(_ sender: Any) {
        croppedImage.image = UIImage(named: "")
    }
    
    @IBAction func canceluttonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func applyFilter(to image: UIImage, filterName: String) -> UIImage? {
        if let filter = CIFilter(name: filterName) {
                let ciImage = CIImage(image: image)
                filter.setValue(ciImage, forKey: kCIInputImageKey)

                guard let outputCIImage = filter.outputImage else {
                    return nil
                }

                let outputImage = UIImage(ciImage: outputCIImage)
                return outputImage
            }
            return nil
    }
    
    func addFilterTappedButton() {
        
        let optionClosure = {(action : UIAction) in
            
            if let originalImage = self.croppedImage.image {
                // do nothing
            }
        }
        
//        let optionClosureRemove = {(action : UIAction) in
//            
//            if let originalImage = self.croppedImage.image {
//                self.croppedImage.image = originalImage
//            }
//        }
                
        let optionClosureChrome = {(action : UIAction) in

            if let originalImage = self.croppedImage.image, let filteredImage = self.applyFilter(to: originalImage, filterName: "CIPhotoEffectChrome") {
                self.croppedImage.image = filteredImage
            }
        }
        
        let optionClosureFade = {(action : UIAction) in
            
            if let originalImage = self.croppedImage.image, let filteredImage = self.applyFilter(to: originalImage, filterName: "CIPhotoEffectFade") {
                self.croppedImage.image = filteredImage
            }
        }
        
        let optionClosureInstant = {(action : UIAction) in
            
            if let originalImage = self.croppedImage.image, let filteredImage = self.applyFilter(to: originalImage, filterName: "CIPhotoEffectInstant") {
                self.croppedImage.image = filteredImage
            }
        }
        
        let optionClosureMono = {(action : UIAction) in
            
            if let originalImage = self.croppedImage.image, let filteredImage = self.applyFilter(to: originalImage, filterName: "CIPhotoEffectMono") {
                self.croppedImage.image = filteredImage
            }
        }
        
        let optionClosureProcess = {(action : UIAction) in
            
            if let originalImage = self.croppedImage.image, let filteredImage = self.applyFilter(to: originalImage, filterName: "CIPhotoEffectProcess") {
                self.croppedImage.image = filteredImage
            }
        }
        
        let optionClosureTonal = {(action : UIAction) in
            
            if let originalImage = self.croppedImage.image, let filteredImage = self.applyFilter(to: originalImage, filterName: "CIPhotoEffectTonal") {
                self.croppedImage.image = filteredImage
            }
        }
        
        let optionClosureTransfer = {(action : UIAction) in
            
            if let originalImage = self.croppedImage.image, let filteredImage = self.applyFilter(to: originalImage, filterName: "CIPhotoEffectTransfer") {
                self.croppedImage.image = filteredImage
            }
        }
        
        let optionClosureNoir = {(action : UIAction) in
            
            if let originalImage = self.croppedImage.image, let filteredImage = self.applyFilter(to: originalImage, filterName: "CIPhotoEffectNoir") {
                self.croppedImage.image = filteredImage
            }
        }
        
        filterSegmentButton.menu = UIMenu(children : [
            UIAction(title: "Filters", state: .on, handler: optionClosure),
            UIAction(title: "Chrome", handler: optionClosureChrome),
            UIAction(title: "Fade", handler: optionClosureFade),
            UIAction(title: "Instant", handler: optionClosureInstant),
            UIAction(title: "Mono", handler: optionClosureMono),
            UIAction(title: "Process", handler: optionClosureProcess),
            UIAction(title: "Tonal", handler: optionClosureTonal),
            UIAction(title: "Transfer", handler: optionClosureTransfer),
            UIAction(title: "Noir", handler: optionClosureNoir),
//            UIAction(title: "Remove", handler: optionClosureRemove),
        ])
        
        filterSegmentButton.showsMenuAsPrimaryAction = true
        filterSegmentButton.changesSelectionAsPrimaryAction = true
    }
}
