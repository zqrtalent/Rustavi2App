//
//  DateExtension.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/27/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

extension Date {
    
    public static func fromNewsTimeString(_ timeString:String?, formatString:String?) -> Date?{
        guard let tm = timeString else {
            return nil
        }
        
        let dtFormatter = DateFormatter()
        //dtFormatter.locale = Locale(identifier: "en_US_POSIX")
        dtFormatter.timeZone = TimeZone(secondsFromGMT: 4 * 3600) // GMT + 4 hours
        
        if let fmtStr = formatString{
            dtFormatter.dateFormat = fmtStr
            dtFormatter.defaultDate = Date.init() // Current time
        }
        else{
            if(tm.count == 5){ // 23:45
                dtFormatter.dateFormat = "HH:mm"
                dtFormatter.defaultDate = Date.init() // Current time
            }
            else{ // 2018-11-27T23:45
                dtFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            }
        }
        return dtFormatter.date(from: tm)
    }
    
    public func asDateTimeString() -> String{
        let dateFormatter = DateFormatter()
        //dateFormatter.dateStyle = .medium
        //dateFormatter.dateStyle = .full
        
        // Georgian Locale (ka_GE)
        dateFormatter.locale = Locale(identifier: "ka_GE")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd HH:mm") // set template after setting locale
       
        return dateFormatter.string(from: self)
    }
}
