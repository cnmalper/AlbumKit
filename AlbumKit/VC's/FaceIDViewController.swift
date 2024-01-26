//
//  FaceIDViewController.swift
//  SticKit
//
//  Created by Alper Canımoğlu on 16.12.2023.
//

import UIKit
import LocalAuthentication

class FaceIDViewController: UIViewController {

    @IBOutlet private weak var lockImage: UIImageView!
    @IBOutlet private weak var logoImageHashtag: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        faceID()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.logoImageHashtag.addSymbolEffect(.bounce, animated: true)
        }
    }

    func faceID(){

        let authContext = LAContext()
        var error : NSError?
        if authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error){
            authContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Is it you?") { (success, error) in
                if success == true {
                    DispatchQueue.main.async {
                        self.logoImageHashtag.tintColor = UIColor.systemGreen
                        self.performSegue(withIdentifier: "lockFaceID", sender: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.logoImageHashtag.tintColor = UIColor.systemPink
                        self.logoImageHashtag.addSymbolEffect(.bounce, animated: false)
                    }
                }
            }
        }
    }
    
    @IBAction func viewStickitTappedButton(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.logoImageHashtag.addSymbolEffect(.bounce, animated: true)
        }
        
        faceID()
    }
}
