//
//  AppDelegate.swift
//  Compass Menu
//
//  Created by Ben Swift on 2/10/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name("MenuIcon"))
        }
        constructMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func printQuote(_ sender: Any?) {
      let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
      let quoteAuthor = "Mark Twain"
      
      print("\(quoteText) — \(quoteAuthor)")
    }
    
    @objc func compassWeb(_ sender: Any?) {
        if let url = URL(string: "https://sites.google.com/gorhamschools.org/gorham-tech-solutions/home"),
             NSWorkspace.shared.open(url) {
            print("Success!")
        }
    }
    
    @objc func appPortal(_ sender: Any?) {
        NSWorkspace.shared.open(URL(fileURLWithPath: "/Applications/Self" + " Service.app"))
        print("/Applications/Self" + " Service.app")
    }
    
    @objc func infiniteCampus(_ sender: Any?) {
        NSWorkspace.shared.open(URL(fileURLWithPath: "/Applications/Self" + " Service.app"))
        print("/Applications/Self" + " Service.app")
    }
    
    @objc func jumprope(_ sender: Any?) {
        NSWorkspace.shared.open(URL(fileURLWithPath: "/Applications/Self" + " Service.app"))
        print("/Applications/Self" + " Service.app")
    }
    
    func constructMenu() {
        let menu = NSMenu()
        
        
        menu.addItem(NSMenuItem(title: "Compass Web", action: #selector(AppDelegate.compassWeb(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "App Portal", action: #selector(AppDelegate.appPortal(_:)), keyEquivalent: ""))
        
        var gradesMenuItem = NSMenuItem()
        gradesMenuItem.title = "Grades"
        
        var submenu = NSMenu()
        submenu.addItem(withTitle: "Infinite Campus", action: #selector(AppDelegate.infiniteCampus(_:)), keyEquivalent: "")
        submenu.addItem(withTitle: "Jumprope", action: #selector(AppDelegate.jumprope(_:)), keyEquivalent: "")
        gradesMenuItem.submenu = submenu
        
        menu.addItem(gradesMenuItem)
        menu.addItem(NSMenuItem(title: "Explore & Discover", action: #selector(AppDelegate.printQuote(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "About", action: #selector(AppDelegate.printQuote(_:)), keyEquivalent: ""))
        
        statusItem.menu = menu
    }

}

