//
//  InventarianteTableViewController.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 10/05/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreData


class InventarianteTableViewController: UITableViewController {

    
    weak var theuser : Usuario?
    weak var thePrefixo : Dependencia?
    
    var usuario_fechedResultsController : NSFetchedResultsController<Usuario>?
    var prefixo_fechedResultsController : NSFetchedResultsController<Dependencia>?
    
    
//    func _fechedResultsController() -> NSFetchedResultsController<Usuario> {
//        if let controller = usuario_fechedResultsController {
//            return controller
//        }
//        
//        let fetchRequest : NSFetchRequest<Usuario> = Usuario.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
//        fetchRequest.fetchBatchSize = 20
//        
//        
//        let controller = NSFetchedResultsController<Usuario>(fetchRequest: fetchRequest,
//                                managedObjectContext: NSmanagedObjectContext,
//                                                             sectionNameKeyPath: "initial",
//                                                             cacheName: "TabelaUsuario")
//        let controller = NSFetchedResultsController<Usuario>(
//            fetchRequest: fetchRequest, managedObjectContext: managedObjectContext(),
//            sectionNameKeyPath: "initial",
//            cacheName: "TabelaUsuario")
//
//        controller.delegate = self
//        
//        try! controller.performFetch()
//        
//        usuario_fechedResultsController = controller
//        
//        return controller
//    }

    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
