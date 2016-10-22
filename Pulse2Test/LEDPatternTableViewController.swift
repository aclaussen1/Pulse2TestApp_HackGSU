//
//  LEDPatternTableViewController.swift
//  Pulse2Test
//
//  Created by Seonman Kim on 12/10/15.
//  Copyright © 2015 Harman International. All rights reserved.
//

import UIKit

class LEDPatternTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LEDPatternNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LEDPattern_Cell", for: indexPath)
        cell.textLabel?.text = LEDPatternNames[(indexPath as NSIndexPath).row]

        if indexPath.row == g_ledPatternID.rawValue {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        g_ledPatternID = HMNPattern(rawValue: indexPath.row)!
        if g_ledPatternID ==  HMNPattern.fireFly || g_ledPatternID == HMNPattern.canvas {
            let imageMatrix = [
                0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,
                0,	0,	0,	0,	0,	0,	0,	0,	1,	1,	0,
                0,	0,	0,	0,	0,	0,	0,	1,	0,	1,	0,
                0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,
                0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,
                0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,
                0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,
                0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,
                0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0
            ];

            var array = [NSNumber]()
            for i  in 0...LED_COUNT-1 {
                array.append(imageMatrix[i] as NSNumber)
            }
            HMNLedControl.setLedPattern(g_ledPatternID, withData: array)
        }
        else {
            HMNLedControl.setLedPattern(g_ledPatternID, withData: nil)
        }
        MainTableViewControllerShared.ledInfoLabel.text = LEDPatternNames[g_ledPatternID.rawValue]
        tableView.reloadData()
        
    }
    
    
    



}
