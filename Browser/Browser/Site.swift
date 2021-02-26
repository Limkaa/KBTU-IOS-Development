//
//  Site.swift
//  Browser
//
//  Created by Alim on 25.02.2021.
//

import Foundation
import UIKit

struct Site {
    var siteIndex: Int?
    var name: String?
    var favourite: Bool! = false
    var url: String?
    
    mutating func changeStatus() {
        favourite = !favourite
    }
}

struct WebsitesList {

    var sites: Array<Site> = []
    
    mutating func changeSiteStatus(website: Site) {
        sites[website.siteIndex!].changeStatus()
    }
    
    mutating func getSites(_ favouriteViewMode: Bool = false) -> Array<Site>{
        var displayedSites: Array<Site> = []
        for site in sites {
            if favouriteViewMode {
                if site.favourite {
                    displayedSites.append(site)
                }
            } else {
                displayedSites.append(site)
            }
        }
        return displayedSites
    }
}
