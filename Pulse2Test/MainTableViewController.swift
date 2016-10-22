//
//  MainTableViewController.swift
//  Pulse2Test
//
//  Created by Seonman Kim on 12/10/15.
//  Copyright © 2015 Harman International. All rights reserved.
//

import UIKit

let LEDPatternNames = [ "Firework", "Traffic", "Star", "Wave", "FireFly", "Rain", "Fire", "Canvas", "Hourglass", "Ripple"]

var g_ledPatternID = HMNPattern.firework

var MainTableViewControllerShared: MainTableViewController!
class MainTableViewController: UITableViewController {


    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var productIDLabel: UILabel!
    @IBOutlet weak var moduleIDLabel: UILabel!
    @IBOutlet weak var batteryChargingStatusLabel: UILabel!
    @IBOutlet weak var batteryLevelLabel: UILabel!
    
    @IBOutlet weak var linkedDeviceCountLabel: UILabel!
    
    @IBOutlet weak var activeChannelLabel: UILabel!
    
    @IBOutlet weak var audioSourceLabel: UILabel!
    
    @IBOutlet weak var macAddressLabel: UILabel!
    
    
    @IBOutlet weak var brightSlider: UISlider!
    @IBOutlet weak var ledInfoLabel: UILabel!
    
    @IBOutlet weak var ledBrightnessLabel: UILabel!
    
    @IBOutlet weak var colorSampleLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        MainTableViewControllerShared = self
        
        
        subscribeForNotification()
        HMNDeviceGeneral.connectToMasterDevice()
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        tableView.reloadData()
//    }

    func subscribeForNotification() {
        print("subscibeForNotification")
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainTableViewController.deviceConnected(_:)), name: NSNotification.Name(rawValue: EVENT_DEVICE_CONNECTED), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainTableViewController.deviceDisconnected), name: NSNotification.Name(rawValue: EVENT_DEVICE_DISCONNECTED), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainTableViewController.deviceInfoReceived(_:)), name: NSNotification.Name(rawValue: EVENT_DEVICE_INFO), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainTableViewController.sensorCaptureColorReceived(_:)), name: NSNotification.Name(rawValue: EVENT_SENSOR_CAPTURE_COLOR), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainTableViewController.patternReceived(_:)), name: NSNotification.Name(rawValue: EVENT_PATTERN_INFO), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainTableViewController.versionReceived(_:)), name: NSNotification.Name(rawValue: EVENT_VERSION), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainTableViewController.brightnessReceived(_:)), name: NSNotification.Name(rawValue: EVENT_BRIGHTNESS), object: nil)
        
    }

    func deviceConnected(_ notification: Notification) {
        print("deviceConnected")
        
        if let infoDict = (notification as NSNotification).userInfo {
            NSLog("hi");
            
            
            NSLog("yo");
            let hi:NSNumber = infoDict[KEY_IAP_CONNECTION_ID] as! NSNumber
            let f = NumberFormatter();
            f.maximumFractionDigits = 0
            //previously infoDict[KEY_IAP_CONNECTION_ID] as! String
            let s = f.string(from:hi)
            print(s! + " hi");
            //NSLog(hi as! String);
            //NSLog(infoDict[KEY_IAP_CONNECTION_ID] as! String);
            //previously let connectionID = ((infoDict[KEY_IAP_CONNECTION_ID] as AnyObject).uintValue)!;
            let connectionID = s;
            let manufacturer = infoDict[KEY_IAP_MANUFACTURER]!;
            let name = infoDict[KEY_IAP_NAME]!;
            let serial = infoDict[KEY_IAP_SERIAL_NUMBER]!;
            
            print("connection params: connectionID = \(connectionID), manufacturer = \(manufacturer), name = \(name), serial = \(serial)")
        }

        let alert = UIAlertController(title: "Connection Status", message: "Device Connected", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        updateDeviceInfoPressed(self)

    }

    func deviceDisconnected() {
        print("deviceDisonnected")
        
        let alert = UIAlertController(title: "Connection Status", message: "Device Disconnected", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)

        clearAllLabels()

    }

    func deviceInfoReceived(_ notification: Notification) {
        print("deviceInfoReceived")
        NSLog("hi");
        NSLog("hi");
        if let devInfoDict = (notification as NSNotification).userInfo {
            NSLog("hi1");
            /*
            
            let hi:NSNumber = infoDict[KEY_IAP_CONNECTION_ID] as! NSNumber
            let f = NumberFormatter();
            f.maximumFractionDigits = 0
            //previously infoDict[KEY_IAP_CONNECTION_ID] as! String
            let s = f.string(from:hi)

            
            //let devDeviceIndex = ((devInfoDict[KEY_DEVICE_INFO_DEVICE_INDEX] as AnyObject).integerValue)!
            
            
            //
            let devName = devInfoDict[KEY_DEVICE_INFO_DEVICE_NAME]!
            //
            let devProductID = ((devInfoDict[KEY_DEVICE_INFO_PRODUCT_ID] as AnyObject).integerValue)!
            //
            let devModelID = ((devInfoDict[KEY_DEVICE_INFO_MODEL_ID] as AnyObject).integerValue)!
            let devBatteryIsCharging = (devInfoDict[KEY_DEVICE_INFO_BATTERY_IS_CHARGING] as AnyObject).boolValue
            let devBatteryValue = ((devInfoDict[KEY_DEVICE_INFO_BATTERY_VALUE] as AnyObject).integerValue)!
            let devLinkedDeviceCount = ((devInfoDict[KEY_DEVICE_INFO_LINKED_DEVICE_COUNT] as AnyObject).integerValue)!
            let devActiveChannelValue = ((devInfoDict[KEY_DEVICE_INFO_ACTIVE_CHANNEL_VALUE] as AnyObject).integerValue)!
            let devAudioSourceValue = ((devInfoDict[KEY_DEVICE_INFO_AUDIO_SOURCE_VALUE] as AnyObject).integerValue)!
            let devMacAddressValue = devInfoDict[KEY_DEVICE_INFO_MAC_ADDRESS_VALUE]!

            deviceNameLabel.text = devName as? String
            productIDLabel.text = "\(devProductID)"
            moduleIDLabel.text = "\(devModelID)"
            batteryChargingStatusLabel.text = devBatteryIsCharging! ? "On" : "Off"
            batteryLevelLabel.text = "\(devBatteryValue)"
            linkedDeviceCountLabel.text = "\(devLinkedDeviceCount)"
            activeChannelLabel.text = "\(devActiveChannelValue)"
            audioSourceLabel.text = "\(devAudioSourceValue)"
            macAddressLabel.text = devMacAddressValue as? String
            
            
            print("devDeviceIndex: \(devDeviceIndex)")
            print("devName: \(devName)")
            print("devProductID: \(devProductID)")
            print("devModelID: \(devModelID)")
            print("devBatteryIsCharging: \(devBatteryIsCharging)")
            print("devBatteryValue: \(devBatteryValue)")
            print("devLinedDeviceCount: \(devLinkedDeviceCount)")
            print("devActiveChannelValue: \(devActiveChannelValue)")
            print("devAudioSourceValue: \(devAudioSourceValue)")
            print("devMacAddressValue: \(devMacAddressValue)")
 */
            

        } else {
            print("Error in deviceInfoReceived")
        }
        
        return;

    }
    
    func sensorCaptureColorReceived(_ notification: Notification) {
        print("sensorCaptureColorReceived")
        
        if let deviceInfoDict = (notification as NSNotification).userInfo {
            let R = ((deviceInfoDict[KEY_COLOR_R] as AnyObject).integerValue)!
            let G = ((deviceInfoDict[KEY_COLOR_G] as AnyObject).integerValue)!
            let B = ((deviceInfoDict[KEY_COLOR_B] as AnyObject).integerValue)!
            
            print("RGB Color: \(R), \(G), \(B)")
            colorLabel.text = "R: \(R)\nG: \(G)\nB: \(B)"
            let color = UIColor(red: CGFloat(R)/256, green: CGFloat(G)/256, blue: CGFloat(B)/256, alpha: 1.0)
            colorSampleLabel.backgroundColor = color
            
        } else {
            print("Error in sensorCaptureColorReceived")
        }
    }
    
    func patternReceived(_ notification: Notification) {
        print("patternReceived")
        
        if let deviceInfoDict = (notification as NSNotification).userInfo {
            /*
            g_ledPatternID =  HMNPattern(rawValue: ((deviceInfoDict[KEY_LED_PATTERN_ID] as AnyObject).integerValue)!)!
            print("Pattern ID: \(g_ledPatternID), name: \(LEDPatternNames[g_ledPatternID.rawValue])")
            ledInfoLabel.text = LEDPatternNames[g_ledPatternID.rawValue]
            */
        } else {
            print("Error in patternReceived")
        }

    }
    
    func versionReceived(_ notification: Notification) {
        print("versionReceived")
        
        if let deviceInfoDict = (notification as NSNotification).userInfo {
            NSLog("hi2");
            //let swVersion = (deviceInfoDict[KEY_SW_VERSION])!
            //let hwVersion = deviceInfoDict[KEY_HW_VERSION]!
            
            //versionLabel.text = "SW: \(swVersion), HW: \(hwVersion)"
            //print("SW Version: \(swVersion), HW Version: \(hwVersion)")
            
        } else {
            print("Error in patternReceived")
        }
    }
    
    func brightnessReceived(_ notification: Notification) {
        print("brightnessReceived")
        
        if let infoDict = (notification as NSNotification).userInfo {
            NSLog("kiss my ass")
            //let brightness = ((infoDict[KEY_LED_BRIGHTNESS] as AnyObject).integerValue)!
            
            //ledBrightnessLabel.text = "Set LED Brightness: \(brightness)"
            //print("brightness: \(brightness)")
            
        } else {
            print("Error in brightnessReceived")
        }
    }

    @IBAction func updateDeviceInfoPressed(_ sender: AnyObject) {
        
        HMNDeviceInfo.request()
        
        var delayTime = DispatchTime.now() + Double(Int64(1.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            HMNDFU.requestVersion()
        }
        
        delayTime = DispatchTime.now() + Double(Int64(2.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            HMNLedControl.requestLedPatternInfo()
        }
        
        delayTime = DispatchTime.now() + Double(Int64(3.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            HMNLedControl.requestLedBrightness()
        }
    }
    
    @IBAction func brightChanged(_ sender: AnyObject) {
        let brightness = UInt8(brightSlider.value)
        print("brightness: \(brightness)")
        ledBrightnessLabel.text = "Set LED Brightness: \(brightness)"
        
        HMNLedControl.setLedBrightness(brightness)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 1 {
            // Device Name
            getTextInput("Device Name", message: "Ener new device name", placeholder: "", defaultValue: deviceNameLabel.text, completion: { (returnValue) -> Void in
                if let newName = returnValue {
                    if newName != "" {
                        HMNDeviceInfo.setDeviceName(newName)
                        self.deviceNameLabel.text = newName
                    }
                }

            })
        }
        else if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 2 {
            HMNSensorControl.requestColorFromColorPicker()
        }
        else if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 3 {
            HMNLedControl.setBackgroundColor(UIColor.blue, propagateToSlaveDevice: false)
        }
        else if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 4 {
            HMNLedControl.setLedChar(65, charColor: UIColor.white, backgroundColor: UIColor.black, applyToSlaveDevice: false)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func getTextInput(_ title: String, message: String, placeholder: String, defaultValue: String?, completion: @escaping (_ returnValue: String?) -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField(configurationHandler: { (textField: UITextField) -> Void in
            textField.placeholder = placeholder
            textField.text = (defaultValue == nil) ? "" : defaultValue
        })
        let action = UIAlertAction(title: "Done", style: .default, handler: {
            (paramAction: UIAlertAction) -> Void in
            if let textFields = alertController.textFields {
                let theTextFields = textFields as [UITextField]
                let returnValue = theTextFields[0].text
                completion(returnValue)
                
            }
        })
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func changeBackground(_ sender: AnyObject) {
        HMNLedControl.setBackgroundColor(UIColor.blue, propagateToSlaveDevice: false)

    }
    
    @IBAction func requestColorFromSensor(_ sender: AnyObject) {
         HMNSensorControl.requestColorFromColorPicker()
    }
    
    @IBAction func setCharA(_ sender: AnyObject) {
        HMNLedControl.setLedChar(65, charColor: UIColor.white, backgroundColor: UIColor.black, applyToSlaveDevice: false)
    }
    
    func clearAllLabels() {
        versionLabel.text = "N/A"
        deviceNameLabel.text = "N/A"
        productIDLabel.text = "N/A"
        moduleIDLabel.text = "N/A"
        batteryChargingStatusLabel.text = "N/A"
        batteryLevelLabel.text = "N/A"
        linkedDeviceCountLabel.text = "N/A"
        activeChannelLabel.text = "N/A"
        audioSourceLabel.text = "N/A"
        macAddressLabel.text = "N/A"
    }
}
