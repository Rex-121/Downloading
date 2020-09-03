//
//  Progress.swift
//  Downloading
//
//  Created by Tyrant on 2020/9/3.
//

public struct Progress {
    
    public let completed: MB
    
    public let total: MB
    
    public let fractionCompleted: Double
    
    init(progress: Int64, total: Int64, fractionCompleted: Double) {
        
        self.completed = .init(bytes: progress)
        
        self.total = .init(bytes: total)
        
        self.fractionCompleted = fractionCompleted
    }
    
    public var progress: String {
        return "\(completed.description)/\(total.description)"
    }
    
}

public struct MB: CustomStringConvertible {
    
    private let bytes: Int64
    
    init(bytes: Int64) {
        self.bytes = bytes
    }
    
    var mb: Float {
        return Float(bytes) / 1000 / 1000
    }
    
    public var description: String {
        return String(format: "%.2f MB", mb)
    }
    
}
