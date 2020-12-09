//
//  EntriesViewController.swift
//  Travelogue
//
//  Created by obbrbt on 12/9/20.
//

import UIKit
import CoreData

class EntriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var entriesTableView: UITableView!
    
    let dateFormatter = DateFormatter()
    var entries = [Entry]()
    var trip: Trip?

    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchEntries()
        entriesTableView.reloadData()
    }
    
    func alertNotifyUser(message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchEntries()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do
        {
            entries = try managedContext.fetch(fetchRequest)
        } catch
        {
            alertNotifyUser(message: "Fetch for entries could not be performed.")
            return
        }
    }
    
    func deleteEntry(at indexPath: IndexPath)
    {
        let entry = entries[indexPath.row]
        
        if let managedObjectContext = entry.managedObjectContext
        {
            managedObjectContext.delete(entry)
            
            do
            {
                try managedObjectContext.save()
                self.entries.remove(at: indexPath.row)
                entriesTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch
            {
                alertNotifyUser(message: "Entry could not be deleted.")
                entriesTableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        if let cell = cell as? EntriesTableViewCell
        {
            let entry = entries[indexPath.row]
            cell.titleTextLabel.text = entry.title
            
            if let date = entry.date
            {
                cell.dateTextLabel.text = dateFormatter.string(from: date)
            } else
            {
                cell.dateTextLabel.text = "Unknown Date"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: title, message: "Are you sure you want to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: {(action) in
                self.deleteEntry(at: indexPath)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NewEntryViewController, let segueIdentifier = segue.identifier, segueIdentifier == "existingEntry", let row = entriesTableView.indexPathForSelectedRow?.row
        {
            destination.entry = entries[row]
        }
    }
}
