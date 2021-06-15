//
//  Register.swift
//  EASY
//
//  Created by Rohit Saini on 13/01/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//


import UIKit

class Register: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
  
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    fileprivate var currentVC: UIViewController!
    
    var registerVM: RegisterViewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        
        // Do any additional setup after loading the view.
    }
    
  
    
    //MARK:- METHODS
    //MARK:- customization
    private func configUI(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.setHidesBackButton(true, animated:true)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        title = "Sign Up"
        profilePic.circleCorner()
        RegisterBtnCustomization()
        profileTapGesture()
    }
    
    
   
    
    //MARK:- Register Button Customization
    func RegisterBtnCustomization(){
        registerBtn.sainiCornerRadius(radius: registerBtn.frame.height / 2)
        registerBtn.sainiGradientColor(colorArr: COLOR.appGredienColor, vertical: false)
    }
    //MARK:-
    //MARK:- IMAGE PICKER METHODS
    
    func profileTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(tap)
        
    }//Tap on Profile image
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        uploadImage()
    }//Show action Sheet
    
    
    // MARK: - Upload Image
    @objc func uploadImage()
    {
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheet.addAction(cancelButton)
        
        let cameraButton = UIAlertAction(title: "Take Photo", style: .default)
        { _ in
            print("Camera")
            self.onCaptureImageThroughCamera()
        }
        
        
        actionSheet.addAction(cameraButton)
        
        
        
        let galleryButton = UIAlertAction(title: "Choose Existing Photo", style: .default)
        { _ in
            print("Gallery")
            self.onCaptureImageThroughGallery()
        }
        actionSheet.addAction(galleryButton)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc open func onCaptureImageThroughCamera()
    {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            displayToast("Your device has no camera")
            
        }
        else {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = .camera
            imgPicker.allowsEditing = true
            UIViewController.top?.present(imgPicker, animated: true, completion: {() -> Void in
            })
        }
    }
    
    @objc open func onCaptureImageThroughGallery()
    {
        self.dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = .photoLibrary
            imgPicker.allowsEditing = true
            UIViewController.top?.present(imgPicker, animated: true, completion: {() -> Void in
            })
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: {() -> Void in
        })
        
        let selectedImage: UIImage? = (info[UIImagePickerController.InfoKey.editedImage] as! UIImage)
        if selectedImage == nil {
            return
        }
        
        self.profilePic.image = selectedImage
    }
    
    
    
    @IBAction func clickRegisterBtn(_ sender: UIButton) {
        sender.sainiPulsate()
        register()
    }
    
    
    //MARK:- Register
    func register(){
        registerVM.registerUser(withName: nameTxt.text!, email: emailTxt.text!, password: passwordTxt.text!, phoneNumber: "+91" + "9999999999", profilePic: profilePic.image ?? UIImage()) { (error) in
            if error != nil{
                showAlertwithTitle(title: "Error", desc: error!, vc: self)
            }
            else{
               let Login = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                let alert = UIAlertController(title: "Verification", message: "A verification mail has been sent to your registered mail id please verify the email.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (result) in
                    self.navigationController?.pushViewController(Login, animated: true)

                }))

                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }//Register
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
