//
//  CategoryViewController.swift
//  Ready Set Goals
//
//  Created by Joshua Van Niekerk on 20/05/2020.
//  Copyright © 2020 Josh-Dog101. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?

    fileprivate func saveAndOrLoad() {
        
        guard UserDefaults.standard.string(forKey: "run") != nil else {
            UserDefaults.standard.set(true, forKey: "run")
            addDesiredCategories()
            return
        }
        loadCategories()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let std = TableViewStandard()
        std.setStandard(tableView)
        saveAndOrLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if (cell.isSelected) {
                cell.textLabel?.textColor   = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
        
        performSegue(withIdentifier: "goToSubCategories", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem                     = UIBarButtonItem()
        backItem.title                   = "Back"
        navigationItem.backBarButtonItem = backItem
        
        let destinationVC = segue.destination as! SubCategoryViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving: \(error)")
        }
        tableView.reloadData()
    }

    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell      = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text      = category.name
            cell.textLabel?.font      = UIFont(name: "ArialHebrew-Bold", size: 20)

            cell.backgroundColor      = #colorLiteral(red: 0.5605900288, green: 0.9046006799, blue: 0.8111155629, alpha: 1)
            cell.layer.borderColor    = #colorLiteral(red: 0.7745885253, green: 0.9927111268, blue: 0.7440740466, alpha: 1)
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            cell.layer.borderWidth    = 3.0
            cell.layer.cornerRadius   = 30
        } else {
            cell.textLabel?.text = "No categories"
        }
        return cell
    }

    func addDesiredCategories() {
        let categoryNames = ["Dreams", "Long Terms Goals", "Short Term Goals", "Today"]

        for name in categoryNames {
            let newCategory = Category()
            newCategory.name = name
            save(category: newCategory)
        }
    }
}
