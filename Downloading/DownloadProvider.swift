//
//  DownloadProvider.swift
//  Downloading
//
//  Created by Tyrant on 2020/9/2.
//

import Alamofire


/// 下载至本地路径:
/// - Parameters:
///   - caches: caches(文件夹，如果填写文件夹，会自动生成。eg：abc/aaa)
///   - document: document(文件夹，如果填写文件夹，会自动生成。eg：abc/aaa)
public enum Path {
    
    case caches(String), document(String)
    
    var pathComponent: String {
        switch self {
        case .caches(let path), .document(let path):return path
        }
    }
    
    /// 文件夹
    var directory: FileManager.SearchPathDirectory {
        switch self {
        case .caches: return .cachesDirectory
        case .document: return .documentDirectory
        }
    }
    
    /// 路径
    var path: URL {
        var path = FileManager.default.urls(for: directory, in: .userDomainMask).first!
        path.appendPathComponent(pathComponent)
        return path
    }
    
}

/// 下载元素
public struct DownloadItem {
    /// 文件地址
    public let from: String
    /// 文件名称
    let fileName: String?
    /// 下载至`地址`
    public let to: Path
    /// 删除之前的文件
    let removePreviousFile: Bool
    /// 文件下载
    /// - Parameters:
    ///   - from: 文件地址
    ///   - to: 下载至`地址`
    ///   - removePreviousFile: 删除之前的文件
    ///   - fileName: 文件名称（默认为服务器文件名称）
    public init(from: String, to: Path, removePreviousFile: Bool = true, fileName: String? = nil) {
        self.from = from
        self.to = to
        self.fileName = fileName
        self.removePreviousFile = removePreviousFile
    }
}



open class DownloadProvider {
    
//    let callbackQueue: DispatchQueue?
//    
//    public init(callbackQueue: DispatchQueue? = nil){
//        self.callbackQueue = callbackQueue
//    }
    
    public init() { }
    
    
    
    open func download(_ target: DownloadItem, callbackQueue: DispatchQueue? = nil) -> DownloadRequest {
        
        let destination: DownloadRequest.DownloadFileDestination = { temporaryURL, response in
            
            /// 下载至
            let destinationPath = target.to.path.appendingPathComponent(target.fileName ?? response.suggestedFilename!)
            
            /// 是否删除之前的文件
            if target.removePreviousFile {
                return (destinationPath, [.createIntermediateDirectories, .removePreviousFile])
            }
            else {
                return (destinationPath, [.createIntermediateDirectories])
            }
        }
        
        return Alamofire.download(URL(string: target.from)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, to: destination)
        
        
        //        if var p = target.destinationFullPath{
        //            do {
        //                p = p.appendingPathComponent("downloadTmpName")
        //
        //                let tmpData = try Data(contentsOf: p)
        //
        //                if tmpData.count > 0 {
        //
        //                    return Alamofire.download(resumingWith: tmpData, to: destination)
        //                }
        //
        //            } catch {
        //
        //            }
        //
        //        }
        
    }
    
    
    
}




