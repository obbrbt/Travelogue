//
//  TripsViewController.swift
//  Travelogue
//
//  Created by obbrbt on 12/9/20.
//

import UIKit
import CoreData

class TripsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tripsTableView: UITableView!
    
    var trips: [Trip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func alertNotifyUser(message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        do
        {
            trips = try managedContext.fetch(fetchRequest)
            for trip in trips
            {
                print(trip.entries)
            }
            tripsTableView.reloadData()
        } catch
        {
            alertNotifyUser(message: "Fetch could not be completed.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? EntriesViewController, let selectedRow = self.tripsTableView.indexPathForSelectedRow?.row else
        {
            return
        }
        
        destination.trip = trips[selectedRow]
    }
    
    func deleteTrip(at indexPath: IndexPath)
    {
        let trip = trips[indexPath.row]
        
        if let managedObjectContext = trip.managedObjectContext
        {
            managedObjectContext.delete(trip)
            
            do
            {
                try managedObjectContext.save()
                self.trips.remove(at: indexPath.row)
                tripsTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch
            {
                alertNotifyUser(message: "Delete trip failed.")
                tripsTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let alert = UIAlertController(title: title, message: "Are you sure you want to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: {(action) in
                self.deleteTrip(at: indexPath)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tripsTableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        let trip = trips[indexPath.row]
        cell.textLabel?.text = trip.title
        return cell
    }
}
