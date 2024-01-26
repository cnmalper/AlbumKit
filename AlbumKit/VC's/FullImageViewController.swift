//
//  FullImageViewController.swift
//  AlbumKit
//
//  Created by Alper Canımoğlu on 23.01.2024.
//

import UIKit

class FullImageViewController: UIViewController {

    @IBOutlet weak var fullImageView: UIImageView!
    var chosenImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fullImageView.contentMode = .scaleAspectFit
        fullImageView.image = chosenImage
    }
    
    func makeAlert(){
        let doneAlert = UIAlertController(title: "Saved", message: "successfully!", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        doneAlert.addAction(okAction)
        self.present(doneAlert, animated: true)
    }
    
    @IBAction func exitFullView(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func savetoLibraryTappedButton(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(chosenImage!, nil, nil, nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.makeAlert()
        }
    }
}
