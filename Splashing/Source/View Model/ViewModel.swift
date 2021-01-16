//
//  ViewModel.swift
//  Splashing
//
//  Created by 안재영 on 2020/08/30.
//  Copyright © 2020 안재영. All rights reserved.
//

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    var input : Input  { get }
    var output: Output { get }
}
