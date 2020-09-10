//
//  DownloadProvider.swift
//  Downloading
//
//  Created by Tyrant on 2020/9/2.
//

import Alamofire

public typealias DownloadResponse<Value> = Alamofire.DownloadResponse<Value>

public protocol DownloadingProtocol {
    
    /// 取消
    func cancel(createResumeData: Bool)
    
    /// 恢复/启动
    func resume()
    
    /// 暂停
    func suspend()
    
}

/// 下载元素
public struct DownloadItem {
    /// 文件地址
    public let from: String
    /// 文件名称
    let fileName: String?
    /// 下载至`地址`
    let to: Path
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

open class DownloadTask: DownloadingProtocol {
    public func cancel(createResumeData: Bool = true) {
        task.cancel(createResumeData: createResumeData)
//        print(task.resumeData)
    }
    
    public func resume() {
        task.resume()
    }
    
    public func suspend() {
        task.suspend()
    }
    
    public init(_ target: DownloadItem, callbackQueue: DispatchQueue? = nil) throws {
        
        guard let url = URL(string: target.from) else { throw Wrong.wrongURL }
        
        self.task = Alamofire.download(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, to: { _, response in
            
            /// 下载至
            let destinationPath = target.to.path.appendingPathComponent(target.fileName ?? (response.suggestedFilename ?? "Unknow"))
            
            /// 是否删除之前的文件
            if target.removePreviousFile {
                return (destinationPath, [.createIntermediateDirectories, .removePreviousFile])
            } else {
                return (destinationPath, [.createIntermediateDirectories])
            }
        })
                
    }
        
    open func progress(queue: DispatchQueue = DispatchQueue.main, closure: @escaping (Progress) -> Void) {
        task.downloadProgress(queue: queue) { (progress) in
            let p = Progress(progress: progress.completedUnitCount, total: progress.totalUnitCount, fractionCompleted: progress.fractionCompleted)
            closure(p)
        }
    }
    
    open func data(queue: DispatchQueue = DispatchQueue.main, closure: @escaping (DownloadResponse<Data>) -> Void) {
        task.responseData(queue: queue, completionHandler: closure)
    }

    private let task: DownloadRequest
    
}
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
