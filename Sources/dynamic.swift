//
//  blogs.swift
//  SMLDemo
//
//  Created by yuuji on 9/25/16.
//
//

import SMLKit
import Foundation
import FoundationPlus
import SXF97
import CKit

func item(title: String, value: CustomStringConvertible) -> String {
    return div() {[
        tag("h2") {title},
        tag("p") {"\(value)"}
    ]}
}

func dynamic() -> String {
    return html {[
        head() {[
            tag("title") { "This is a SML demo" },
            ]},
        body() {[
            tag("h1", style("color:darkorange")) {
                "Here is some information about your system!"
            },
            item(title: "Number of CPU", value: Sysconf.cpusConfigured),
            item(title: "Clock Tricks", value: Sysconf.clockTricks),
            item(title: "HTTP standard time", value: DateFormatter.httpDateNow),
            item(title: "iso8601 time", value: DateFormatter.iso8601DateNow),
            item(title: "Physical Page Size", value: Sysconf.physicalPagesize),
            item(title: "Max Files Count", value: Sysconf.maxFilesCount),
            item(title: "Max Child Process Count", value: Sysconf.maxChildProcCount)
        ]},
        "Back".link(url: "/")
    ]}
}
