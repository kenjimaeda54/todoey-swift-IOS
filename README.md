# Todoey
Aplicação de CRUD usando core data, arquivo do sandbox e user defaults

## Motivação
Reforçar conceitos e praticar diversas maneiras de salvar dados permanentes em swift

## Feature
- Reforcei o conceito do uso de [userDefaults](https://developer.apple.com/documentation/foundation/userdefaults)
- Aprendi salvar dados mais completos que não  são permitidos em userDefaults
- Para salvar esses dados foi salvo diretamente no diretório da aplicação, essa abordagem e para dados pequenos, caso deseja uma coleção mais complexa precisa salvar em um banco de dados
- Abaixo o exemplo como identificar onde esta, os arquivos da aplicação 
- Também criei um diretório dentro do sandbox e neste aquivo que ira conter nosso plist
- Para salvar e ler usamos o conceito decoder,encoder
- Mesmo principio que aplicamos em JSON a diferença que usamos PropertyListDecoder()


```swift
let dataPathFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("TodoListTwo.plist")
	
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
	let data =	 try encoder.encode(itemArray)
	if let item = data {
	try	item.write(to: dataPathFile!)
		}
	}

```

##
- Utilizei também core data
- Abaixo um exemplo de create, update,read 
- Usei também [predicate](https://academy.realm.io/posts/nspredicate-cheatsheet/)
- No update, após realizar precisamos salvar no contexto
- Update a maneira mais simples e acessar diretamente a propriedade e alterar 
- Instanciar em uma variável ira apenas criar uma cópia e não modificar
- Por isso itemArray[indexPath].row.setValue(!itemArray[indexPath.row].done,forkey: "done")
- Eu também utilizei o gesture tap, para isto na IB inferi ele na table view, ou seja toda vez que a table view for clicada o search bar sera fechado
- Assim experiencia do usuário fica melhor, pois caso ele desista de pesquisar e só clicar fora do teclado

```swift

//update
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		
		tableView.deselectRow(at: indexPath, animated: true)
		itemArray[indexPath.row].setValue(!itemArray[indexPath.row].done, forKey: "done")
		
		saveData()
 }   
 
//salvar dados
@IBAction func handleAddTask(_ sender: UIBarButtonItem) {
		
 let alert = UIAlertController(title: "Insert new item", message: "", preferredStyle: .alert)
		
 let add = UIAlertAction(title: "Add item", style: .default){[self](action) in
 if let item = item {
	  let newItem = Item(context: context)
		newItem.title = item
		newItem.done = false
    newItem.parentCategory = selectedCategory
		itemArray.append(newItem)
		saveData()
    tableView.reloadData()
				
	}
 }
 
func saveData() {
 do {
			try context.save()
			tableView.reloadData()
		}catch {
			print(error.localizedDescription)
		}
 }

//ler dados e aplicar dois predicates
func loadData(_ request:  NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil ) {

	let predicateCategory = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
		
	if let predicate = predicate {
		request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateCategory,predicate])
	}else {
			request.predicate = predicateCategory
	}
		
 	
 do {
			itemArray = 	try context.fetch(request)
			tableView.reloadData()
		}catch {
			print(error.localizedDescription)
		}
	}   
}    

extension TodoViewController: UISearchBarDelegate {
	
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

```

