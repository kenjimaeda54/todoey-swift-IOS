//
//  ViewController.swift
//  Todoey
//
//  Created by kenjimaeda on 07/10/22.
//

import UIKit

class TodoViewController: UITableViewController {
	
	//estou criando um novo arquivo no diretorio atual
	//ideia e para salvar um array de objeto
	let dataPathFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("TodoListTwo.plist")
	
	var itemArray: [ModelItem] = []
	var item: String?
	let defaults = UserDefaults.standard
	let decoder = JSONDecoder()
	
	
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
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		loadData()
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
		content.text = item.title
		cell.contentConfiguration = content
		cell.accessoryType = item.done ? .checkmark : .none
		return cell
	}
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		//ira ficar dinamico hover na celula
		tableView.deselectRow(at: indexPath, animated: true)
		
		//aqui vou alterar objeto,assim preciso aplicar reload data
		//para refletir na lista
		//precisa ser dessa maneira para realizar mudanca direto no objeto
		//se eu fizer let item = itemArray[indexPath.row] estarei criando apenas referenacia entao muda
		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		
		saveData()
		tableView.reloadData()
		
	}
	
	@IBAction func handleAddTask(_ sender: UIBarButtonItem) {
		
		let alert = UIAlertController(title: "Insert new item", message: "", preferredStyle: .alert)
		
		let add = UIAlertAction(title: "Add item", style: .default){[self](action) in
			if let item = item {
				let newItem = ModelItem(title: item,done: false)
				itemArray.append(newItem)
				tableView.reloadData()
				saveData()
			}
		}
		alert.addAction(add)
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel)
		alert.addAction(cancel)
		
		alert.addTextField {(textField) in
			textField.placeholder = "New item"
			textField.delegate = self
			
		}
		present(alert.self, animated:true)
	}

	//metodo abaixop para salvar e recuperar 
	func loadData() {
		let data = try? Data(contentsOf: dataPathFile!)
		let decoder = PropertyListDecoder()
		if let data = data,let modelItem = try? decoder.decode([ModelItem].self, from: data){
			itemArray = modelItem
			tableView.reloadData()
		}
	}
	
	func saveData(){
		let encoder = PropertyListEncoder()
		let data =	 try? encoder.encode(itemArray)
		if let item = data {
			try!	item.write(to: dataPathFile!)
		}
	}
	
}

//MARK: - UITextFieldDelegate
extension TodoViewController:UITextFieldDelegate  {
	func textFieldDidEndEditing(_ textField: UITextField) {
		//quem precisa assumir valor fica do lado esquerdo
		item = textField.text
	}
}


