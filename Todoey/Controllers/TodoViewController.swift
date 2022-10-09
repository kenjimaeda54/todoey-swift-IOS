//
//  ViewController.swift
//  Todoey
//
//  Created by kenjimaeda on 07/10/22.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController {
	
	//estou criando um novo arquivo no diretorio atual
	//ideia e para salvar um array de objeto
	//	let dataPathFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("TodoListTwo.plist")
	
	
	var item: String?
	var itemArray: [Item] = []
	var gesture  = false
	
	@IBOutlet var tapGesture: UITapGestureRecognizer!
	@IBOutlet weak var searchBar: UISearchBar!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		searchBar.delegate = self
		tapGesture.delegate = self
		
		//saber onde esta sendo salvo os dados
		//		print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
		//
		loadData()
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
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
		
		//update
		itemArray[indexPath.row].setValue(!itemArray[indexPath.row].done, forKey: "done")
		
		saveData()
		
	}
	
	@IBAction func handleAddTask(_ sender: UIBarButtonItem) {
		
		let alert = UIAlertController(title: "Insert new item", message: "", preferredStyle: .alert)
		
		let add = UIAlertAction(title: "Add item", style: .default){[self](action) in
			if let item = item {
				let newItem = Item(context: context)
				newItem.title = item
				newItem.done = false
				itemArray.append(newItem)
				saveData()
				tableView.reloadData()
				
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
	
	//	//metodo abaixo para salvar e recuperar arquivos salvos diretos no celular
	//	func loadData() {
	//		let data = try? Data(contentsOf: dataPathFile!)
	//		let decoder = PropertyListDecoder()
	//		if let data = data,let modelItem = try? decoder.decode([ModelItem].self, from: data){
	//			itemArray = modelItem
	//			tableView.reloadData()
	//		}
	//	}
	//
	//	func saveData(){
	//		let encoder = PropertyListEncoder()
	//		let data =	 try? encoder.encode(itemArray)
	//		if let item = data {
	//			try!	item.write(to: dataPathFile!)
	//		}
	//	}
	//
	func saveData() {
		do {
			try context.save()
			tableView.reloadData()
		}catch {
			print(error.localizedDescription)
		}
	}
	
	func loadData(_ request:  NSFetchRequest<Item> = Item.fetchRequest() ) {
		do {
			itemArray = 	try context.fetch(request)
		}catch {
			print(error.localizedDescription)
		}
		tableView.reloadData()
	}
	
}

//MARK: - UITextFieldDelegate
extension TodoViewController:UITextFieldDelegate  {
	func textFieldDidEndEditing(_ textField: UITextField) {
		//quem precisa assumir valor fica do lado esquerdo
		item = textField.text
	}
}



//MARK: - UISearchBarDelegate
extension TodoViewController: UISearchBarDelegate {
	
	//cheset preciates
	//https://academy.realm.io/posts/nspredicate-cheatsheet/
	//metodo acionado ao clicar no butao de buscar do keyboard
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		gesture = true
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		if let text = searchBar.text,!text.isEmpty{
			request.predicate = NSPredicate(format: "title contains[c] %@",text)
			request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
			loadData(request)
			searchBar.resignFirstResponder()
			searchBar.text = ""
		}
		gesture = false
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		if searchBar.text?.count == 0 {
			loadData()
			
			//precisei colocar esse codigon na main
			//estava sendo executado em outra tread
			//entao teclado nao fechava
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
				
			}
			
		}
		
	}
	
}

//esta logica e para fechar o teclado assim que clicar na table view
//de uma olhada no ib se a referencia do tap esta no tableview
//caso nao esteja e so arrastar
//MARK: -    UIGestureRecognizerDelegate
extension TodoViewController:  UIGestureRecognizerDelegate {
	
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		searchBar.resignFirstResponder()
		return gesture
	}
	
}
