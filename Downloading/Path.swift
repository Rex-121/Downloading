//
//  Path.swift
//  Downloading
//
//  Created by Tyrant on 2020/9/3.
//

import Foundation

/// 下载至本地路径:
/// - Parameters:
///   - caches: caches(文件夹，如果填写文件夹，会自动生成。eg：abc/aaa)
///   - document: document(文件夹，如果填写文件夹，会自动生成。eg：abc/aaa)
public enum Path {
    
    case caches(String = ""), document(String = "")
    
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
        // swiftlint:disable force_unwrapping
        var path = FileManager.default.urls(for: directory, in: .userDomainMask).first!
        path.appendPathComponent(pathComponent)
        return path
    }
    
}
