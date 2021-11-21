//
//  ViewController.swift
//  Messager
//
//  Created by Harry Nguyen on 20/11/2021.
//

import UIKit
import SwiftUI
import AudioToolbox
import MessageKit

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    //labels
    @IBOutlet weak var emailLabelOutlet: UILabel!
    @IBOutlet weak var passwordLabelOutlet: UILabel!
    @IBOutlet weak var repeatPasswordLabelOutlet: UILabel!
    @IBOutlet weak var doNothaveAccountOutlet: UILabel!
    @IBOutlet weak var loginLabelOutlet: UILabel!
    
    //textFields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
    //buttons
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgotPassBtn: UIButton!
    @IBOutlet weak var resendEmailBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    //views
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var repeatPasswordView: UIView!
    
    //parentView
    @IBOutlet var parentView: UIView!
    
    //MARK: - vars
    var isLogin = true
    
    //MARK: - View lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
            setupTextFieldDelegate()
            updateUIFor(login: true)
    }

    //IBActions
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
    
    }
    
    
    @IBAction func resendEmailBtnPressed(_ sender: Any) {
    
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == "LogIn")
        isLogin.toggle()
    }
    
    //MARK: - Setup
    private func setupTextFieldDelegate(){
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_ :)),
                                 for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_ :)),
                                 for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_ :)),
                                 for: .editingChanged)
    
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        updatePlaceholderLabels(textField: textField)
    }
    
    //MARK: - Animation
    private func updatePlaceholderLabels(textField: UITextField){
        switch textField {
            case emailTextField:
                emailLabelOutlet.text = textField.hasText ? "Email" : " "
                break
            case passwordTextField:
                passwordLabelOutlet.text = textField.hasText ? "Password" : " "
                break
            default:
                repeatPasswordLabelOutlet.text = textField.hasText ? "Repeate Password" : " "
        }
    }
    
    private func updateUIFor(login: Bool){
        loginBtn.setImage(
            UIImage(named: login ? "loginBtn" : "registerBtn" ),
            for: .normal
        )
        signUpBtn.setTitle(login ? "SignUp" : "LogIn",
            for: .normal
        )
        doNothaveAccountOutlet.text = login ? "Don't have an account ?" : "Have an account"
        loginLabelOutlet.text = login ? "LogIn" : "SignUp"
        UIView.animate(withDuration: 0.5) {
            self.repeatPasswordTextField.isHidden = login
            self.repeatPasswordLabelOutlet.isHidden = login
            self.repeatPasswordView.isHidden = login
        }
        
    }
    
}

