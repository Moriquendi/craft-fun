//
//  File.swift
//
//
//  Created by Michał Śmiałko on 19/07/2021.
//

import Foundation

#if os(macOS)
public let IS_MAC = true
public var IS_IPAD = false
#else
public let IS_MAC = false
public var IS_IPAD: Bool = UIDevice.deviceType == .iPad
#endif

#if os(macOS)
import Cocoa
public typealias NativeEdgeInsets = NSEdgeInsets
public extension NativeEdgeInsets {
    static var zero = NSEdgeInsetsZero
}
#else
import UIKit
public typealias NativeEdgeInsets = UIEdgeInsets
#endif

#if os(macOS)
import Cocoa
public typealias NativeTableView = NSTableView
#else
import UIKit
public typealias NativeTableView = UITableView
#endif

#if os(macOS)
import AppKit
public typealias NativeApp = NSApplication
#else
public typealias NativeApp = UIApplication
#endif

#if os(macOS)
public typealias NativeColor = NSColor
#else
public typealias NativeColor = UIColor
#endif

#if os(macOS)
public extension NSControl {
    func addTarget(_ target: AnyObject?, action: Selector) {
        self.target = target
        self.action = action
    }
}
#endif

// MARK: - Device Type Env Key

#if os(iOS)
public enum DeviceType {
    case iPhone
    case iPad
}

public extension UIDevice {
    static var deviceType: DeviceType {
        let name = current.name.lowercased()
        if name.contains("iphone") {
            return .iPhone
        } else if name.contains("ipad") {
            return .iPad
        } else {
            assertionFailure("Unsupported Device Type")
            return .iPad
        }
    }
}
#endif
