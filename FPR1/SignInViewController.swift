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
    fileprivate let disposeBag = DisposeBag()
    
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
        ViewModel.promptLabel.asObservable()
            .observeOn(MainScheduler.instance)
            .bindTo(self.mainView.PromptLabel.rx.text).addDisposableTo(disposeBag)
        
        ViewModel.buttonEnable
            .bindTo(self.mainView.confirmBt.rx.enabled).addDisposableTo(disposeBag)

        
    }
    
    func BindToAction() {
        self.mainView.confirmBt.rx_action = ViewModel.loginAction
        
        //为什么不使用 switchlatest?
        ViewModel.loginAction.executionObservables
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { observable in
                _ = observable
                    .subscribe(onNext: {[weak self] _ in
                        self?.mainView.confirmBt.setTitle("正在登录中", for: .disabled)
                        }, onCompleted: {[weak self] _ in
                            self?.mainView.confirmBt.setTitle("登录", for: .disabled)
                        })
            }).addDisposableTo(disposeBag)
    }
}
