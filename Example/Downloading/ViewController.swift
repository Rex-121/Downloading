//
//  ViewController.swift
//  Downloading
//
//  Created by Tyrant on 09/02/2020.
//  Copyright (c) 2020 Tyrant. All rights reserved.
//

import UIKit

import Downloading

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? "")

        do {
            let task = try DownloadTask(DownloadItem(from: "http://192.168.1.227:81/xxupload/PPTS.zip", to: .caches()))
            
            task.progress { (progress) in
                print(progress.progress)
            }
            
            task.resume()
        } catch {
            print(error)
        }
        
    }

}
