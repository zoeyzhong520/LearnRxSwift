//
//  CreateObservableViewController.swift
//  LearnRxSwift
//
//  Created by zhifu360 on 2019/10/9.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

//每个 Section 对应的 Model
typealias ListSectionModel = AnimatableSectionModel<String, ListModel>

class ListViewController: UITableViewController {

    let disposeBag = DisposeBag()
    
    let sections = Variable([ListSectionModel]())
    
    static let initialValue: [ListModel] = [
        ListModel(title: "创建序列 Observable"),
        ListModel(title: "什么是 Subject"),
        ListModel(title: "变换序列"),
        ListModel(title: "过滤序列"),
        ListModel(title: "组合序列"),
        
    ]
    
    static let pushViewControllers: [UIViewController] = [
        CreateObservableViewController(),
        SubjectViewController(),
        TransformSuquenceViewController(),
        FilterSequenceViewController(),
        CombinedSequenceViewController(),
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.white
        
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cellID")
        
        let tvDataSource = RxTableViewSectionedReloadDataSource<ListSectionModel> (
            configureCell: { (tvDataSource, tableView, indexPath, item) -> UITableViewCell in
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
                cell.textLabel?.text = item.title
                return cell
        })
        
        sections.asObservable().bind(to: tableView.rx.items(dataSource: tvDataSource)).disposed(by: disposeBag)
        
        sections.value = [ListSectionModel(model: "", items: ListViewController.initialValue)]
        
        tableView.rx.modelSelected(ListModel.self).subscribe(onNext: { (item) in
            print(item.title)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            print(indexPath)
            self.navigationController?.pushViewController(ListViewController.pushViewControllers[indexPath.row], animated: true)
        }).disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
