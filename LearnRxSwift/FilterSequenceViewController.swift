//
//  FilterSequenceViewController.swift
//  LearnRxSwift
//
//  Created by zhifu360 on 2019/10/10.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FilterSequenceViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.white
        
        rxFilter()
        rxDistinctUntilChanged()
        rxTake()
        rxTakeLast()
        rxSkip()
        rxDebounce()
        rxSingle()
        rxSample()
    }
    
    //filter，传入一个返回bool的闭包决定是否去掉这个值
    func rxFilter() {
        Observable.of(0,1,2,3,4,5,6,7,8,9).filter({
            $0 % 2 == 0
        }).subscribe {
            print($0)
        }.disposed(by: disposeBag)
        print("\n")
    }
    
    //distinctUntilChanged，组织发射与上一个重复的值
    func rxDistinctUntilChanged() {
        Observable.of(1,2,3,1,1,4).distinctUntilChanged().subscribe {
            print($0)
            }.disposed(by: disposeBag)
        print("\n")
    }

    //take，只发射指定数量的值
    func rxTake() {
        Observable.of(1,2,3,4,5,6).take(3).subscribe {
            print($0)//只发射了前三个值
        }.disposed(by: disposeBag)
        print("\n")
    }
    
    //takeLast，只发射序列结尾指定数量的值
    func rxTakeLast() {
        Observable.of(1,2,3,4,5,6).takeLast(3).subscribe {
            print($0)//只发射了后三个值
            }.disposed(by: disposeBag)
        print("\n")
    }
    
    //skip，忽略指定数量的值
    func rxSkip() {
        Observable.of(1,2,3,4,5,6).skip(3).subscribe {
            print($0)//前三个值并没有继续发射下去
            }.disposed(by: disposeBag)
        print("\n")
    }
    
    //debounce，抑制发射过快的值，这一操作需要指定一个线程
    //有一个很常见的应用场景，比如点击一个 Button 会请求一下数据，然而总有刁民想去不停的点击，那这个 debounce 就很有用了
    func rxDebounce() {
        Observable.of(1,2,3,4,5,6).debounce(DispatchTimeInterval.microseconds(1), scheduler: MainScheduler.instance).subscribe {
            print($0)
        }.disposed(by: disposeBag)
        print("\n")
    }
    
    //single 就类似于 take(1) 操作，不同的是 single 可以抛出两种异常： RxError.MoreThanOneElement 和 RxError.NoElements 。当序列发射多于一个值时，就会抛出 RxError.MoreThanOneElement ；当序列没有值发射就结束时， single 会抛出 RxError.NoElements
    func rxSingle() {
        Observable.of(1,2,3,4,5,6).single().subscribe {
            print($0)
            }.disposed(by: disposeBag)
        print("\n")
    }
    
    //sample，抽样操作，按照传入的序列发射情况进行抽样
    func rxSample() {
        Observable<Int>.interval(0.1, scheduler: SerialDispatchQueueScheduler(qos: .background)).take(100).sample(Observable<Int>.interval(1, scheduler: SerialDispatchQueueScheduler(qos: .background))).subscribe {
            print($0)
        }.disposed(by: disposeBag)//在这个例子中我们使用 interval 创建了每 0.1s 递增的无限序列，同时用 take 只留下前 100 个值。抽样序列是一个每 1s 递增的无限序列
    }
    
}

