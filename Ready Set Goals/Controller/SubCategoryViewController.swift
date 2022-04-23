//
//  SubCategoryViewController.swift
//  Ready Set Goals
//
//  Created by Joshua Van Niekerk on 20/05/2020.
//  Copyright © 2020 Josh-Dog101. All rights reserved.
//

import UIKit
import RealmSwift

class SubCategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    // receiving
    var subCategories   : Results<SubCategory>?
    var selectedCategory: Category? {
        didSet {
            if UserDefaults.standard.string(forKey: selectedCategory!.name) != nil {
                loadSubCats()
            } else {
                UserDefaults.standard.set(true, forKey: selectedCategory!.name)
                addDesiredSubCategories()
            }
        }
    }

    // sending
    var SubCat: SubCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let std = TableViewStandard()
        std.setStandard(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if (cell.isSelected) {
                cell.textLabel?.textColor   = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
        
        SubCat              = selectedCategory?.subCategories[indexPath.row]
        performSegue(withIdentifier: "goToGoals", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        let destinationVC = segue.destination as! GoalsViewController
        destinationVC.selectedSubCategory = SubCat
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCategory?.subCategories.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell                = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let subCategoryName     = selectedCategory?.subCategories[indexPath.row].name
        
        cell.textLabel?.text        = subCategoryName
        cell.textLabel?.font        = UIFont(name: "ArialHebrew-Bold", size: 20)
        cell.backgroundColor        = #colorLiteral(red: 0.6970834136, green: 1, blue: 0.6613535881, alpha: 1)
        cell.layer.borderColor      = #colorLiteral(red: 0.9174748063, green: 0.9309576154, blue: 0.8434926867, alpha: 1)
        cell.textLabel?.textColor   = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        cell.layer.borderWidth      = 3.0
        cell.layer.cornerRadius     = 20
        return cell
    }
    
    fileprivate func addDesiredSubCategories() {
        if let category = selectedCategory {
            
            var subCatNames = [""]
            
            switch (category.name) {
            case "Dreams":
                subCatNames = ["Destinations", "Material Possessions", "Achievements", "Experiences", "Family/Relationships"]
                break
            case "Long Terms Goals":
                subCatNames = ["Financial", "Achievments", "Health/Fitness", "Family/Relationships", "Education", "Languages", "Skills", "Work"]
                break
            case "Short Term Goals":
                subCatNames = ["Financial", "Achievments", "Health/Fitness", "Family/Relationships", "Education", "Skills", "Work"]
                break
            case "Today":
                subCatNames = ["Must Do’s", "Should Do’s", "Bonus Tasks"]
                break
            default:
                print("error")
            }
            
            for name in subCatNames {
                do {
                    try self.realm.write {
                        let subcat  = SubCategory()
                        subcat.name = name
                        category.subCategories.append(subcat)
                    }
                } catch {
                    print("error: \(error)")
                }
            }
        }
        tableView.reloadData()
    }
    
    func loadSubCats() {
        subCategories = selectedCategory?.subCategories.sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
}
