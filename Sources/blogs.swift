//
//  blogs.swift
//  SMLDemo
//
//  Created by yuuji on 9/25/16.
//
//

import Foundation
import FoundationPlus
import SMLKit

final class BlogsResources {
    
    enum Error: Swift.Error {
        case pathIsDirectory
    }
    
    struct Content {
        var title: String
        var date: String
        var innerTitle: String
        var body: String
        
        init(with data: Data) {
            var reader = DataReader(fromData: data)
            let titled = reader.nextSegmentOfData(separatedBy: [0x0a])!
            title = String(data: titled.subdata(in: titled.startIndex.advanced(by: 21)..<titled.endIndex), encoding: .utf8)!
            let dated = reader.nextSegmentOfData(separatedBy: [0x0a])!
            date = String(data: dated.subdata(in: dated.startIndex.advanced(by: 20)..<dated.endIndex), encoding: .utf8)!
            let inner_titled = reader.nextSegmentOfData(separatedBy: [0x0a])!
            print(String(data: inner_titled, encoding: .ascii))
            innerTitle = String(data: inner_titled.subdata(in: inner_titled.startIndex.advanced(by: 27)..<inner_titled.endIndex), encoding: .utf8)!
            
            var b = ""
            reader.forallSegments(separatedBy: [0x0a]) { (data) -> Bool in
                let string = String(data: data, encoding: .utf8)!
                if string.isEmpty {
                    return true
                }
                
                let components = string.components(separatedBy: "::")
                if components.count < 3 {
                    b.append("<\(components[0])>\(components[1])</\(components[0])>")
                } else {
                    b.append("<\(components[0]) \(components[1])>\(components[2])</\(components[0])>")
                }

                return true
            }
            body = b
            
        }
    }
    
    /* /2016/September/spartanX.html */ /*/home/.../root */ /* sites */
    static func generate_html(for path: String, root: String, base: String) -> String {
        var pp = path
        if path == "/\(base)" {
            return ""
        }
        
        pp.removeSubrange(path.startIndex..<path.index(path.startIndex, offsetBy: 2 + base.characters.count))
        let file_path = root + "\(base)/" + pp.replacingOccurrences(of: "/", with: ".") + ".resource"
        
        guard let data = FileManager.default.contents(atPath: file_path) else {
            return ""
        }
        
        let content = Content(with: data)
        // why for /sites/2016/september/spartanX.html is speacial ?? cuz i messed up when i set up my first post.
        let generated = blogGenerate(title: content.title, date: content.date, innerTitle: content.innerTitle, innerContent: content.body, innerLink: path == "/sites/2016/september/spartanX.html" ? "/sites/2016/September/spartanX.html//plugins/comments#configurator" : path)
        
        return generated
    }
}

func blogGenerate(title: String, date: String, innerTitle: String, innerContent: String, innerLink: String) -> String {
    return html("lang=\"en\"") {[
        head {[
            meta(charset("UTF-8")),
            meta("property=\"og:type", "content=\"article\""),
            meta("property=\"og:title", "content=\"\(innerTitle)\""),
            tag("title") { title },
            css("/common/css/common.css"),
            css("/common/css/content.css"),
            css("/common/css/font.css"),
            script(src: "https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"),
            css("/common/js/highlight/styles/mono-blue.css"),
            script(src: "/common/js/highlight/highlight.pack.js"),
            script("hljs.initHighlightingOnLoad();"),
            script(src: "/common/js/common.js"),
            script()
            ]},
        tag("body") {[
            div(id("fb-root")){[]},
            script("(function(d, s, id) {\nvar js, fjs = d.getElementsByTagName(s)[0];\nif (d.getElementById(id)) return;\njs = d.createElement(s); js.id = id;\njs.src = \"//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.7\";\nfjs.parentNode.insertBefore(js, fjs);\n}(document, 'script', 'facebook-jssdk'));"),
            div(id("nav-area")) {
                div(id("nav")) {
                    tag("ul") {[
                        tag("li") {"Home".link(url: "/home.html")},
                        tag("li") {"Blogs".link(url: "/blogs.html", id("en0"))},
                        tag("li") {"Resources".link(url: "/resources.html", id("en1"))},
                        tag("li") {"Downloads".link(url: "/downloads.html", id("en2"))},
                        tag("li") {"Contact".link(url: "/contact.html", id("en3"))},
                        ]}
                }
            },
            div(id("content-area")) {[
                tag("p", class_("date")) {date},
                tag("h1", class_("gl-title"), style("color:darkorange")) {innerTitle},
                innerContent,
                "<br/><br/>",
                "<hr/>",
                tag("h2") {"Any Comments? Please let me know!!"},
                "<div class=\"fb-comments\" data-href=\"http://www.hatsuneyuji.com\(innerLink)\" data-width=\"700\" data-numposts=\"5\" data-colorscheme=\"dark\"></div>",
                ]},
            div(style("height:50px")) {""},
            tag("footer", style("")) {
                div(style("height:100%", "display:block"), class_("copyright")) {
                    tag("p", style("height:80%", "display:flex", "justify-content:center", "align-items:center")) {
                        "2016 Yuji All Rights Reserved"
                    }
                }
            }
            ]}
        ]}
}
