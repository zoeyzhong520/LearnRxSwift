//
//  ViewController.swift
//  LearnRxSwift
//
//  Created by zhifu360 on 2019/9/30.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    var disposeBag = DisposeBag()
    var timerDisposeBag = DisposeBag()
    
    lazy var button: UIButton = {
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 100, y: 100, width: 200, height: 40)
        btn.setTitle("按钮", for: .normal)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        return btn
    }()
    
    lazy var textfield: UITextField = {
        let tf = UITextField(frame: CGRect(x: 100, y: self.button.frame.maxY+100, width: 200, height: 40))
        tf.placeholder = "请输入"
        tf.borderStyle = UITextField.BorderStyle.roundedRect
        return tf
    }()
    
    lazy var showInputLb: UILabel = {
        let lb = UILabel(frame: CGRect(x: 100, y: self.textfield.frame.maxY+10, width: 200, height: 40))
        lb.layer.borderColor = UIColor.black.cgColor
        lb.layer.borderWidth = 1
        return lb
    }()
    
    @objc dynamic var personName: String!
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: CGRect(x: 0, y: self.showInputLb.frame.maxY+10, width: self.view.bounds.size.width, height: 200))
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    lazy var nextBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 100, y: self.scrollView.frame.maxY+10, width: 200, height: 40)
        btn.setTitle("前往下一页", for: .normal)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        createUI()
        rxButton()
        rxTap()
        rxTextfield()
        rxKVO()
        rxScroll()
        rxTimer()
        rxKeyboard()
    }

    func createUI() {
        view.addSubview(button)
        view.addSubview(textfield)
        view.addSubview(showInputLb)
        view.addSubview(scrollView)
        view.addSubview(nextBtn)
    }

    //button点击事件
    func rxButton() {
        button.rx.tap.subscribe(onNext: { () in
            print("被点击了")
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }.disposed(by: disposeBag)
        
        nextBtn.rx.tap.subscribe(onNext: { () in
            self.navigationController?.pushViewController(ListViewController(), animated: true)
        }).disposed(by: disposeBag)
    }
    
    //手势点击事件
    func rxTap() {
        let tempView = UIView(frame: CGRect(x: 100, y: button.frame.maxY+10, width: 200, height: 40))
        tempView.backgroundColor = UIColor.red
        view.addSubview(tempView)
        
        let tap = UITapGestureRecognizer.init()
        tempView.addGestureRecognizer(tap)
        tap.rx.event.subscribe(onNext: { (tap) in
            print(tap.view as Any)
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }.disposed(by: disposeBag)
    }
    
    //输入框监听输入事件
    func rxTextfield() {
        textfield.rx.text.orEmpty.changed.subscribe(onNext: { (text) in
            print(text)
            self.personName = text
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }.disposed(by: disposeBag)
        
        //绑定、数据传递
        textfield.rx.text.bind(to: showInputLb.rx.text).disposed(by: disposeBag)
    }
    
    //KVO事件监听
    func rxKVO() {
        self.rx.observeWeakly(String.self, "personName").subscribe(onNext: { (value) in
            print(value as Any)
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }.disposed(by: disposeBag)
    }
    
    //监听滑动事件
    func rxScroll() {
        scrollView.contentSize = CGSize(width: view.bounds.size.width*2, height: 0)
        
        let blueView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        blueView.backgroundColor = UIColor.blue
        scrollView.addSubview(blueView)
        
        let redView = UIView(frame: CGRect(x: view.bounds.size.width, y: 0, width: view.bounds.size.width, height: 200))
        redView.backgroundColor = UIColor.red
        scrollView.addSubview(redView)
        
        scrollView.rx.contentOffset.subscribe(onNext: { (point) in
            print(point)
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }.disposed(by: disposeBag)
    }
    
    //定时器调用
    func rxTimer() {
        var a = 0
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        timer.subscribe(onNext: { (time) in
            a += 1
            print(time)
            if a > 5 {
                self.timerDisposeBag = DisposeBag()
            }
        }).disposed(by: timerDisposeBag)
        
    }
    
    //键盘通知
    func rxKeyboard() {
        NotificationCenter.default.rx.notification(UIApplication.keyboardWillShowNotification, object: nil).subscribe(onNext: { (notification) in
            //获取值
            let during = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Float
            print(during!)
        }).disposed(by: disposeBag)
    }
}

