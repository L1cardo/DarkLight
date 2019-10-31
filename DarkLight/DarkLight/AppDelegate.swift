//
//  AppDelegate.swift
//  DarkLight
//
//  Created by Licardo on 2019/10/30.
//  Copyright © 2019 Licardo. All rights reserved.
//

import Cocoa
import LaunchAtLogin
import MASShortcut

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    @IBOutlet weak var statusBarMenu: NSMenu!
    @IBOutlet weak var aboutPanelVersionNum: NSTextField!
    @IBOutlet weak var preferencesPanelVersionNum: NSTextField!
    @IBOutlet weak var darkLightShortcut: MASShortcutView!
    @IBOutlet weak var launchAtLoginCheckbox: NSButton!
    
    let statusBarMenuItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    
        aboutPanelVersionNum.stringValue = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        preferencesPanelVersionNum.stringValue = aboutPanelVersionNum.stringValue
        
            statusBarMenuItem.button?.image = NSImage(named: "StatusBarIcon")
        statusBarMenuItem.button?.toolTip = "DarkLight"
        
        darkLightShortcut.associatedUserDefaultsKey = "darkLightSwith"
        
        bindShortcut()
        
        if let button = statusBarMenuItem.button {
            button.action = #selector(self.statusBarClicked(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // whether left mouse click or right mouse click
    @objc func statusBarClicked(sender: NSStatusBarButton) {
        let mouseEvent = NSApp.currentEvent!
        if mouseEvent.type == NSEvent.EventType.leftMouseUp {
            darkLight()
        } else if mouseEvent.type == NSEvent.EventType.rightMouseUp {
            displayStatusBarMenu()
        }
    }
    
    // quit button
    @IBAction func quitDarkLight(_ sender: NSMenuItem) {
        NSApp.terminate(self)
    }
    
    // launch at login checkbox
    @IBAction func launchAtLoginChecked(_ sender: NSButton) {
        let isChecked = launchAtLoginCheckbox.state == .on
        LaunchAtLogin.isEnabled = isChecked ? true : false
    }
    
    // display status menu
    func displayStatusBarMenu() {
        guard let button = statusBarMenuItem.button else { return }
        let x = button.frame.origin.x
        let y = button.frame.origin.y - 5
        let location = button.superview!.convert(NSMakePoint(x, y), to: nil)
        let event = NSEvent.mouseEvent(with: .leftMouseUp,
                                       location: location,
                                       modifierFlags: NSEvent.ModifierFlags(rawValue: 0),
                                       timestamp: 0,
                                       windowNumber: button.window!.windowNumber,
                                       context: NSGraphicsContext.init(),
                                       eventNumber: 0,
                                       clickCount: 1,
                                       pressure: 0)!
        NSMenu.popUpContextMenu(statusBarMenu, with: event, for: button)
        
    }
    // dark light mode switch
    func darkLight() {
        let darkLightScript = """
            tell app "System Events" to tell appearance preferences to set dark mode to not dark mode
        """

        let script = NSAppleScript(source: darkLightScript)
        script!.executeAndReturnError(nil)
    }
    
    // about panel urls
    @IBAction func github(_ sender: Any) {
        guard let url = URL(string: "https://github.com/L1cardo") else {return}
        NSWorkspace.shared.open(url)
    }
    @IBAction func homePage(_ sender: Any) {
        guard let url = URL(string: "https://licardo.cn") else {return}
        NSWorkspace.shared.open(url)
    }
    @IBAction func twitter(_ sender: Any) {
        guard let url = URL(string: "https://twitter.com/AlbertAbdilim") else {return}
        NSWorkspace.shared.open(url)
    }
    @IBAction func paypal(_ sender: Any) {
        guard let url = URL(string: "https://paypal.me/mrlicardo") else {return}
        NSWorkspace.shared.open(url)
    }
    @IBAction func alipay(_ sender: Any) {
        guard let url = URL(string: "https://raw.githubusercontent.com/L1cardo/Image-Hosting/master/donate/alipay.jpg") else {return}
        NSWorkspace.shared.open(url)
    }
    @IBAction func wechat(_ sender: Any) {
        guard let url = URL(string: "https://raw.githubusercontent.com/L1cardo/Image-Hosting/master/donate/wechat.jpg") else {return}
        NSWorkspace.shared.open(url)
    }
    @IBAction func email(_ sender: Any) {
        guard let url = URL(string: "mailto:albert.abdilim@foxmail.com") else {return}
        NSWorkspace.shared.open(url)
    }
}

extension AppDelegate {
    // global shorcut
    func bindShortcut() {
        MASShortcutBinder.shared()?.bindShortcut(withDefaultsKey: "darkLightSwith") {
            self.darkLight()
        }
    }
}
