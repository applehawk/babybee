//
//  CGMainScreenDelegate.swift
//  BabyBee
//
//  Created by Hawk on 10/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

@objc protocol CGMainScreenDelegate {
    func birthdayString() -> String;
    func didSelectedGroup(groupName : String, selectedRow: Int);
}