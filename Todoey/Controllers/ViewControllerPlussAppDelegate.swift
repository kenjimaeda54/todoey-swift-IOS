//
//  ViewControllerPlussAppDelegate.swift
//  Todoey
//
//  Created by kenjimaeda on 08/10/22.
//

import UIKit
import Foundation
import CoreData


extension UIViewController {
	
	var context: NSManagedObjectContext {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.persistentContainer.viewContext
	}
	
}


