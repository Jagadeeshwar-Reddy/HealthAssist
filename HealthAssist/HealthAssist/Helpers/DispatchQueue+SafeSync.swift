//
//  DispatchQueue+SafeSync.swift
//  TitanModel
//
//  Created by Attila Majoros on 15/03/2018.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation

public typealias DispatchQueueBlock = () -> Void

extension DispatchQueue {
	/**
	Checks the current thread and runs the given block synchronously on the main queue.
	- parameter block: the block to call on the main queue
	*/
	public static func safeSyncOnMain(block: DispatchQueueBlock) {
		if Thread.isMainThread {
			block()
		} else {
			DispatchQueue.main.sync(execute: {
				block()
			})
		}
	}
}
