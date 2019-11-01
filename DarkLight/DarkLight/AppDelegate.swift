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
    @IBOutlet weak var aboutWindowVersionNum: NSTextField!
    @IBOutlet weak var preferencesWindowVersionNum: NSTextField!
    @IBOutlet weak var darkLightShortcut: MASShortcutView!
    @IBOutlet weak var launchAtLoginCheckbox: NSButton!
    @IBOutlet weak var preferencesWindow: NSWindow!
    @IBOutlet weak var aboutWindow: NSWindow!
    @IBOutlet weak var alertWindow: NSWindow!
    
    let statusBarMenuItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    
        aboutWindowVersionNum.stringValue = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        preferencesWindowVersionNum.stringValue = aboutWindowVersionNum.stringValue
        
        statusBarMenuItem.button?.image = NSImage(named: "StatusBarIcon")
        statusBarMenuItem.button?.toolTip = "DarkLight"
        
        darkLightShortcut.associatedUserDefaultsKey = "darkLightSwith"
        
        launchAtLoginCheckbox.state = LaunchAtLogin.isEnabled ? .on : .off
        
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
    
    // status bar preferences button
    @IBAction func statusBarPreferencesButton(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        preferencesWindow.makeKeyAndOrderFront(sender)
    }
    
    // status bar about button
    @IBAction func statusBarAboutButton(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        aboutWindow.makeKeyAndOrderFront(sender)
    }
    
    // status bar quit button
    @IBAction func statusBarQuitButton(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        alertWindow.makeKeyAndOrderFront(sender)
    }
    
    // preferences window close button
    @IBAction func preferencesWindowClosetButton(_ sender: Any) {
        preferencesWindow.close()
    }
    
    // preferences window quit button
    @IBAction func preferencesWindowQuitButton(_ sender: NSButton) {
        NSApp.activate(ignoringOtherApps: true)
        alertWindow.makeKeyAndOrderFront(sender)
    }
    
    // alert window yes button
    @IBAction func alertWindowYesButton(_ sender: NSButton) {
        NSApp.terminate(self)
    }
    
    // alert window cancel button
    @IBAction func alertWindowCancelButton(_ sender: NSButton) {
        alertWindow.close()
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
        let w = button.window
        let location = button.superview!.convert(NSMakePoint(x, y), to: nil)
        let event = NSEvent.mouseEvent(with: .leftMouseUp,
                                       location: location,
                                       modifierFlags: NSEvent.ModifierFlags(rawValue: 0),
                                       timestamp: 0,
                                       windowNumber: w!.windowNumber,
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
