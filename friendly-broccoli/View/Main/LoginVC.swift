//
//  LoginVC.swift
//  EASY
//
//  Created by Rohit Saini on 13/01/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//


import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet var backView: UIView!
    @IBOutlet weak var forgotBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var loginBtnLbl: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var loginVM: LoginViewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- configUI
    private func configUI(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.setHidesBackButton(true, animated:true)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        loginBtnLbl.sainiCornerRadius(radius: loginBtnLbl.frame.height / 2)
        loginBtnLbl.sainiGradientColor(colorArr: COLOR.appGredienColor, vertical: false)
        signUpBtn.sainiCornerRadius(radius: signUpBtn.frame.height / 2)
        signUpBtn.layer.borderColor = colorFromHex(hex: "#FF5936").cgColor
        signUpBtn.layer.borderWidth = 2
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
   
    
    
    //MARK:- Login
    @IBAction func clickLoginBtn(_ sender: UIButton) {
        sender.sainiShake()
        login()
    }
    //MARK:- Forgot Password
    @IBAction func clickForgotBtn(_ sender: UIButton) {
        sender.sainiShake()
    }
    
    //MARK:- clickToSignUpBtn
    @IBAction func clickToSignUpBtn(_ sender: UIButton) {
        
      let vc : Register = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "Register") as! Register
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Login
    func login(){
        loginVM.loginUser(email: emailTxt.text!, password: passwordTxt.text!) { (error) in
            if error != nil{
                showAlertwithTitle(title: "Error", desc: error!, vc: self)
            }
            else{
                AppDelegate().sharedDelegate().navigateToDashboard()
            }
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
