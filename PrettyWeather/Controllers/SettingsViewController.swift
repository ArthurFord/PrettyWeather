//
//  SettingsViewController.swift
//  PrettyWeather
//
//  Created by Arthur Ford on 12/10/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import UIKit

protocol SettingsViewDelegate {
    func changeBackgroundColor(color: String)
    func changeUnits(units: String)
}




class SettingsViewController: UIViewController {

    
    @IBOutlet weak var button00BAEE: UIButton!
    @IBOutlet weak var button0086E4: UIButton!
    @IBOutlet weak var button0B3E9E: UIButton!
    @IBOutlet weak var button0039AF: UIButton!
    @IBOutlet weak var buttonFF6B0A: UIButton!
    @IBOutlet weak var button00AC1F: UIButton!
    @IBOutlet weak var button00AC01: UIButton!
    @IBOutlet weak var button80ADDF: UIButton!
    
    @IBOutlet var colorButtons: [UIButton]!
    
    @IBOutlet weak var unitsSelected: UISegmentedControl!
    
    var delegate: SettingsViewDelegate?
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        button00BAEE.setImage(UIImage(named: K.Colors.color00BAEESel), for: .selected)
        button0086E4.setImage(UIImage(named: K.Colors.color0086E4Sel), for: .selected)
        button0B3E9E.setImage(UIImage(named: K.Colors.color0B3E9ESel), for: .selected)
        button0039AF.setImage(UIImage(named: K.Colors.color0039AFSel), for: .selected)
        buttonFF6B0A.setImage(UIImage(named: K.Colors.colorFF6B0ASel), for: .selected)
        button00AC1F.setImage(UIImage(named: K.Colors.color00AC1FSel), for: .selected)
        button00AC01.setImage(UIImage(named: K.Colors.color00A0C1Sel), for: .selected)
        button80ADDF.setImage(UIImage(named: K.Colors.color80ADDFSel), for: .selected)
        
        button00BAEE.setTitle(K.Colors.color00BAEE, for: .normal)
        button0086E4.setTitle(K.Colors.color0086E4, for: .normal)
        button0B3E9E.setTitle(K.Colors.color0B3E9E, for: .normal)
        button0039AF.setTitle(K.Colors.color0039AF, for: .normal)
        buttonFF6B0A.setTitle(K.Colors.colorFF6B0A, for: .normal)
        button00AC1F.setTitle(K.Colors.color00AC1F, for: .normal)
        button00AC01.setTitle(K.Colors.color00A0C1, for: .normal)
        button80ADDF.setTitle(K.Colors.color80ADDF, for: .normal)
        
    
    }
    
    @IBAction func colorButtonTapped(_ sender: UIButton) {

        for button in colorButtons {
            button.isSelected = false
        }
        sender.isSelected = true
        
        
        view.backgroundColor = UIColor(named: sender.title(for: .normal)!)
        delegate?.changeBackgroundColor(color: sender.title(for: .normal)!)
    }
    
    @IBAction func unitsControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            delegate?.changeUnits(units: K.imperial)
        } else if sender.selectedSegmentIndex == 1 {
            delegate?.changeUnits(units: K.celsius)
        }
        
    }
    
    
    

}
