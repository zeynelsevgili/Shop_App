//
//  Settings.swift
//  Shop_App
//
//  Created by Demo on 21.01.2019.
//  Copyright © 2019 Demo. All rights reserved.
//

import Foundation

private let dateFormat = "yyyyMMddHHmmss"

// Çok kullanılacağı için özellikle dışarıda kullanılıyor.
func dateFormatter() -> DateFormatter {
    
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
    
    
}
