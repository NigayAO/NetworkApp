//
//  ViewController.swift
//  NetworkApp
//
//  Created by Alik Nigay on 16.02.2022.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        fetchImage()
    }
    
    private func fetchImage() {
        activityIndicator.startAnimating()
        NetworkManager.shared.fetchImage { image in
            self.activityIndicator.stopAnimating()
            self.image.image = image
        }
    }
}

