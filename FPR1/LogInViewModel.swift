//
//  LogInViewModel.swift
//  FPR1
//
//  Created by 高冠东 on 24/09/2016.
//  Copyright © 2016 高冠东. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Action

class LogInViewModel: NSObject {
    
    let account = Variable("")
    let password = Variable("") 
    let promptLabel: Variable<String?> = Variable(nil)
    var buttonEnable: Observable<Bool>!
    var loginAction: CocoaAction!
    
    init (view: loginView) {
        super.init()
        //View bind to Variable
        _ = view.account.rx.text
        .bindTo(account)
        _ = view.password.rx.text
        .bindTo(password)
        
        //配置Button使能
        buttonEnable = Observable.combineLatest(account.asObservable(), password.asObservable(), resultSelector: { (account, password) -> Bool in
            guard account.contains("@") else {return false}
            guard !password.isEmpty else {return false}
            
            return true
        })
        
        //配置 action
        configAction()
        //配置提示Label
        configPrompt()
    }
    
    //MARK: - Config Function
    func configAction() {
        loginAction = CocoaAction.init(workFactory: { (_) -> Observable<Void> in
            return Observable.create({ (observer) -> Disposable in
                    observer.onNext(())
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                    observer.onCompleted()
                    debugPrint("下载完成")
                })
                return Disposables.create()
            })
        })
    }
    
    func configPrompt() {
        _ = account.asObservable()
            .skip(1)
            .map { (account) -> String in
                print(account)
                if account.contains("@") {
                    return ""
                } else {
                    return "账户格式错误"
                }
            }
            .bindTo(promptLabel)
        
        _ = password.asObservable()
            .skip(1)
            .map { (password) -> String in
                print(password)
                if password.isEmpty {
                    return "密码为空"
                } else {
                    return ""
                }
            }
            .bindTo(promptLabel)
    }
}
