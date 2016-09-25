//
//  SignInViewController.swift
//  FPR1
//
//  Created by 高冠东 on 24/09/2016.
//  Copyright © 2016 高冠东. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class SignInViewController: UIViewController {
    weak var mainView: loginView!
    var ViewModel: LogInViewModel!
    //MARK: - lifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpView()
        BindToView()
        BindToAction()
    }
    
    func SetUpView() {
        self.mainView = self.view as! loginView
        self.ViewModel = LogInViewModel.init(view: mainView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Bind Function
    func BindToView() {
        _ = ViewModel.promptLabel.asObservable()
            .observeOn(MainScheduler.instance)
            .bindTo(self.mainView.PromptLabel.rx.text)
        
        _ = ViewModel.buttonEnable
            .bindTo(self.mainView.confirmBt.rx.enabled)
        
    }
    
    func BindToAction() {
        self.mainView.confirmBt.rx_action = ViewModel.loginAction
        ViewModel.loginAction.executionObservables
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.mainView.confirmBt.setTitle("正在登录中", for: .disabled)
                })
    }
}
