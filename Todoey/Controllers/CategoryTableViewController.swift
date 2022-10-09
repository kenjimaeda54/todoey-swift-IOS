//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by kenjimaeda on 09/10/22.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
	
	var categories: [Category] = []
	var name: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		appearance.backgroundColor = UIColor(named: "AppBar")
		appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		navigationController?.navigationBar.standardAppearance = appearance;
		navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
		
		loadData()
		
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories.count
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "itemList", sender: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let vc = segue.destination as! TodoViewController
		let indexPath = tableView.indexPathForSelectedRow
		
		if let index = indexPath?.row {
			vc.selectedCategory = categories[index]
		}
		
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		let category = categories[indexPath.row]
		var content = cell.defaultContentConfiguration()
		content.text = category.name
		cell.contentConfiguration = content
		return cell
	}
	
	@IBAction func handleAddCategory(_ sender: UIBarButtonItem) {
		let alert = UIAlertController(title: "Add category", message: "", preferredStyle: .alert)
		
		let add = UIAlertAction(title: "Click for add", style: .default) {[self](action) in
			
			if let name = name {
				let category = Category(context: context)
				category.name = name
				//estou adicionado manualmente o array aqui pois e preciso
				//para refletir em real time, o banco  apenas para persistir dados
				categories.append(category)
				//ao salvar e acionar o reload data,metodo count do table view sera acioando e mostrar na tela
				//para isto funcionar precisa alterar o array diretamente no codigo e nao apenas banco
				saveData()
			}
			
		}
		
		alert.addAction(add)
		
		alert.addTextField { (textField) in
			textField.placeholder = "Insert category"
			textField.delegate = self
		}
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel)
		alert.addAction(cancel)
		
		present(alert.self, animated: true)
	}
	
	func saveData() {
		do {
			try context.save()
			tableView.reloadData()
		}catch {
			print(error.localizedDescription)
		}
	}
	
	func loadData(_ request: NSFetchRequest<Category> = Category.fetchRequest()) {
		do {
			categories =	 try context.fetch(request)
		}catch {
			print(error.localizedDescription)
		}
	}
	
	
}

//MARK: -  UITextViewDelegate
extension CategoryTableViewController: UITextFieldDelegate {
	
	//assim que perder o foco o teclado esse campo e chamado
	func textFieldDidEndEditing(_ textField: UITextField) {
		name = textField.text
	}
	
}
