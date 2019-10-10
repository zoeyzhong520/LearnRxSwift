//
//  ListModel.swift
//  LearnRxSwift
//
//  Created by zhifu360 on 2019/10/9.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit
import RxDataSources

struct ListModel {
    let title: String
}

extension ListModel: Hashable {
    var hashValue: Int {
        return title.hashValue
    }
}

extension ListModel: IdentifiableType {
    var identity: Int {
        return hashValue
    }
}
