//
//  CreateObservableViewController.swift
//  LearnRxSwift
//
//  Created by zhifu360 on 2019/10/9.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CreateObservableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.white
        
        runRx()
    }
    
    //create，使用swift闭包的方式创建序列
    func rxCreate() {
        let myJust = { (singleElement: Int) -> Observable<Int> in
            return Observable.create({ (observer) -> Disposable in
                observer.onNext(singleElement)
                observer.onCompleted()
                return Disposables.create()
            })
        }
        
        _ = myJust(5).subscribe({ (event) in
            print(event)
        })
        
    }
    
    //deferred，只有在有观察者订阅时，才去创建序列
    func rxDeferred() {
        let deferredSequence: Observable<Int> = Observable.deferred {
            print("creating")
            return Observable.create({ (observer) -> Disposable in
                print("emmiting")
                observer.onNext(0)
                observer.onNext(1)
                observer.onNext(2)
                
                return Disposables.create()
            })
        }
        
        _ = deferredSequence.subscribe({ (event) in
            print(event)
        })
        
        _ = deferredSequence.subscribe({ (event) in
            print(event)
        })
    }

    //empty，创建一个空的序列，只发射一个.Completed
    func rxEmpty() {
        let emptySequence = Observable<Int>.empty()
        
        _ = emptySequence.subscribe({ (event) in
            print(event)
        })
    }
    
    //error，创建一个发射error终止的序列
    func rxError() {
        let error = NSError(domain: "Test", code: -1, userInfo: nil)
        
        let errorSequence = Observable<Int>.error(error)
        
        _ = errorSequence.subscribe({ (event) in
            print(event)
        })
    }
    
    //通过一组元素创建一个序列
    func rxOf() {
        let sequenceFromArray = Observable<Int>.of(1,2,3,4,5,6,7,8,9)
        
        _ = sequenceFromArray.subscribe({ (event) in
            print(event)
        })
    }
    
    //interval，创建一个每隔一段时间就发射的递增序列
    func rxInterval() {
        var disposeBag = DisposeBag()
        var a = 0
        
        let intervalSequence = Observable<Int>.interval(3, scheduler: MainScheduler.instance)
        
        intervalSequence.subscribe({ (event) in
            print(event)
            a += 1
            if a > 5 {
                disposeBag = DisposeBag()
            }
        }).disposed(by: disposeBag)
    }

    //never，不创建序列，也不发送通知
    func rxNever() {
        let neverSequence = Observable<Int>.never()
        
        _ = neverSequence.subscribe({ (event) in
            print(event)
        })
    }
    
    //just，只创建包含一个元素的序列，只发送一个值和.Completed
    func rxJust() {
        let singleElementSequence = Observable<Int>.just(23)
        
        
        _ = singleElementSequence.subscribe({ (event) in
            print(event)
        })
    }
    
    //range，创建一个有范围的递增序列
    func rxRange() {
        let rangeSequence = Observable<Int>.range(start: 1, count: 10)
        
        _ = rangeSequence.subscribe({ (event) in
            print(event)
        })
    }
    
    //repeatElement，创建一个发射重复值的序列
    func rxRepeatElement() {
        let repeatElementSequence = Observable<Int>.repeatElement(1)
        
        _ = repeatElementSequence.subscribe({ (event) in
            print(event)
        })
        
    }
    
    //timer，创建一个带延迟的序列
    func rxTimer() {
        var a = 0
        var disposeBag = DisposeBag()
        
        let timerSequence = Observable<Int>.timer(1, period: 1, scheduler: MainScheduler.instance)
        
        timerSequence.subscribe({ (event) in
            print(event)
            a += 1
            if a > 10 {
                disposeBag = DisposeBag()
            }
        }).disposed(by: disposeBag)
    }
    
    func runRx() {
        rxCreate()
        rxDeferred()
        rxEmpty()
        rxError()
        rxOf()
        rxInterval()
        rxNever()
        rxJust()
        rxRange()
//        rxRepeatElement()
        rxTimer()
    }
    
}
