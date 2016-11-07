# SMLDemo
This is demo of how to use SML to build a very simple website.

# Build
Simply type `make` and the makefile will launch the web application at 127.0.0.1:8000

# Code
```swift
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
    print("Launched at 127.0.0.1:\(port_val)/!!!")
}

var pathc = ProcessInfo.processInfo.arguments[0].components(separatedBy: "/")

pathc.removeLast(3)

let static_files_path = pathc.reduce("") {"\($0)\($1)/"}

let service = SMLService()

// we server our stylesheet as static file
service.addStaticFileSource(root: static_files_path, as: "/")

// index.html never changes in this demo, so we set it as static content
service.addStaticContent(uri: "/", content: index_sml().data(using: .utf8)!)

// our dynamic web content
service.setRoute(uri: "/dynamic") { req in
    return HTTPResponse(status: 200, text: dynamic())
}

SMLInit(moduleName: "Demo", mode: port == nil ? .unix : .inet(port!), router: service)
```
