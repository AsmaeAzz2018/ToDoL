//
//  ViewController.swift
//  ToDoL
//
//  Created by mac on 1/3/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TableViewController: SwipeTableViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var ToDoItems : Results<Item>?
    var selectedCategory : Category? {
        didSet{
           loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //  print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
   //     loadItems()
        tableView.separatorStyle = .none
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let colourHex = selectedCategory?.colour else {fatalError()}
        updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         updateNavBar(withHexCode: "1D9BF6")
    }
    
    //Mark: - update Nav Bar
    
    func updateNavBar(withHexCode colourHexCode: String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        guard let navBarColour = UIColor(hexString: colourHexCode) else {fatalError()}
        navBar.barTintColor = navBarColour
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
        searchBar.barTintColor = navBarColour
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if  let item = ToDoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(ToDoItems!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
        
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
         cell.textLabel?.text = "No Items added yet!"
        }
       return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ToDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = ToDoItems?[indexPath.row] {
//             do {
//                try realm.write {
//                    realm.delete(item)
//                //item.done = !item.done
//                }
//               
//            } catch {
//                print("error saving done status, \(error)")
//            }
        }
       tableView.reloadData()
       tableView.deselectRow(at: indexPath, animated: true)
        
    }

  
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving Item, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item ..."
            textField = alertTextField

        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemDeleted = self.ToDoItems?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(itemDeleted)
                }
            }catch {
                print("error deleting item \(error)")
            }
        }
    }

    
    func loadItems(){
        ToDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
   }
    
   
    
    
}
//MARK: -search bar methods

extension TableViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        ToDoItems = ToDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
  
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

