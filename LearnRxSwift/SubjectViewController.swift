//
//  SubjectViewController.swift
//  LearnRxSwift
//
//  Created by zhifu360 on 2019/10/10.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SubjectViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.white
        
        rxPublishSubject()
        rxReplaySubject()
        rxBehaviorSubject()
        rxVariable()
    }
    
    //PublishSubject，当有观察者订阅时，会发射订阅之后的数据给这个观察者
    func rxPublishSubject() {
        let publishSubject = PublishSubject<String>()
        
        publishSubject.subscribe { (event) in
            print("Subscription: 1, event: \(event)")
        }.disposed(by: disposeBag)
        
        publishSubject.onNext("a")
        publishSubject.onNext("b")
        
        publishSubject.subscribe { (event) in//当前这个订阅只收到了两个数据 "c"和"d"
            print("Subscription: 2, event: \(event)")
        }.disposed(by: disposeBag)
        
        publishSubject.onNext("c")
        publishSubject.onNext("d")
        print("\n")
    }

    //ReplaySubject，不论观察者什么时候订阅，都会发射完整的数据给观察者
    func rxReplaySubject() {
        let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
        
        replaySubject.subscribe { (event) in
            print("Subscription: 1, event: \(event)")
            }.disposed(by: disposeBag)
        
        replaySubject.onNext("a")
        replaySubject.onNext("b")
        
        replaySubject.subscribe { (event) in//这个订阅收到了四个数据
            print("Subscription: 2, event: \(event)")
            }.disposed(by: disposeBag)
        
        replaySubject.onNext("c")
        replaySubject.onNext("d")
        print("\n")
    }
    
    //BehaviorSubject，发射离序列最近的那个值，（如果原序列还没有发射值就用那个默认值代替）之后继续发射原序列的值
    func rxBehaviorSubject() {
        let behaviorSubject = BehaviorSubject(value: "z")
        
        behaviorSubject.subscribe { (event) in
            print("Subscription: 1, event: \(event)")
            }.disposed(by: disposeBag)
        
        behaviorSubject.onNext("a")
        behaviorSubject.onNext("b")
        
        behaviorSubject.subscribe { (event) in//这个订阅收到了四个数据
            print("Subscription: 2, event: \(event)")
            }.disposed(by: disposeBag)
        
        behaviorSubject.onNext("c")
        behaviorSubject.onNext("d")
        behaviorSubject.onCompleted()
        print("\n")
    }
    
    //Variable，是BehaviorSubject的一个封装，不会因为错误终止也不会正常终止，是一个无线序列
    func rxVariable() {
        let variable = Variable("z")
        
        variable.asObservable().subscribe { (event) in
            print("Subscription: 1, event: \(event)")
        }.disposed(by: disposeBag)
        
        variable.value = "a"
        variable.value = "b"
        
        variable.asObservable().subscribe { (event) in
            print("Subscription: 2, event: \(event)")
        }.disposed(by: disposeBag)
        
        variable.value = "c"
        variable.value = "d"
    }
}
