//
//  CourseTableViewController.swift
//  NetworkApp
//
//  Created by Alik Nigay on 17.02.2022.
//

import UIKit

class CourseTableViewController: UITableViewController {
    
    private var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.fetchData(tableView: tableView) { courses in
            self.courses = courses
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let webVC = segue.destination as? WebViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow  else { return }
        
        let course = courses[indexPath.row]
        
        if let link = course.link, let title = course.name {
            webVC.url = link
            webVC.selectedCourse = title
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "course", for: indexPath) as! CourseCell
        setupCell(cell: cell, indexPath: indexPath)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CourseTableViewController {
    private func setupCell(cell: CourseCell, indexPath: IndexPath) {
        let course = courses[indexPath.row]
        cell.nameCourse.text = course.name
        if let numberOfLessons = course.numberOfLessons, let numberOfTests = course.numberOfTests {
            cell.numberOfLessons.text = "Number of lessons \(numberOfLessons)"
            cell.numberOfTests.text = "Number of tests \(numberOfTests)"
        }
        DispatchQueue.global().async {
            guard let url = URL(string: course.imageUrl!) else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                cell.imageCourse.image = UIImage(data: imageData)
            }
        }
    }
}
