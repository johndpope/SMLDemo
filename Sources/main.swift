
import SMLKit
import SXF97
import Foundation

var root = ProcessInfo.processInfo.arguments[1]
var port: in_port_t?
if ProcessInfo.processInfo.arguments.count < 2 {
    /* so called index just a file indexing my blogs post to a url reference */
    /* /root/sites is the directory I store the formmated blog content */
    print("Usage: [port(only if you want to run this demo on web inteface)]")
    exit(0)
}

if ProcessInfo.processInfo.arguments.count == 2 {
    guard let port_val = Int(ProcessInfo.processInfo.arguments[1]) else {
        print("port number must be number")
        exit(0)
    }
    port = in_port_t(port_val)
    print("Launched at 127.0.0.1:\(port)/!!!")
}

SMLInit(moduleName: "Demo", mode: port == nil ? .unix : .inet(port!)) {
    request -> HTTPResponse? in
    
    if request.uri.path == "/" || request.uri.path == "/index.html" {
        return HTTPResponse(status: 200, text: index_sml())
    } 
    
    if request.uri.path == "/dynamic" {
        return HTTPResponse(status: 200, text: dynamic())
    }
    return nil
}
