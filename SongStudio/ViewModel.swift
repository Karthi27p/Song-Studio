//
//  ViewModel.swift
//  SongStudio
//
//  Created by Karthi on 17/11/19.
//  Copyright © 2019 Karthi. All rights reserved.
//

import UIKit

class ViewModel: NSObject {
    
    var song: SongList?
    
    var songTitle: String {
        return song?.song ?? ""
    }
    
    var artistTitle: String {
        return song?.artists ?? ""
    }
    
    var songUrl: String {
        return song?.url ?? ""
    }
    
    var coverImageUrl: String {
        return song?.cover_image ?? ""
    }

}
