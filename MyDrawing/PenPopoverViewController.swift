//
//  PopoverViewController.swift
//  MyDrawing
//
//  Created by 김정원 on 2023/11/06.
//

import UIKit

class PenPopoverViewController: UIViewController {
    var act1: (() -> Void)?
    var act2: (() -> Void)?
    var act3: (() -> Void)?
    var act4: (() -> Void)?
    var act5: (() -> Void)?

    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var btn3: UIButton!
    @IBOutlet var btn4: UIButton!
    @IBOutlet var btn5: UIButton!
    
    var lineWidthSelected = [false, false, true, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btn1.isSelected = lineWidthSelected[0]
        btn2.isSelected = lineWidthSelected[1]
        btn3.isSelected = lineWidthSelected[2]
        btn4.isSelected = lineWidthSelected[3]
        btn5.isSelected = lineWidthSelected[4]
    }

    @IBAction func width1(_ sender: UIButton) {
        act1?()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func width2(_ sender: UIButton) {
        act2?()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func width3(_ sender: UIButton) {
        act3?()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func width4(_ sender: UIButton) {
        act4?()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func width5(_ sender: UIButton) {
        act5?()
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
