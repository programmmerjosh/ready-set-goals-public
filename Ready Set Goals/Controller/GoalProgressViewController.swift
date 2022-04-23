//
//  GoalProgressViewController.swift
//  Ready Set Goals
//
//  Created by Joshua Van Niekerk on 22/05/2020.
//  Copyright © 2020 Josh-Dog101. All rights reserved.
//

import UIKit
import RealmSwift
import Lottie

class GoalProgressViewController: UIViewController {
    
    @IBOutlet weak var lblGoal          : UILabel!
    @IBOutlet weak var lblDateCreated   : UILabel!
    @IBOutlet weak var lblDeadline      : UILabel!
    @IBOutlet weak var deadlineSwitch   : UISwitch!
    @IBOutlet weak var datePicker       : UIDatePicker!
    @IBOutlet weak var lblDays          : UILabel!
    @IBOutlet weak var lblProgress      : UILabel!
    @IBOutlet weak var lblSaveAndExit   : UILabel!
    @IBOutlet weak var btn0             : UIButton!
    @IBOutlet weak var btn25            : UIButton!
    @IBOutlet weak var btn50            : UIButton!
    @IBOutlet weak var btn75            : UIButton!
    @IBOutlet weak var myScrollView     : UIScrollView!
    @IBOutlet weak var myScrollContentView: UIView!
    @IBOutlet weak var btn100           : UIButton!
    @IBOutlet weak var downArrowAnimation: AnimationView!
    @IBOutlet weak var btnInvisDismiss: UIButton!
    
    let realm = try! Realm()
    var selectedGoal : Goal?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let goal = selectedGoal {
            
            // goal name
            lblGoal.text = "Goal: \(goal.name)"
            
            // goal date created
            if let c_date = goal.dateCreated {
                let formatter1 = DateFormatter()
                formatter1.dateStyle = .short
                let strDate = formatter1.string(from: c_date)
                lblDateCreated.text = "Date Created: \(strDate)"
                
                // goal deadline:Bool
                if (goal.deadline) {
                    deadlineSwitch.isOn = true
                    hideDeadline(false)
                    
                    // goal deadline date & days left
                    if let d_date = goal.deadlineDate {
                        datePicker.date = d_date
                        
                        let days = daysBetween(start: c_date, end: d_date)
                        lblDays.text = "Days To Deadline: \(days)"
                    }
                } else {
                    hideDeadline(true)
                }
            }
            
            // progress
            highlightButton(tag: goal.progress)
            startArrowAnimation()
        }
    }
    
    @IBAction func dismissVC(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func deadlineValueChange(_ sender: UIDatePicker) {
        do {
            try self.realm.write {
                if let goal = selectedGoal {
                    goal.deadline = true
                    goal.deadlineDate = sender.date
                    
                    let days = daysBetween(start: goal.dateCreated!, end: sender.date)
                    lblDays.text = "Days To Deadline: \(days)"
                }
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    @IBAction func enableDeadline(_ sender: UISwitch) {
        hideDeadline(!sender.isOn)
    }
    
    @IBAction func progressButton(_ sender: UIButton) {
        do {
            try self.realm.write {
                if let goal = selectedGoal {
                    goal.progress = sender.tag
                }
            }
        } catch {
            print("error: \(error)")
        }

        highlightButton(tag: sender.tag)
    }
    
    func startArrowAnimation() {
        let arrowAnimation         = AnimationView(name: "20348-down-loop")
        arrowAnimation.contentMode = .scaleAspectFit
        self.downArrowAnimation.addSubview(arrowAnimation)
        arrowAnimation.frame       = self.downArrowAnimation.bounds
        arrowAnimation.loopMode    = .loop
        arrowAnimation.play()
    }
    
    func highlightButton(tag: Int) {
        btn0.backgroundColor    = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        btn25.backgroundColor   = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        btn50.backgroundColor   = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        btn75.backgroundColor   = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        btn100.backgroundColor  = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        switch (tag) {
        case 0:
            btn0.backgroundColor    = #colorLiteral(red: 0.9488554597, green: 0.9623991847, blue: 0.8707644343, alpha: 1)
            break
        case 25:
            btn25.backgroundColor   = #colorLiteral(red: 0.8150030971, green: 1, blue: 0.7182812095, alpha: 1)
            break
        case 50:
            btn50.backgroundColor   = #colorLiteral(red: 0.6970834136, green: 1, blue: 0.6613535881, alpha: 1)
            break
        case 75:
            btn75.backgroundColor   = #colorLiteral(red: 0.5778506398, green: 1, blue: 0.5870035291, alpha: 1)
            break
        case 100:
            btn100.backgroundColor  = #colorLiteral(red: 0.5278506875, green: 0.9059619308, blue: 0.7211794257, alpha: 1)
            
            break
        default:
            print("error")
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "checkmark"), object: nil)
    }
    
    //MARK:- daysBetween
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    func cancelDeadlineDate() {
        do {
            try self.realm.write {
                if let goal = selectedGoal {
                    goal.deadline     = false
                    goal.deadlineDate = nil
                }
            }
        } catch {
            print("error: \(error)")
        }
        datePicker.date = Date()
        lblDays.text    = "Days To Deadline: 0"
    }
    
    func hideDeadline(_ hide: Bool) {
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    
            if (hide) {
                self.lblDays.alpha    = 0
                self.datePicker.alpha = 0
                
                self.lblDays.transform              = CGAffineTransform(translationX: 0, y: -100)
                self.datePicker.transform           = CGAffineTransform(translationX: 0, y: -100)
                self.lblProgress.transform          = CGAffineTransform(translationX: 0, y: -270)
                self.btn0.transform                 = CGAffineTransform(translationX: 0, y: -270)
                self.btn25.transform                = CGAffineTransform(translationX: 0, y: -270)
                self.btn50.transform                = CGAffineTransform(translationX: 0, y: -270)
                self.btn75.transform                = CGAffineTransform(translationX: 0, y: -270)
                self.btn100.transform               = CGAffineTransform(translationX: 0, y: -270)
                self.lblSaveAndExit.transform       = CGAffineTransform(translationX: 0, y: -270)
                self.downArrowAnimation.transform   = CGAffineTransform(translationX: 0, y: -270)
                self.btnInvisDismiss.transform      = CGAffineTransform(translationX: 0, y: -270)
                self.cancelDeadlineDate()
            } else {
                self.lblDays.alpha    = 1
                self.datePicker.alpha = 1
                
                self.lblDays.transform              = CGAffineTransform(translationX: 0, y: 0)
                self.datePicker.transform           = CGAffineTransform(translationX: 0, y: 0)
                self.lblProgress.transform          = CGAffineTransform(translationX: 0, y: 0)
                self.btn0.transform                 = CGAffineTransform(translationX: 0, y: 0)
                self.btn25.transform                = CGAffineTransform(translationX: 0, y: 0)
                self.btn50.transform                = CGAffineTransform(translationX: 0, y: 0)
                self.btn75.transform                = CGAffineTransform(translationX: 0, y: 0)
                self.btn100.transform               = CGAffineTransform(translationX: 0, y: 0)
                self.lblSaveAndExit.transform       = CGAffineTransform(translationX: 0, y: 0)
                self.downArrowAnimation.transform   = CGAffineTransform(translationX: 0, y: 0)
                self.btnInvisDismiss.transform      = CGAffineTransform(translationX: 0, y: 0)
            }
        })
    }
}
