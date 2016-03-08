//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Ali Kayhan on 06/03/16.
//  Copyright © 2016 Ali Kayhan. All rights reserved.
//

import Foundation

class RecordedAudio {
    
    var filePathURL: NSURL
    var title: String
    
    init(filePathURL: NSURL!, title: String!) {
        self.filePathURL = filePathURL
        self.title = title
    }
    
}
