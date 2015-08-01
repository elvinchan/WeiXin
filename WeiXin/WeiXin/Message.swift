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

// 获取正确的删除索引
func getRemoveIndex(value:String, originArray:[Message]) -> [Int] {
    var indexArray = [Int]()
    var correctArray = [Int]()
    
    // 获取指定值在数组中的索引并保存
    for (index, _) in enumerate(originArray) {
        if (value == originArray[index].from) {
            // 如果在数组中找到指定的值，则把索引添加到索引数组
            indexArray.append(index)
        }
    }
    
    // 计算正确的删除索引
    for (index, originIndex) in enumerate(indexArray) {
        // 正确的索引
        var y = 0
        
        // 用指定值在原数组中索引，减去索引数组中的索引
        y = originIndex - index
        
        // 添加到正确索引数组中
        correctArray.append(y)
    }
    
    return correctArray
}

// 从原数组中删除指定元素
func removeValueFromArray(value:String, inout originArray:[Message]) {
    var correctArray = [Int]()
    
    correctArray = getRemoveIndex(value, originArray)
    
    for index in correctArray {
        originArray.removeAtIndex(index)
    }
}