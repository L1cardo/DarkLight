//
//  AppDelegate.swift
//  DarkLight
//
//  Created by Licardo on 2019/10/30.
//  Copyright © 2019 Licardo. All rights reserved.
//

import Cocoa
import LoginServiceKit
import MASShortcut

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    @IBOutlet weak var statusBarMenu: NSMenu!
    @IBOutlet weak var aboutWindowVersionNum: NSTextField!
    @IBOutlet weak var preferencesWindowVersionNum: NSTextField!
    @IBOutlet weak var currentAppearance: NSTextField!
    @IBOutlet weak var darkLightShortcut: MASShortcutView!
    @IBOutlet weak var launchAtLoginCheckbox: NSButton!
    @IBOutlet weak var preferencesWindow: NSWindow!
    @IBOutlet weak var aboutWindow: NSWindow!
    @IBOutlet weak var alertWindow: NSWindow!
    
    let statusBarMenuItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    
        // get current version
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        preferencesWindowVersionNum.stringValue = version
        aboutWindowVersionNum.stringValue = version
        
        // set image to status bar menu
        statusBarMenuItem.button?.image = NSImage(named: "StatusBarIcon")
        statusBarMenuItem.button?.toolTip = "Click to Switch!".localized
        
        // shortcut
        bindShortcut()
        
        launchAtLoginCheckbox.state = LoginServiceKit.isExistLoginItems() ? .on : .off

        // whether left mouse click or right mouse click on the status bar
        if let button = statusBarMenuItem.button {
            button.action = #selector(self.statusBarClicked(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        // get current appearance, dark or light
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(self.appleInterfaceThemeChangedNotification(notification:)),
            name: NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification"),
            object: nil
        )
        getCurrentAppearance()
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
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
    
    // get current appearance, dark or light
    @objc func appleInterfaceThemeChangedNotification(notification: Notification) {
        getCurrentAppearance()
    }
    
    // status bar preferences button
    @IBAction func statusBarPreferencesButton(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        aboutWindow.close()
        preferencesWindow.makeKeyAndOrderFront(sender)
    }
    
    // status bar about button
    @IBAction func statusBarAboutButton(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        preferencesWindow.close()
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
        if isChecked == true {
            LoginServiceKit.addLoginItems()
        } else {
            LoginServiceKit.removeLoginItems()
        }
    }
    
    // global shorcut
    func bindShortcut() {
        darkLightShortcut.associatedUserDefaultsKey = "darkLightSwith"
        MASShortcutBinder.shared()?.bindShortcut(withDefaultsKey: "darkLightSwith") {
            self.darkLight()
        }
    }
    
    // get current appearance, dark or light
    func getCurrentAppearance() {
        var isDarkMode = false
        if let appleInterfaceStyle = UserDefaults.standard.object(forKey: "AppleInterfaceStyle") as? String {
            if appleInterfaceStyle.lowercased().contains("dark") {
                isDarkMode = true
            }
        }
        currentAppearance.stringValue = isDarkMode ? "Dark".localized : "Light".localized
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
