//
//  SocialMediaLink.swift
//  
//
//  Created by Edgar Sgroi on 09/11/20.
//

import Foundation

struct SocialMediaLink {
    let title: String
    let url: String
    let iconDark: String
    let iconLight: String
}

extension SocialMediaLink {
    static var github: SocialMediaLink {
        return SocialMediaLink(
            title: "GitHub",
            url: "https://github.com/EdgSgroi",
            iconDark: "../../images/socialMedia/darkIcons/githubIconDark.png",
            iconLight: "../../images/socialMedia/lightIcons/githubIconLight.png"
        )
    }
    
    static var twitter: SocialMediaLink {
        return SocialMediaLink(
            title: "Twitter",
            url: "https://twitter.com/EdgarSgroi",
            iconDark: "../../images/socialMedia/darkIcons/twitterIconDark.png",
            iconLight: "../../images/socialMedia/lightIcons/twitterIconLight.png"
        )
    }
    
    static var linkedin: SocialMediaLink {
        return SocialMediaLink(
            title: "LinkedIn",
            url: "https://www.linkedin.com/in/edgar-sgroi-639730109/",
            iconDark: "../../images/socialMedia/darkIcons/linkedinIconDark.png",
            iconLight: "../../images/socialMedia/lightIcons/linkedinIconLight.png"
        )
    }
}
