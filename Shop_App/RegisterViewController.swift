//
//  RegisterViewController.swift
//  Shop_App
//
//  Created by Demo on 20.01.2019.
//  Copyright © 2019 Demo. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var dogrulamaKodu: UITextField!
    @IBOutlet weak var requestBtn: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    @IBAction func requestBtnPressed(_ sender: Any) {
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        
        if emailTextField.text != nil, passTextField.text != nil, nameTextField.text != nil, lastNameTextField.text != nil {
            
            FUser.regiterUserWithEmail(email: emailTextField.text!, firstname: nameTextField.text!, lastname: lastNameTextField.text!, password: passTextField.text!, completion: { (error) in
                
                if(error != nil) {
                    
                    print("registerWith email kısmında bir hata meydana geldi:\(error?.localizedDescription)")
                    
                    // hata olursa aşağıdaki satırlar icra edilmeyecek
                    return
                }
                
               self.gotoMain()
                
                
            })
            
        }
        
        
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        
        gotoMain()
        
    }
    
    //Mark: Helper Functions
    
    func gotoMain() {
        
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC") as! UITabBarController
        
        self.present(mainView, animated: true, completion: nil)
   
    }
    

}
