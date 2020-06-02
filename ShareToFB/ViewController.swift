//
//  ViewController.swift
//  ShareToFB
//
//  Created by Sitong Chen on 2020-05-30.
//  Copyright © 2020 Sitong Chen. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit

class ViewController: UIViewController {

    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    let imagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image"]
        imagePickerController.sourceType = .photoLibrary
    }

    @IBAction func pickImage(_ sender: Any) {
        self.present(self.imagePickerController, animated: true) {
        }
    }
    
    
    
    @IBAction func shareToFBFunc(_ sender: Any) {
        if (self.image == nil) {
            self.bodyLabel.text = "Please pick an image first."
            return
        }
        

        let sharePhoto: SharePhoto = SharePhoto()
        sharePhoto.image = image
        sharePhoto.isUserGenerated = true;
        let content: SharePhotoContent = SharePhotoContent()
        content.photos = [sharePhoto]
        

        let shareDialog: ShareDialog = ShareDialog.init(fromViewController: self, content: content, delegate: self)
        shareDialog.mode = .native
        
        if ( shareDialog.canShow ){
            shareDialog.show()
        }
    }
    
    func resetText() {
        self.bodyLabel.text = ""
    }
    
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.bodyLabel.text = "Action cancelled."
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            self.bodyLabel.text = "Image unavailable."
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        self.image = image
        self.imageView.image = image
        
        self.resetText()
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UINavigationControllerDelegate {
    
}

extension ViewController: SharingDelegate {
    func sharerDidCancel(_ sharer: Sharing) {
        self.bodyLabel.text = "sharerDidCancel"
        print("sharerDidCancel")
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        self.bodyLabel.text = "didFailWithError"

        print("didFailWithError", error)

    }
    
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        self.resetText()
        print("didCompleteWithResults", results)
        self.bodyLabel.text = "didCompleteWithResults"
    }
}
