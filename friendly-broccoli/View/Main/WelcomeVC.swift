//
//  WelcomeVC.swift
//  EASY
//
//  Created by Rohit Saini on 18/11/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    //OUTLETS
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigUI()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- ConfigUI
    private func ConfigUI(){
        loginBtn.sainiCornerRadius(radius: loginBtn.frame.height / 2)
        loginBtn.sainiGradientColor(colorArr: [colorFromHex(hex: "#ED6E27").cgColor,colorFromHex(hex: "#FF5936").cgColor], vertical: false)
    }
    
     
    //MARK:- clickToLoginBtn
    @IBAction func clickToLoginBtn(_ sender: UIButton) {
        
        let vc : LoginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
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
