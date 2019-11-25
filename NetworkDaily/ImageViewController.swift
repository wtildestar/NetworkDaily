//
//  ViewController.swift
//  NetworkDaily
//
//  Created by wtildestar on 21/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit
import Alamofire

class ImageViewController: UIViewController {
    
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    private let url = "http://papers.co/wallpaper/papers.co-np75-flower-bokeh-romantic-nature-blue-1-wallpaper.jpg"
    private let largeImgUrl = "https://i.imgur.com/DO9ASUd.jpg"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        fetchImage()
    }
    
    func fetchImage() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        NetworkManager.downloadImage(url: url) { (image) in
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
        }
    }
    
    func fetchDataWithAlamofire() {
        
        AlamofireNetworkRequest.downloadImage(url: url) { (image) in
            
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
            
        }
        
    }
    
    func downloadImageWithProgress() {
        
        AlamofireNetworkRequest.onProgress = { progress in
            self.progressView.isHidden = false
            self.progressView.progress = Float(progress)
        }
        AlamofireNetworkRequest.completed = { completed in
            self.completedLabel.isHidden = false
            self.completedLabel.text = completed
        }
        AlamofireNetworkRequest.downloadImageWithProgress(url: largeImgUrl) { (image) in
            self.activityIndicator.stopAnimating()
            self.completedLabel.isHidden = true
            self.progressView.isHidden = true
            self.imageView.image = image
        }
    }
}

