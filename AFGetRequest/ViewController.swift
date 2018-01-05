//
//  ViewController.swift
//  AFGetRequest
//
//  Created by Manoj Kulkarni on 1/4/18.
//  Copyright © 2018 Manoj Kulkarni. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUrl(url: "https://cdn1.iconfinder.com/data/icons/simple-icons/4096/apple-4096-black.png")
    }

    func fetchUrl(url : String){
        
        let dest : DownloadRequest.DownloadFileDestination = {_,_ in            //repeatedly download in a destination
            let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileUrl = docUrl.appendingPathComponent("the_punisher.jpg")
            return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        
        //print JSON
        Alamofire.request(url).responseString { (response) in
            print(response.value)
            debugPrint(response)
        }.responseJSON { (response) in
            print(response.value)
        }.authenticate(user: "bear", password: "test")
        
        
        //download image
        Alamofire.download(url, to: dest).responseData { (response) in
            if let data = response.value {
                let image = UIImage.init(data: data)
                let imageView = UIImageView.init(frame: self.view.frame)
                imageView.image = image
                imageView.contentMode = .scaleAspectFill
                DispatchQueue.main.async {          //update the main thread
                    self.view.addSubview(imageView)
                }
            }
        }.downloadProgress { (progress) in
            print("\(progress.fractionCompleted)")
        }
        
    }

}

