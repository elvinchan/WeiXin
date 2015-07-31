//
//  WXMessage.swift
//  WeiXin
//
//  Created by chen.wenqiang on 15/7/29.
//
//

import Foundation

// 好友消息结构
struct Message {
    var body = ""
    var from = ""
    var isComposing = false
    var isDelay = false
    var isSelf = false
}

// 状态结构
struct Status {
    var name = ""
    var isOnline = false
}