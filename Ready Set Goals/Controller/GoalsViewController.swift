//
//  GoalsViewController.swift
//  Ready Set Goals
//
//  Created by Joshua Van Niekerk on 20/05/2020.
//  Copyright © 2020 Josh-Dog101. All rights reserved.
//

import UIKit
import RealmSwift

class GoalsViewController: SwipeTableViewController, UITextViewDelegate {
    
    let realm = try! Realm()
    
    var goals               : Results<Goal>?
    var selectedSubCategory : SubCategory? {
        didSet{
            loadGoals()
        }
    }
    var theKeyboardHeight:CGFloat = 0
    var alertVC          : UIAlertController?
    
    var goal             : Goal?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let std = TableViewStandard()
        std.setStandard(tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadGoals), name: NSNotification.Name(rawValue: "checkmark"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedSubCategory?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadGoals()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell    = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let goal = goals?[indexPath.row] {
            cell.textLabel?.text          = goal.name
            cell.accessoryType            = goal.progress == 100 ? .checkmark : .none
            cell.textLabel?.font          = UIFont(name: "ArialHebrew-Bold", size: 14)
            cell.backgroundColor          = goal.progress == 100 ? #colorLiteral(red: 0.5701336861, green: 0.9909743667, blue: 0.5793196559, alpha: 1) :  #colorLiteral(red: 0.5278506875, green: 0.9059619308, blue: 0.7211794257, alpha: 1)
            cell.layer.borderColor        = #colorLiteral(red: 0.8150030971, green: 1, blue: 0.7182812095, alpha: 1)
            cell.textLabel?.textColor     = goal.progress == 100 ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.layer.borderWidth        = 3.0
            cell.textLabel?.numberOfLines = 0
            cell.layer.cornerRadius       = 20
        } else {
            cell.textLabel?.text = "No goals added yet"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goal              = selectedSubCategory?.goals.sorted(byKeyPath: "name")[indexPath.row]
        performSegue(withIdentifier: "goToGoalProgress", sender: self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        let newText       = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 71
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC          = segue.destination as! GoalProgressViewController
        destinationVC.selectedGoal = goal
    }
    
    // MARK: - Delete Data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let goal = goals?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(goal)
                }
            } catch {
                print("Error deleting item: \(error)")
            }
        }
        tableView.reloadData()
    }

    // MARK: - Add button pressed
    
    fileprivate func addGoal(textView: UITextView) {
        if let currentSubCategory = self.selectedSubCategory {
            do {
                if let text = textView.text { 
                    if (text != "" && text != "Add Goal Here:") {
                        try self.realm.write {
                            let goal  = Goal()
                            goal.name = textView.text!
                            goal.dateCreated = Date()
                            currentSubCategory.goals.append(goal)
                        }
                    }
                }
            } catch {
                print("error: \(error)")
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "\n", message: nil, preferredStyle: UIAlertController.Style.alert)

        let margin:CGFloat = 8.0
        let rect           = CGRect(x: margin, y: margin, width: alertController.view.bounds.size.width - margin * 16.0, height: 60.0)
        let customView     = UITextView(frame: rect)

        customView.backgroundColor = UIColor.clear
        customView.font            = UIFont(name: "Helvetica", size: 14)
        customView.text            = "Add Goal Here:"
        customView.textColor       = UIColor.lightGray

        customView.delegate        = self
        customView.returnKeyType   = UIReturnKeyType.done

        alertController.view.addSubview(customView)

        let addGoalAction = UIAlertAction(title: "Add Goal", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
            self.addGoal(textView: customView)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {(alert: UIAlertAction!) in })

        alertController.addAction(addGoalAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion:{})
    }
    
    
    @objc func loadGoals() {
        goals = selectedSubCategory?.goals.sorted(byKeyPath: "name")
        tableView.reloadData()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            let customTextColor = UIColor(named: "CustomTextColor")
            textView.text       = nil
            textView.textColor  = customTextColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text       = "Add Goal Here:"
            textView.textColor  = UIColor.lightGray
        }
    }
}
