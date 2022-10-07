//
//  ViewController.swift
//  Todoey
//
//  Created by kenjimaeda on 07/10/22.
//

import UIKit

class TodoViewController: UITableViewController {
	
	
	var itemArray = ["caderno","banana","pera"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
		let item = itemArray[indexPath.row]
		//forma de acessar title sem recurso de uma
		//tableviewcell
		//referencia
		//https://www.udemy.com/course/ios-13-app-development-bootcamp/learn/lecture/10929420#questions/16199490
		var content = cell.defaultContentConfiguration()
		content.text = item
		cell.contentConfiguration = content
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//ira ficar dinamico hover na celula
		tableView.deselectRow(at: indexPath, animated: true)
	
		//acressentando um acessario no canto esquerdo da table view
		if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
			tableView.cellForRow(at: indexPath)?.accessoryType = .none
			return
		}
		
		tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		
	}
}

