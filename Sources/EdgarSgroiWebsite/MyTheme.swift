//
//  MyTheme.swift
//  
//
//  Created by Edgar Sgroi on 10/11/20.
//

import Foundation
import Publish
import Plot


extension Theme where Site == EdgarSgroiWebsite {
    /// My customized "MyTheme" theme.
    static var mytheme: Self {
        Theme(
            htmlFactory: MyThemeHTMLFactory(),
            resourcePaths: ["Resources/myTheme/styles.css"]
        )
    }
}

private struct MyThemeHTMLFactory: HTMLFactory {
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<EdgarSgroiWebsite>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1(.text(index.title)),
                    .p(
                        .class("description"),
                        .text(context.site.description)
                    ),
                    .h2("Latest content"),
                    .itemList(
                        for: context.allItems(
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        if section.id == .myprojects {
            return HTML(
                .lang(context.site.language),
                .head(for: section, on: context.site),
                .body(
                    .header(for: context, selectedSection: section.id),
                    .wrapper(
                        .h1(.text(section.title)),
                        .itemProjectList(for: section.items, on: context.site)
                    ),
                    .footer(for: context.site)
                )
            )
        } else if section.id == .about {
            return HTML(
                .lang(context.site.language),
                .head(for: section, on: context.site),
                .body(
                    .header(for: context, selectedSection: section.id),
                    .wrapper(
                        .p(.contentBody(section.content.body))
                    ),
                    .footer(for: context.site)
                )
            )
        } else {
            return HTML(
                .lang(context.site.language),
                .head(for: section, on: context.site),
                .body(
                    .header(for: context, selectedSection: section.id),
                    .wrapper(
                        .h1(.text(section.title)),
                        .itemList(for: section.items, on: context.site)
                    ),
                    .footer(for: context.site)
                )
            )
        }
    }

    func makeItemHTML(for item: Item<EdgarSgroiWebsite>,
                      context: PublishingContext<EdgarSgroiWebsite>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body(
                .class("item-page"),
                .header(for: context, selectedSection: item.sectionID),
                .wrapper(
                    .article(
                        .div(
                            .class("content"),
                            .contentBody(item.body)
                        ),
                        .span("Tagged with: "),
                        .tagList(for: item, on: context.site)
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<EdgarSgroiWebsite>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(.contentBody(page.body)),
                .footer(for: context.site)
            )
        )
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<EdgarSgroiWebsite>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1("Browse all tags"),
                    .ul(
                        .class("all-tags"),
                        .forEach(page.tags.sorted()) { tag in
                            .li(
                                .class("tag"),
                                .a(
                                    .href(context.site.path(for: tag)),
                                    .text(tag.string)
                                )
                            )
                        }
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<EdgarSgroiWebsite>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1(
                        "Tagged with ",
                        .span(.class("tag"), .text(page.tag.string))
                    ),
                    .a(
                        .class("browse-all"),
                        .text("Browse all tags"),
                        .href(context.site.tagListPath)
                    ),
                    .itemList(
                        for: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site
                    )
                ),
                .footer(for: context.site)
            )
        )
    }
}

private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }

    static func header<T: Website>(
        for context: PublishingContext<T>,
        selectedSection: T.SectionID?
    ) -> Node {
        let sectionIDs = T.SectionID.allCases

        return .header(
            .wrapper(
                .img(.class("perfil-img"), .src(context.site.imagePath ?? "")),
                .br(),
                .socialMediaList(for: context),
                .a(.class("site-name"), .href("/"), .text(context.site.name)),
                .if(sectionIDs.count > 1,
                    .nav(
                        .ul(.forEach(sectionIDs) { section in
                            .li(.a(
                                .class(section == selectedSection ? "selected" : ""),
                                .href(context.sections[section].path),
                                .text(context.sections[section].title)
                            ))
                        })
                    )
                )
            )
        )
    }
    
    static func socialMediaList<T: Website>(for context: PublishingContext<T>) -> Node {
        guard let site = context.site as? EdgarSgroiWebsite else { return .empty }
        
        return .nav(
            .ul(
                .forEach(site.socialMediaLinks) { media in
                    .li(.a(
                        .href(media.url),
                        .img(.class("social-media"), .src(media.iconLight))
                    ))
            })
        )
    }

    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class("item-list"),
            .forEach(items) { item in
                .li(.article(
                    .h1(.a(
                        .href(item.path),
                        .text(item.title)
                    )),
                    .tagList(for: item, on: site),
                    .p(.text(item.description))
                ))
            }
        )
    }
    
    static func itemProjectList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class("item-list"),
            .forEach(items) { item in
                .li(.article(
                    .div(.class("flex"),
                        .div(
                            .class("div-project-img"),
                            .a(.href(item.path),
                                .img(.class("project-img"), .src(item.imagePath ?? ""))
                            )
                        ),
                        .div(
                            .class("div-project-body"),
                            .h1(.a(
                            .href(item.path),
                            .text(item.title)
                        )),
                        .p(.text(item.description)),
                        .tagList(for: item, on: site)
                        )
                    )
                ))
            }
        )
    }

    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        return .ul(.class("tag-list"), .forEach(item.tags) { tag in
            .li(.class(tag.string + "-tag"),
                .a(
                    .href(site.path(for: tag)),
                    .text(tag.string)
                )
            )
        })
    }

    static func footer<T: Website>(for site: T) -> Node {
        return .footer(
            .p(
                .text("Generated using "),
                .a(
                    .text("Publish"),
                    .href("https://github.com/johnsundell/publish")
                )
            ),
            .p(.a(
                .text("RSS feed"),
                .href("/feed.rss")
            ))
        )
    }
}
