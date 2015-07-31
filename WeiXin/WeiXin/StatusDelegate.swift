//
//  StatusDelegate.swift
//  WeiXin
//
//  Created by chen.wenqiang on 15/7/31.
//
//

import Foundation

protocol StatusDelegate {
    func isOn(status:Status)
    func isOff(status:Status)
    func selfOff()
}