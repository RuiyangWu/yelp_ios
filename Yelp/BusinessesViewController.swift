//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate, UISearchBarDelegate {

    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var searchFilters: SearchFilters = SearchFilters()
    
    @IBOutlet weak var tableView: UITableView!

    var searchBar =  UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self

        doSearch()

      /*
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = businesses
            self.tableView.reloadData()
        
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
 */

    }

    private func doSearch() {
      /* Example of Yelp search with more search options specified */
      //Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) {
      Business.searchWithTerm("Restaurants", distance: searchFilters.distance, sort: searchFilters.sort, categories: searchFilters.categories, deals: searchFilters.deals) { (businesses: [Business]!, error: NSError!) -> Void in
        self.businesses = businesses
        self.filteredBusinesses = businesses
        self.tableView.reloadData()

        for business in businesses {
          //print(business.name!)
          //print(business.address!)
        }
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return filteredBusinesses?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
      cell.business = filteredBusinesses[indexPath.row]
      return cell
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
      filteredBusinesses = searchText.isEmpty ? businesses : businesses!.filter({(business: Business) -> Bool in
        let allText = business.name ?? ""
        return allText.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
      })
      tableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      let navigationController = segue.destinationViewController as! UINavigationController
      let filtersViewController = navigationController.topViewController as! FiltersViewController
      filtersViewController.delegate = self

      /* We don't need to persist form now, so below is not needed. Enable if need to persist filter settings across views */
      //filtersViewController.searchFilters = searchFilters
    }

    func filtersViewController(filtersViewController: FiltersViewController, didUpateFilters filters: SearchFilters) {
      self.searchFilters = filters
      print("Updated filters to: ", filters.desc())
      doSearch()
    }

}
