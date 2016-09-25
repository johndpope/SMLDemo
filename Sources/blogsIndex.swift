//
//  blogsIndex.swift
//  SMLDemo
//
//  Created by yuuji on 9/25/16.
//
//

import Foundation
import SMLKit

func Blogs() -> String {
    
    let li_a_make = { (year: String) -> String in
        tag("li") {tag("a", class_("active")) {year}}
    }
    
    var blogs = [String: [String: [(String, String)]]]()
    
    let data = FileManager.default.contents(atPath: blogIndex)!
    
    let files = String(data: data, encoding: .ascii)!.components(separatedBy: "\n")
    
    for file in files {
        if file.isEmpty {
            break
        }
        let entries = file.components(separatedBy: "::")
        if blogs[entries[0]] == nil {
            let temp = [entries[1]: [(entries[2], entries[3])]]
            blogs[entries[0]] = temp
        } else {
            blogs[entries[0]]![entries[1]]!.append((entries[2], entries[3]))
        }
    }
    
    let blog_make = { (month: String, blogs: [(link: String, title: String)]) -> String in
        tag("li") {[
            tag("h1") {month},
            tag("ul") {
                blogs.map { (link, title) in
                    tag("li") { _ -> String in
                        let x = title.link(url: link, "style='font-size:20px'")
                        return x
                    }
                }
            }
            ]}
    }
    
    
    return [
        "<!DOCTYPE HTML>\n<html>\n<head>\n<link rel=\"stylesheet\" type=\"text/css\" href=\"/common/css/common.css\">\n<link rel=\"stylesheet\" type=\"text/css\" href=\"/common/css/content.css\">\n<link rel=\"stylesheet\" type=\"text/css\" href=\"/common/css/font.css\">\n\n<script>env = 'Blogs';</script>\n\n<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js\"></script>\n<script src=\"/common/js/common.js\"></script>\n<script></script>\n\n<style>\n.container li {\nlist-style: none;\n        margin: 10px;\n}\n\n#content-area {\n/*  background-color:white; */\n/* opacity: 0.75; */\nwidth: 70%;\n\nmax-width: 1200px;\ntop: 45px;\nmargin-left: auto;\nmargin-right: auto;\npadding: 14px 14px;\nbottom:10px;\n}\n</style>\n</head>\n<body>\n<div id=\"nav-area\">\n<div id=\"nav\">\n<ul>\n<li><a href=\"/home.html\">Home</a></li>\n<li class=\"active\"><a href=\"/blogs.html\">Blogs</a></li>\n<li><a href=\"/resources.html\">Resources</a></li>\n<li><a href=\"/downloads.html\">Downloads</a></li>\n<li><a href=\"/contact.html\">Contact</a></li>\n</ul>\n</div>\n</div>\n",
        
        tag("div", class_("sub-menu")) {
            tag("ul") {
                [["<li><a class='current'>Year</a></li>"],
                 blogs.keys.map {
                    li_a_make($0)
                    }].flatMap({$0})
            }
        },
        "<hr>"
        ,
        tag("div", id("content-area")) {
            tag("div", id("container")) {
                tag("ul") {
                    blogs.keys.map { year in
                        let blogs_at_year = blogs[year]
                        let x = blogs_at_year!.keys.map { month -> String in
                            return blog_make(month, blogs_at_year![month]!)
                        }
                        return x.reduce("") {"\($0)\($1)"}
                    }
                }
            }
        }
        ,
        "<footer style=\"\">\n        <div style=\"height:100%\" class=\"copyright\">\n    \n    <p style=\"height:80%;display:flex;justify-content:center;align-items:center\">2016 Yuji All Rights Reserved</p>\n    \n    </div>\n    <!--            <p class=\"copyright\">2016 Yuji All Rights Reserved</p>-->\n    </footer>\n    </body>\n    </html>\n"
        ].reduce("") {"\($0)\($1)"}
}
