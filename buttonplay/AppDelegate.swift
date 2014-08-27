//
//  AppDelegate.swift
//  buttonplay
//
//  Created by sean smith on 8/25/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

import Cocoa

class SyncMetaData {
    var origin: NSURL?
    var target: NSURL?
    var syncStatus = false
}

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var mainLabel: NSTextField!
    @IBOutlet weak var targetText: NSTextField!
    @IBOutlet weak var originText: NSTextField!
    @IBOutlet weak var commandOutput: NSTextField!
    @IBOutlet weak var dryRun: NSButton!

    var syncOption = SyncMetaData()
    
    @IBAction func targetButtonAction(sender: NSButton) {
        let targetDirectory = getAbsoluteURLOfDirectory()
        targetText.stringValue = targetDirectory.path
        syncOption.target = targetDirectory
    }
    
    @IBAction func originButtonAction(sender: NSButton) {
        let targetDirectory = getAbsoluteURLOfDirectory()
        originText.stringValue = targetDirectory.path
        syncOption.origin = targetDirectory
    }
    
    @IBAction func doSomething(sender: NSButton) {
        commandOutput.stringValue = ""
        commandOutput.stringValue.extend("----------------\n")

        let targetPath = syncOption.target?.path
        let targetAbsPath = syncOption.target?.absoluteString
        let sourcePath = syncOption.origin?.path
        let sourceAbsPath = syncOption.origin?.absoluteString
        
        var RD_SOURCE_ARGS = ["-rv"]
        
        if dryRun.state == 1 {
            RD_SOURCE_ARGS.append("--dry-run")
            commandOutput.stringValue.extend("dry run button is checked.\nhere's what would change\n")
        } else {
            commandOutput.stringValue.extend("dry run button is not checked.\nsyncing...\n")
        }
        
        
        switch (targetPath, targetAbsPath, sourcePath, sourceAbsPath){
        case let (.Some(targetPath), .Some(targetAbsPath), .Some(sourcePath), .Some(sourceAbsPath)):
            let fixedSource = sourceAbsPath.stringByReplacingOccurrencesOfString(sourceAbsPath.stringByReplacingOccurrencesOfString(sourcePath, withString: ""), withString: "/")
            let fixedTarget = targetAbsPath.stringByReplacingOccurrencesOfString(targetAbsPath.stringByReplacingOccurrencesOfString(targetPath, withString: ""), withString: "/")
            RD_SOURCE_ARGS += [fixedSource, fixedTarget]
            commandOutput.stringValue.extend("target: \(targetPath)\nsource: \(sourcePath)\n")
        default:
            commandOutput.stringValue.extend("I am the default.  You didn't select target and source.\n")
        }
        
        commandOutput.stringValue.extend("----------------\n")
        
        var done = false
        let RD_SOURCE = "/usr/bin/rsync"
        var shell: NSTask = NSTask()
        shell.launchPath = RD_SOURCE
        shell.arguments = RD_SOURCE_ARGS
        
        let pipe = NSPipe()
        shell.standardOutput = pipe
        shell.terminationHandler = {task -> Void in
            println("donezers")
            dispatch_async(dispatch_get_main_queue(), {
                done = true
            })
        }

        commandOutput.stringValue.extend("launch\n")
        shell.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: NSUTF8StringEncoding)
        commandOutput.stringValue.extend(output)
        commandOutput.stringValue.extend("\n")
        var theRL: NSRunLoop = NSRunLoop.currentRunLoop()
        var date : AnyObject! = NSDate.distantFuture()
        
        while !done && theRL.runMode(NSDefaultRunLoopMode, beforeDate: date as NSDate) {}
        commandOutput.stringValue.extend("completed")
    }
    
    func getAbsoluteURLOfDirectory() -> NSURL {
        let directorySelectDiag: NSOpenPanel = NSOpenPanel()
        directorySelectDiag.allowsMultipleSelection = false
        directorySelectDiag.canChooseFiles = false
        directorySelectDiag.canCreateDirectories = true
        directorySelectDiag.canChooseDirectories = true
        directorySelectDiag.runModal()
        
        var selected: NSURL = directorySelectDiag.URLs[0] as NSURL
        NSLog("%@", selected)
        return selected
    }

    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }


}

