
//
//  CombinedSequenceViewController.swift
//  LearnRxSwift
//
//  Created by zhifu360 on 2019/10/10.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CombinedSequenceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.white
        
        rxStartWith()
        rxCombineLatest()
        rxCombineLatest2()
        rxCombineLatest3()
        rxZip()
        rxZip1()
        rxMerge()
        rxSwitchLatest()
    }
    
    //startWith，在一个序列前插入一个值
    func rxStartWith() {
        let subscription = Observable.of(4,5,6,7,8,9).startWith(3).startWith(2).subscribe {
            print($0)
        }
        print("\n")
    }
    
    //combineLatest，当两个序列中的任何一个发射了数据时，combineLatest 会结合并整理每个序列发射的最近数据项
    func rxCombineLatest() {
        let intObj1 = PublishSubject<String>()
        let intObj2 = PublishSubject<Int>()
        let intObj3 = PublishSubject<Int>()
        
        _ = Observable.combineLatest(intObj1, intObj2) {
            "(\($0) \($1))"
            }.subscribe {
                print($0)
        }
        
        intObj1.onNext("A")
        intObj2.onNext(1)
        intObj1.onNext("B")
        intObj2.onNext(2)
        print("\n")
    }

    func rxCombineLatest2() {
        let intObj = Observable.just(2)
        let intObj1 = Observable.of(0,1,2,3)
        let intObj2 = Observable.of(0,1,2,3,4)
        
        _ = Observable.combineLatest(intObj, intObj1, intObj2) {
            "(\($0) \($1) \($2))"
            }.subscribe {
                print($0)
        }
        print("\n")
    }
    
    func rxCombineLatest3() {
        let intObj1 = Observable.just(2)
        let intObj2 = ReplaySubject<Int>.create(bufferSize: 1)
        intObj2.onNext(0)
        
        let intObj3 = Observable.of(0,1,2,3,4)
        intObj2.onNext(1)
        
        _ = Observable.combineLatest(intObj1, intObj2, intObj3) {
            "(\($0) \($1) \($2))"
            }.subscribe {
                print($0)
        }
        
        intObj2.onNext(2)
        intObj2.onNext(3)
        
        print("\n")
    }
    
    //zip，zip 和 combineLatest 相似，不同的是每当所有序列都发射一个值时， zip 才会发送一个值。它会等待每一个序列发射值，发射次数由最短序列决定。结合的值都是一一对应的
    func rxZip() {
        let intObj1 = PublishSubject<String>()
        let intObj2 = PublishSubject<Int>()
        
        _ = Observable.zip(intObj1, intObj2) {
            "(\($0) \($1))"
            }.subscribe {
                print($0)
        }
        
        intObj1.onNext("A")
        intObj2.onNext(1)
        intObj1.onNext("B")
        intObj1.onNext("C")
        intObj2.onNext(2)
        
        print("\n")
    }
    
    func rxZip1() {
        let intObj1 = Observable.of(0,1)
        let intObj2 = Observable.of(0,1,2,3)
        let intObj3 = Observable.of(0,1,2,3,4)
        
        _ = Observable.zip(intObj1, intObj2, intObj3) {
            ($0 + $1) * $2
            }.subscribe {
                print($0)
        }
        print("\n")
    }
    
    //merge，merge 会将多个序列合并成一个序列，序列发射的值按先后顺序合并。要注意的是 merge 操作的是序列，也就是说序列发射序列才可以使用 merge
    func rxMerge() {
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        
        _ = Observable.of(subject1, subject2).merge().subscribe {
            print($0)
        }
        
        subject1.onNext(20)
        subject1.onNext(40)
        subject1.onNext(60)
        
        subject2.onNext(1)
        
        subject1.onNext(80)
        subject1.onNext(100)
        
        subject2.onNext(1)
        print("\n")
    }
    
    //switchLatest 和 merge 有一点相似，都是用来合并序列的。然而这个合并并非真的是合并序列。事实是每当发射一个新的序列时，丢弃上一个发射的序列
    func rxSwitchLatest() {
        let var1 = Variable(0)
        let var2 = Variable(200)
        
        // var3 是一个 Observable<Observable<Int>>
        let var3 = Variable(var1.asObservable())
        
        _ = var3.asObservable().switchLatest().subscribe {
            print($0)
        }
        
        var1.value = 1
        var1.value = 2
        var1.value = 3
        var1.value = 4
        
        //在这里新发射一个序列
        var3.value = var2.asObservable()
        
        var2.value = 201
        
        //var1 发射的值都会被忽略
        var1.value = 5
        var1.value = 6
        var1.value = 7
    }
}
