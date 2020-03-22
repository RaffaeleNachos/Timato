//
//  EventMonitor.swift
//  Timato
//
//  Created by Raffaele Apetino on 22/03/2020.
//  Event Monitoring code from https://www.raywenderlich.com/
//

import Cocoa

class EventMonitor {
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> Void

    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
      self.mask = mask
      self.handler = handler
    }

    deinit {
      stop()
    }

    public func start() {
      monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }

    public func stop() {
      if monitor != nil {
        NSEvent.removeMonitor(monitor!)
        monitor = nil
      }
    }
}
