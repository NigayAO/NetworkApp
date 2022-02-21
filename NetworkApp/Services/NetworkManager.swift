//
//  NetworkManager.swift
//  NetworkApp
//
//  Created by Alik Nigay on 18.02.2022.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func getRequest() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else { return }
            print(response)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func postRequest() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        let userData = ["Course": "Networking", "Lesson": "Get and Post Requests"]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else { return }
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func fetchImage(completion: @escaping (_ image: UIImage) -> Void) {
        guard let url = URL(string: "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            
        }.resume()
    }
    
    func fetchData(tableView: UITableView, completion: @escaping (_ courses: [Course]) -> Void) {
        guard let url = URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_courses") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses = try decoder.decode([Course].self, from: data)
                completion(courses)
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            } catch {
                print("Error serialization json", error)
            }
        }.resume()
    }
    
    func uploadImage() {
        guard let url = URL(string: "https://api.imgur.com/3/image") else { return }
        let image = UIImage(named: "Notification")!
        let httpHeaders = ["Authorization": "Client-ID 1bd22b9ce396a4c"]
        guard let imageProperties = ImageProperties(withImage: image, forKey: "image") else { return }
        var request = URLRequest(url: url)
        request.httpBody = imageProperties.image
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeaders
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else { return }
            print(response)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
}
