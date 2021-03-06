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
import ProgressHUD

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
    @IBOutlet weak var logInSignUpButton: UIButton!
    
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
        controlEvents()
    }
    
    //MARK: EVENTS
    private func controlEvents(){
        setupTextFieldDelegate()
        setupBackGroundTap()
        updateUIFor(login: true)

    }

    //IBActions
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        if isDataInputtedFor(type: isLogin ? Contanst.LOGIN : Contanst.REGISTRATION){
            isLogin ? loginUser() : registerUser()
        }else{
            ProgressHUD.showFailed("All fields are required", interaction: false)
        }
    }
    
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
        if isDataInputtedFor(type: Contanst.PASSWORD){
            self.forgotPassword()
        }else{
            ProgressHUD.showFailed("Email is required", interaction: false)
        }
    }
    
    
    @IBAction func resendEmailBtnPressed(_ sender: Any) {
        if isDataInputtedFor(type: Contanst.PASSWORD){
            resendVerificationEmail()
        }else{
            ProgressHUD.showFailed("Email is required", interaction: false)
        }

    }
    
    @IBAction func loginSignUpBtnPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == Contanst.LOGIN)
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
                emailLabelOutlet.text = textField.hasText ? Contanst.EMAIL : " "
                break
            case passwordTextField:
                passwordLabelOutlet.text = textField.hasText ? Contanst.PASSWORD : " "
                break
            default:
                repeatPasswordLabelOutlet.text = textField.hasText ? Contanst.REPEAT_PASSWORD : " "
        }
    }
    
    private func updateUIFor(login: Bool){
        loginBtn.setImage(
            UIImage(named: login ? Contanst.LOGIN_BTN_ASSETS : Contanst.REGISTER_BTN_ASSETS),
            for: .normal
        )
        logInSignUpButton.setTitle(login ? Contanst.SIGNUP : Contanst.LOGIN, for: .normal)
        doNothaveAccountOutlet.text = login ? Contanst.DO_NOT_HAVE_ACCOUNT : Contanst.HAVE_ACCOUNT
        loginLabelOutlet.text = login ? Contanst.LOGIN : Contanst.SIGNUP
        UIView.animate(withDuration: 0.5) {
            self.repeatPasswordTextField.isHidden = login
            self.repeatPasswordLabelOutlet.isHidden = login
            self.repeatPasswordView.isHidden = login
        }
    }
    
    private func setupBackGroundTap(){
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(setOnParentViewTapGesture))
        view.addGestureRecognizer(tapGesture)
                                                    
    }
    
    @objc func setOnParentViewTapGesture(){
        view.endEditing(false)
    }
    
    private func isDataInputtedFor(type: String) -> Bool{
        switch type {
            case Contanst.LOGIN:
                return emailTextField.text != "" && passwordTextField.text != ""
            case Contanst.REGISTRATION:
                return emailTextField.text != "" && passwordTextField.text != ""
                        && repeatPasswordTextField.text != ""
            default:
                return emailTextField.text != ""
        }
    }
    
    private func loginUser() {
        FirebaseUserListener.shared.loginUserWith(
            email: emailTextField.text!, password: passwordTextField.text!) {
                (error, isEmailVerified) in
                if error == nil {
                    if isEmailVerified {
                        self.navigateToMainApp()
                    } else {
                        ProgressHUD.showFailed("Please verify email")
                        self.resendEmailBtn.isHidden = false
                    }
                }else {
                    ProgressHUD.showFailed(error?.localizedDescription)
                }
            }
    }
    
    //MARK: Navigation
    private func navigateToMainApp() {
        let mainView = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "MainApp") as! UITabBarController
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
    }
    
    private func forgotPassword() {
//        FirebaseUserListener.shared.resetPasswordFor(email: emailTextField.text!, completion: {
//            (error) in
//            if error == nil {
//                ProgressHUD.showSuccess("Reset password success")
//            }else {
//                ProgressHUD.showFailed(error?.localizedDescription,
//                                       interaction: true)
//            }
//        })
        
        var queue = DispatchQueue.init(
            label: "Test",
            attributes: .concurrent,
            target: nil
        )
        queue.async {
            let test = 3
            // Call API
            
            // Run callback
            
            queue.asyncAfter(deadline: .now() + 3) {
                DispatchQueue.main.async {
                    self.emailLabelOutlet.text = "\(test)"
                }
            }
            
            
        }

    }
    
    private func resendVerificationEmail() {
        FirebaseUserListener.shared.resendEmailVerification(
            email: emailTextField.text!,
            completion: {
                (error) in
                if error == nil {
                    ProgressHUD.showSuccess("Resend email success")
                }else {
                    ProgressHUD.showFailed(error?.localizedDescription,
                                           interaction: true)
                }
            })
    }
    
    private func registerUser() {
        if passwordTextField.text! == repeatPasswordTextField.text! {
            FirebaseUserListener.shared.registerUserWith(
                email: emailTextField.text!,
                password: passwordTextField.text!){
                    (error) in
                    if error == nil {
                        ProgressHUD.showSuccess("Verification email sent")
                        self.resendEmailBtn.isHidden = false
                    }else {
                        ProgressHUD.showError(error!.localizedDescription)
                    }
                }
        }else {
            ProgressHUD.showFailed("The password does not match")
        }
    }
}

