//
//  MessageDelegate.swift
//  WeiXin
//
//  Created by chen.wenqiang on 15/7/31.
//
//

import Foundation

// 消息代理协议
protocol MessageDelegate {
    func newMsg(msg:Message)
}