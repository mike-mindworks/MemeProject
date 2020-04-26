//
//  ViewController.swift
//  MemeTestProject
//
//  Created by Mike Allan on 2020-04-10.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    var currentTextField: UITextField?
    
    let memeMeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -Float(3)
    ]
    
    let DEFAULT_TOP_TEXT = "TOP"
    let DEFAULT_BOTTOM_TEXT = "BOTTOM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.sendButton.isEnabled = false
        
        setTextFieldDefaults(self.topTextField, DEFAULT_TOP_TEXT)
        setTextFieldDefaults(self.bottomTextField, DEFAULT_BOTTOM_TEXT)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.topTextField {
            if let topText = self.topTextField.text, topText==DEFAULT_TOP_TEXT {
                self.topTextField.text = ""
            }
            self.currentTextField = self.topTextField
            return
        }
        if textField == self.bottomTextField {
            if let bottomText = self.bottomTextField.text, bottomText==DEFAULT_BOTTOM_TEXT {
                self.bottomTextField.text = ""
            }
            self.currentTextField = self.bottomTextField
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.imageView.image = image
            requiredFieldsNotEmpty(sender: picker)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromLibrary(_ sender: Any) {
        pickFromSource(.photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        pickFromSource(.camera)
    }
    
    @IBAction func cancel() {
        self.imageView.image=nil
        self.topTextField.text=DEFAULT_TOP_TEXT
        self.bottomTextField.text=DEFAULT_BOTTOM_TEXT
        self.sendButton.isEnabled=false
    }
    
    @IBAction func share(_ sender: Any) {
        let items = [generateMemedImage()]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activityType, completed, returnedItems, error) in
            if (completed) {
                self.save()
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func setTextFieldDefaults(_ textField: UITextField, _ defaultText: String) {
        textField.defaultTextAttributes = memeMeTextAttributes
        textField.textAlignment = .center
        textField.text = defaultText
        textField.delegate = self
        textField.addTarget(self, action: #selector(requiredFieldsNotEmpty), for: .editingChanged)
    }
    
    func pickFromSource(_ source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    func save() {
        _ = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imageView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        self.topToolbar.isHidden = true
        self.bottomToolbar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.topToolbar.isHidden = false
        self.bottomToolbar.isHidden = false
        
        return memedImage
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let current = self.currentTextField {
            if current == self.bottomTextField {
                view.frame.origin.y -= getKeyboardHeight(notification)
                self.cameraButton.isEnabled = false;
                self.albumButton.isEnabled = false;
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let current = self.currentTextField {
            if current == self.bottomTextField {
                view.frame.origin.y = 0
                self.cameraButton.isEnabled = true
                self.albumButton.isEnabled = true
            }
        }
    }
    
    @objc func requiredFieldsNotEmpty(sender: Any) {
        guard
            let topText = topTextField.text, !topText.isEmpty,
            let bottomText = bottomTextField.text, !bottomText.isEmpty,
            let _ = imageView.image
            else {
                self.sendButton.isEnabled = false
                return
        }
        self.sendButton.isEnabled = true
        
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        return keyboardSize.size.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

