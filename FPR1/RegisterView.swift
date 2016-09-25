//
//  loginView.swift
//  FPR1
//
//  Created by 高冠东 on 24/09/2016.
//  Copyright © 2016 高冠东. All rights reserved.
//

import UIKit
import SnapKit
class loginView: UIImageView {
    
    @IBOutlet weak var dismissBt: UIImageView!
    @IBOutlet weak var confirmBt: UIButton!
    @IBOutlet weak var registerView: UIImageView!
    @IBOutlet weak var PromptLabel: UILabel!
    
    
    weak var account: UITextField!
    weak var password: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.registerView.isUserInteractionEnabled = true
        addSignInText()
        SignInViewsConstraint()
    }
    /** 添加账号，密码 fieldText **/
    func addSignInText() {
        //account
        let account = UITextField()
        account.placeholder = "账号"
        account.tintColor = UIColor.white
        account.textColor = UIColor.white
        account.textAlignment = .center
        account.keyboardType = .emailAddress
        self.registerView.addSubview(account)
        self.account = account
        
        //password
        let password = UITextField()
        password.placeholder = "密码"
        password.keyboardType = .numbersAndPunctuation
        password.tintColor = UIColor.white
        password.textColor = UIColor.white
        password.textAlignment = .center
        password.keyboardType = .emailAddress
        self.registerView.addSubview(password)
        self.password = password
    }
    /** 对fieldText进行约束 **/
    func SignInViewsConstraint() {
        //account
        self.account?.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.registerView)
            make.height.equalTo(self.registerView.snp.height).multipliedBy(0.5)
        }
        //password
        self.password?.snp.makeConstraints({ (make) in
            make.bottom.left.right.equalTo(self.registerView)
            make.height.equalTo(self.registerView.snp.height).multipliedBy(0.5)
        })
    }
    
}
