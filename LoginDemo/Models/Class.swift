//
//  Class.swift
//  LoginDemo
//
//  Created by Matthew Guo on 27/12/2020.
//

import Foundation

class Class {
    var teacherName: String
    var className: String
    var isLive: Bool
    var displayForTeacher: String
    
    
    init(teacherName: String, className: String, isLive: Bool, displayForTeacher: String) {
        self.teacherName = teacherName
        self.className = className
        self.isLive = isLive
        self.displayForTeacher = displayForTeacher
    }
}
