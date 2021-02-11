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
    
    @objc func explore(_ sender: Any?) {
        if let url = URL(string: "https://sites.google.com/gorhamschools.org/gorham-tech-solutions/explore"),
             NSWorkspace.shared.open(url) {
            print("Success!")
        }
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
        if let url = URL(string: "https://campus.gorhamschools.org/campus/portal/gorham.jsp"),
             NSWorkspace.shared.open(url) {
            print("Success!")
        }
    }
    
    @objc func jumprope(_ sender: Any?) {
        if let url = URL(string: "https://campus.gorhamschools.org/campus/portal/gorham.jsp"),
             NSWorkspace.shared.open(url) {
            print("Success!")
        }
    }
    
    // GET SERIAL NUMBER
    
    var serialNumber: String? {
        let platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        guard platformExpert > 0 else {
            return nil
        }
        
        guard let serialNumber = (IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0).takeUnretainedValue() as? String)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else {
            return nil
        }
        
        IOObjectRelease(platformExpert)
        
        return serialNumber
    }
    
    // GET IP ADDRESS
    
    func getIFAddresses() -> [String] {
        var addresses = [String]()

        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }

        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            let addr = ptr.pointee.ifa_addr.pointee

            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }

        freeifaddrs(ifaddr)
        return addresses
    }
    
    func bootTime() -> Date? {
        var tv = timeval()
        var tvSize = MemoryLayout<timeval>.size
        let err = sysctlbyname("kern.boottime", &tv, &tvSize, nil, 0);
        guard err == 0, tvSize == MemoryLayout<timeval>.size else {
            return nil
        }
        return Date(timeIntervalSince1970: Double(tv.tv_sec) + Double(tv.tv_usec) / 1_000_000.0)
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm a '-' MMM dd, yyyy"

        if let date = dateFormatterGet.date(from: "\(date)") {
            return dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
        }
        
        return dateFormatterPrint.string(from: date)
    }
    
    func getUsername() -> String {
        let user = NSFullUserName()
        var userFullName = String()
        
        if user.contains(".") {
            let period = "."
            let username = user.components(separatedBy: period)
            userFullName = "\(username[0].capitalized)"
        } else if user.contains(" ") {
            let space = " "
            let username = user.components(separatedBy: space)
            userFullName = "\(username[0].capitalized)"
        } else {
            userFullName = "\(user)"
        }
        
        return userFullName
    }
    
    // CONSTRUCT MENU
    
    func constructMenu() {
        let menu = NSMenu()
        
        let compassWeb = NSMenuItem()
        compassWeb.title = "Compass Web"
        compassWeb.isEnabled = true
        compassWeb.action = #selector(AppDelegate.compassWeb(_:))
        let compassWebimage = NSImage(named: "globe")
        compassWebimage?.size = NSSize(width: 15, height: 15)
        compassWeb.image = compassWebimage
        menu.addItem(compassWeb)
        
        let appPortal = NSMenuItem()
        appPortal.title = "App Portal"
        appPortal.isEnabled = true
        appPortal.action = #selector(AppDelegate.appPortal(_:))
        let appPortalImage = NSImage(named: "app")
        appPortalImage?.size = NSSize(width: 15, height: 15)
        appPortal.image = appPortalImage
        menu.addItem(appPortal)
        
        let gradesMenuItem = NSMenuItem()
        gradesMenuItem.title = "Grades"
        gradesMenuItem.isEnabled = true
        let gradesMenuItemImage = NSImage(named: "grades")
        gradesMenuItemImage?.size = NSSize(width: 15, height: 15)
        gradesMenuItem.image = gradesMenuItemImage
        
        let submenu = NSMenu()
        submenu.addItem(withTitle: "Infinite Campus", action: #selector(AppDelegate.infiniteCampus(_:)), keyEquivalent: "")
        submenu.addItem(withTitle: "Jumprope", action: #selector(AppDelegate.jumprope(_:)), keyEquivalent: "")
        gradesMenuItem.submenu = submenu
        menu.addItem(gradesMenuItem)
        
        let explore = NSMenuItem()
        explore.title = "Explore & Discover"
        explore.isEnabled = true
        explore.action = #selector(AppDelegate.explore(_:))
        let exploreImage = NSImage(named: "explore")
        exploreImage?.size = NSSize(width: 15, height: 15)
        explore.image = exploreImage
        menu.addItem(explore)
        
        menu.addItem(NSMenuItem.separator())
        
        let infoMenuItem = NSMenuItem()
        infoMenuItem.title = "\(getUsername())'s Device Info:"
        infoMenuItem.isEnabled = false
        menu.addItem(infoMenuItem)
        let spaceMenuItem = NSMenuItem()
        spaceMenuItem.title = "--"
        spaceMenuItem.isEnabled = false
        menu.addItem(spaceMenuItem)
        
        let nameMenuItem = NSMenuItem()
        nameMenuItem.title = "Username: \(NSUserName())"
        nameMenuItem.isEnabled = false
        menu.addItem(nameMenuItem)
        
        let ipMenuItem = NSMenuItem()
        ipMenuItem.title = "IP Address: \(getIFAddresses()[1])"
        ipMenuItem.isEnabled = false
        menu.addItem(ipMenuItem)
        
        let serialNumberMenuItem = NSMenuItem()
        serialNumberMenuItem.title = "Serial Number: \(serialNumber!)"
        serialNumberMenuItem.isEnabled = false
        menu.addItem(serialNumberMenuItem)
        
        let osMenuItem = NSMenuItem()
        osMenuItem.title = "Version: macOS \(ProcessInfo.processInfo.operatingSystemVersion.majorVersion).\(ProcessInfo.processInfo.operatingSystemVersion.minorVersion).\(ProcessInfo.processInfo.operatingSystemVersion.patchVersion)"
        osMenuItem.isEnabled = false
        menu.addItem(osMenuItem)
        
        let lastRestartMenuItem = NSMenuItem()
        lastRestartMenuItem.title = "Last Restart: \(formatDate(date: bootTime()!))"
        lastRestartMenuItem.isEnabled = false
        menu.addItem(lastRestartMenuItem)
        
        menu.addItem(NSMenuItem(title: "Other", action: #selector(AppDelegate.explore(_:)), keyEquivalent: ""))
        
        statusItem.menu = menu
    }

}

