
import SMLKit
import SXF97
import Foundation

let blogIndex = ProcessInfo.processInfo.arguments[1]
let root = ProcessInfo.processInfo.arguments[2]
var port: in_port_t?
if ProcessInfo.processInfo.arguments.count < 3 {
    /* so called index just a file indexing my blogs post to a url reference */
    /* /root/sites is the directory I store the formmated blog content */
    print("Usage: ./SMLDemo [path/to/index] [path/to/root/sites/] [port(only if you want to run this demo on web inteface)]")
    exit(0)
}

if ProcessInfo.processInfo.arguments.count == 4 {
    guard let port_val = Int(ProcessInfo.processInfo.arguments[3]) else {
        print("port number must be number")
        exit(0)
    }
    port = in_port_t(port_val)
}

SMLInit(moduleName: "blogs", mode: port == nil ? .unix : .inet(port!)) {
    request -> HTTPResponse? in
    if request.uri.path == "/blogs.html" {
        return HTTPResponse(status: 200, text: Blogs())
    }
    
    if request.uri.pathComponents.count >= 2 {
        if request.uri.pathComponents[1] == "sites" {
            let d = BlogsResources.generate_html(for: request.uri.path, root: root, base: "sites")
            return HTTPResponse(status: .success(.ok), text: d)
        }
    }
    
    return nil
}
