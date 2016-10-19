//
//  NetWork.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/2/15.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

class HDHttpManager{
    
    static func get(_ url: String, callback: @escaping (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void) {
        let manager = HttpManager(url: url, method: "GET", callback: callback)
        manager.fire()
    }
    static func get(_ url: String, params: Dictionary<String, AnyObject>, callback: @escaping (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void) {
        let manager = HttpManager(url: url, method: "GET", params: params, callback: callback)
        manager.fire()
    }
    static func post(_ url: String, callback: @escaping (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void) {
        let manager = HttpManager(url: url, method: "POST", callback: callback)
        manager.fire()
    }
    static func post(_ url: String, params: Dictionary<String, AnyObject>, callback: @escaping (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void) {
        let manager = HttpManager(url: url, method: "POST", params: params, callback: callback)
        manager.fire()
    }
    static func request(_ method: String, url: String, callback: @escaping (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void) {
        let manager = HttpManager(url: url, method: method, callback: callback)
        manager.fire()
    }
    static func request(_ method: String, url: String, params: Dictionary<String, AnyObject>, callback: @escaping (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void) {
        let manager = HttpManager(url: url, method: method, params: params, callback: callback)
        manager.fire()
    }
    static func request(_ method: String, url: String, files: Array<File>, callback: @escaping (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void) {
        let manager = HttpManager(url: url, method: method, files: files, callback: callback)
        manager.fire()
    }
    static func request(_ method: String, url: String, params: Dictionary<String, AnyObject>, files: Array<File>, callback: @escaping (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void) {
        let manager = HttpManager(url: url, method: method, params: params, files: files, callback: callback)
        manager.fire()
    }
}

extension String {
    var nsdata: Data {
        return self.data(using: String.Encoding.utf8)!
    }
}

struct File {
    let name: String!
    let url: URL!
    init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
}

class HttpManager: NSObject, URLSessionDelegate {
    let boundary = "PitayaUGl0YXlh"
    
    let method: String!
    let params: Dictionary<String, AnyObject>
    let callback: (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void
    var files: Array<File>
    
    var session: Foundation.URLSession!
    let url: String!
    var request: NSMutableURLRequest!
    var task: URLSessionTask!
    
    var localCertData: Data!
    var sSLValidateErrorCallBack: (() -> Void)?
    
    init(url: String, method: String, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(), files: Array<File> = Array<File>(), callback: @escaping (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void) {
        self.url = url
        self.request = NSMutableURLRequest(url: URL(string: url)!)
        self.method = method
        self.params = params
        self.callback = callback
        self.files = files
        
        super.init()
        self.session = Foundation.URLSession(configuration: Foundation.URLSession.shared.configuration, delegate: self, delegateQueue: Foundation.URLSession.shared.delegateQueue)
    }
    func addSSLPinning(LocalCertData data: Data, SSLValidateErrorCallBack: (()->Void)? = nil) {
        self.localCertData = data
        self.sSLValidateErrorCallBack = SSLValidateErrorCallBack
    }
    @objc func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let localCertificateData = self.localCertData {
            if let serverTrust = challenge.protectionSpace.serverTrust,
                let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0),
                let remoteCertificateData: Data = SecCertificateCopyData(certificate) as Data {
                    if localCertificateData == remoteCertificateData {
                        let credential = URLCredential(trust: serverTrust)
                        challenge.sender?.use(credential, for: challenge)
                        completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, credential)
                    } else {
                        challenge.sender?.cancel(challenge)
                        completionHandler(Foundation.URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
                        self.sSLValidateErrorCallBack?()
                    }
            } else {
                NSLog("Get RemoteCertificateData or LocalCertificateData error!")
            }
        } else {
            completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, nil)
        }
    }
    func fire() {
        buildRequest()
        buildBody()
        fireTask()
    }
    
    func buildRequest() {
        if self.method == "GET" && self.params.count > 0 {
            self.request = NSMutableURLRequest(url: URL(string: url + "?" + buildParams(self.params))!)
        }
        
        request.httpMethod = self.method
        
        if self.files.count > 0 {
            request.addValue("multipart/form-data; boundary=" + self.boundary, forHTTPHeaderField: "Content-Type")
        } else if self.params.count > 0 {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
    }
    func buildBody() {
        let data = NSMutableData()
        if self.files.count > 0 {
            if self.method == "GET" {
                NSLog("\n\n------------------------\nThe remote server may not accept GET method with HTTP body. But Pitaya will send it anyway.\n------------------------\n\n")
            }
            for (key, value) in self.params {
                data.append("--\(self.boundary)\r\n".nsdata)
                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".nsdata)
                data.append("\(value.description)\r\n".nsdata)
            }
            for file in self.files {
                data.append("--\(self.boundary)\r\n".nsdata)
                data.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(NSString(string: file.url.description).lastPathComponent)\"\r\n\r\n".nsdata)
                if let a = try? Data(contentsOf: file.url) {
                    data.append(a)
                    data.append("\r\n".nsdata)
                }
            }
            data.append("--\(self.boundary)--\r\n".nsdata)
        } else if self.params.count > 0 && self.method != "GET" {
            data.append(buildParams(self.params).nsdata)
        }
        request.httpBody = data as Data
    }
    func fireTask() {
        task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            self.callback(data, response, error)
        })
        task.resume()
    }
    // 从 Alamofire 偷了三个函数
    func buildParams(_ parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sorted(by: <) {
            let value: AnyObject! = parameters[key]
            components += self.queryComponents(key, value)
        }
        
        return (components.map{"\($0)=\($1)"} as [String]).joined(separator: "&")
    }
    func queryComponents(_ key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)", value)
            }
        } else {
            components.append(contentsOf: [(escape(key), escape("\(value)"))])
        }
        
        return components
    }
    func escape(_ string: String) -> String {
        let legalURLCharactersToBeEscaped: CFString = ":&=;+!@#$()',*" as CFString
        return CFURLCreateStringByAddingPercentEscapes(nil, string as CFString!, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
}
