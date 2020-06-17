//
//  Date+toString.swift
//  EasyAudioReader
//
//  Created by Jordan MOREAU on 16/06/2020.
//  Copyright © 2020 Jordan MOREAU. All rights reserved.
//

import Foundation

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
