//
//  TransformSuquenceViewController.swift
//  LearnRxSwift
//
//  Created by zhifu360 on 2019/10/10.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TransformSuquenceViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.white
        
        rxMap()
        rxMapWithIndex()
        rxFlatMap()
        rxScan()
        rxReduce()
        rxBuffer()
        rxWindow()
    }
    
    //map，用指定的方法去变换每一个值
    func rxMap() {
        let originalSequence = Observable.of(1,2,3)
        
        originalSequence.map({ number in
            number * 2
        }).subscribe { (element) in
            print(element)
        }.disposed(by: disposeBag)
        print("\n")
    }

    //mapWithIndex，注意第一个是序列发射的值，第二个是index
    func rxMapWithIndex() {
        let originalSequence = Observable.of(1,2,3)
        
        originalSequence.mapWithIndex { (number, index) in
            number * index
            }.subscribe { (element) in
                print(element)
        }.disposed(by: disposeBag)
        print("\n")
    }
    
    //flatMap，将一个序列发射的值转换成序列，然后将它们压平到一个序列
    func rxFlatMap() {
        let sequenceInt = Observable.of(1,2,3)
        let sequenceString = Observable.of("a","b","c","d","e","f","---")
        
        sequenceInt.flatMap { (x) -> Observable<String> in
            print("from sequenceInt: \(x)")
            return sequenceString
            }.subscribe { (element) in
                print(element)
        }.disposed(by: disposeBag)
        print("\n")
    }
    
    //scan，应用一个累加的方法遍历一个序列，然后返回累加的结果
    func rxScan() {
        let sequenceSum = Observable.of(0,1,2,3,4,5)
        
        sequenceSum.scan(0) { (acum, elem) in
            acum + elem
            }.subscribe {
                print($0)
        }.disposed(by: disposeBag)
        print("\n")
    }

    //reduce，在序列结束的时候才发射最终的累加值，最终只发射一个累加值
    func rxReduce() {
        let sequenceSum = Observable.of(0,1,2,3,4,5)
        
        sequenceSum.reduce(0) { (acum, elem) in
            acum + elem
            }.subscribe {
                print($0)
        }.disposed(by: disposeBag)
        print("\n")
    }
    
    //buffer，在特定的线程，定期定量收集序列发射的值，然后发射这些值的集合
    func rxBuffer() {
        let sequenceSum = Observable.of(0,1,2,3,4,5)
        
        sequenceSum.buffer(timeSpan: 5, count: 2, scheduler: MainScheduler.instance).subscribe {
            print($0)
        }.disposed(by: disposeBag)
        print("\n")
    }
    
    //window，发射序列
    func rxWindow() {
        let sequenceSum = Observable.of(0,1,2,3,4,5)
        
        sequenceSum.window(timeSpan: 5, count: 2, scheduler: MainScheduler.instance).subscribe {
            print($0)
            }.disposed(by: disposeBag)
    }
}
