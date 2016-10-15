//
//  DebugView.swift
//  GameFace
//
//  Created by Stanley Chiang on 10/14/16.
//  Copyright © 2016 Stanley Chiang. All rights reserved.
//

import UIKit

class DebugView: UIView, UITextFieldDelegate, GameVarDelegate {

    var dict = [String:[String:Double]]()
    var prevView:UIView!
    let spacer:CGFloat = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.cyanColor()
        
        loadDict()
        
        for option in dict {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = option.0
            addSubview(label)
            
            let input = UITextField()
            input.translatesAutoresizingMaskIntoConstraints = false
            input.delegate = self
            input.keyboardType = UIKeyboardType.NumberPad
            input.backgroundColor = UIColor.whiteColor()
            input.text = "\(option.1["value"]!)"
            addSubview(input)
            
            let stepper = UIStepper()
            stepper.translatesAutoresizingMaskIntoConstraints = false
            stepper.tag = Int(option.1["tag"]!)
            stepper.value = option.1["value"]!
            stepper.minimumValue = option.1["min"]!
            stepper.maximumValue = option.1["max"]!
            stepper.stepValue = option.1["step"]!
            
            stepper.continuous = true
            stepper.autorepeat = true
            stepper.wraps = true
            addSubview(stepper)
            
            stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), forControlEvents: .ValueChanged)
            
        }
        
    }
    
    func stepperValueChanged(sender:UIStepper!) {
        let indexOfInput = subviews.indexOf(sender)! - 1
        (subviews[indexOfInput] as! UITextField).text = "\(sender.value)"
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let indexOfStepper = subviews.indexOf(textField)! + 1
        print(Double(textField.text!)!)
        let stepper = (subviews[indexOfStepper] as! UIStepper)
        stepper.value = Double(textField.text!)!
    }
    
    func getGameStartMouthDist() -> Float {
        for view in subviews {
            if view is UIStepper && view.tag == 0 {
                return Float((view as! UIStepper).value)
            }
        }
        return 25.0
    }
    
    func setDelegate(scene:GameScene) {
        scene.gameVarDelegate = self
    }
    
    override func layoutSubviews() {
        for (index, view) in subviews.enumerate() {
            if view is UILabel {
                view.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor).active = true
                if index == 0 {
                    view.topAnchor.constraintEqualToAnchor(topAnchor, constant: spacer).active = true
                }else {
                    view.topAnchor.constraintEqualToAnchor(prevView.bottomAnchor, constant: spacer).active = true
                }
                prevView = view
            }
            
            if view is UITextField {
                view.leadingAnchor.constraintEqualToAnchor(prevView.trailingAnchor, constant: spacer).active = true
                view.centerYAnchor.constraintEqualToAnchor(prevView.centerYAnchor).active = true
                
                prevView = view
            }
            
            if view is UIStepper {
                view.leadingAnchor.constraintEqualToAnchor(prevView.trailingAnchor, constant: spacer).active = true
                view.centerYAnchor.constraintEqualToAnchor(prevView.centerYAnchor).active = true
            }
        }
    }
    
    func loadDict() {
        dict.updateValue(["tag":0,"value":25,"min":0,"max":50,"step":1], forKey: "start game mouth open distance")
        dict.updateValue(["tag":1,"value":16,"min":1,"max":51,"step":1], forKey: "open mouth drain rate")
        dict.updateValue(["tag":2,"value":17,"min":2,"max":52,"step":1], forKey: "closed mouth drain rate")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

