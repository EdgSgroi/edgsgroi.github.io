import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct EdgarSgroiWebsite: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
//        case posts
        case myprojects
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://your-website-url.com")!
    var name = "EDGAR SGROI"
    var description = "Welcome to my personal website!"
    var language: Language { .english }
    var imagePath: Path? { "images/meColored.png" }
    var socialMediaLinks: [SocialMediaLink] { [.github, .twitter, .linkedin] }
}

// This will generate your website using the built-in Foundation theme:
try EdgarSgroiWebsite().publish(withTheme: .mytheme)
