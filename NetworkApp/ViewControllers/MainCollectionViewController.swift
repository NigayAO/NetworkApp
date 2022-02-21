//
//  MainCollectionViewController.swift
//  NetworkApp
//
//  Created by Alik Nigay on 18.02.2022.
//

import UIKit
import UserNotifications

enum ButtonTitles: String, CaseIterable {
    case downloadImage = "Download Image"
    case getRequest = "GET Request"
    case postRequest = "POST Request"
    case allCourses = "All Courses"
    case uploadImage = "Upload Image"
    case downloadFile = "Download File"
}

class MainCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "Cell"
    private let titleForCells = ButtonTitles.allCases
    private let dataProvider = DataProvider()
    private var alert: UIAlertController!
    private var filePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotification()
        
        dataProvider.fileLocation = { location in
            print("Download finished: \(location.absoluteString)")
            self.filePath = location.absoluteString
            self.postNotification()
            self.alert.dismiss(animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titleForCells.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionCell
        let title = titleForCells[indexPath.row]
        cell.textLabel.text = title.rawValue
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = titleForCells[indexPath.row]
        switch title {
        case .downloadImage:
            performSegue(withIdentifier: "ShowImage", sender: self)
        case .getRequest:
            NetworkManager.shared.getRequest()
        case .postRequest:
            NetworkManager.shared.postRequest()
        case .allCourses:
            performSegue(withIdentifier: "OurCorses", sender: self)
        case .uploadImage:
            NetworkManager.shared.uploadImage()
        case .downloadFile:
            showAlert()
            dataProvider.startDownload()
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

//MARK: - AlertController
extension MainCollectionViewController {
    
    private func showAlert() {
        alert = UIAlertController(title: "Downloading...", message: "0 %", preferredStyle: .alert)
        
        let height = NSLayoutConstraint(
            item: alert.view,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 0,
            constant: 170
        )
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            self.dataProvider.stopDownload()
        }
        alert.addAction(cancel)
        alert.view.addConstraint(height)
        present(alert, animated: true) {
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(
                x: self.alert.view.frame.width / 2 - size.width / 2,
                y: self.alert.view.frame.height / 2 - size.height / 2
            )
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alert.view.frame.height - 44, width: self.alert.view.frame.width, height: 2))
            progressView.tintColor = .blue

            self.dataProvider.onProgress = { progress in
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
            }
            
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
        }
    }
}

//MARK: - Push Notification
extension MainCollectionViewController {
    private func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in
            
        }
    }
    
    private func postNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Download complete!"
        content.body = "Your background transfer has completed. File path \(filePath!)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TransferComplete", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
