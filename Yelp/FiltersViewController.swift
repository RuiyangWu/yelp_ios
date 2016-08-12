//
//  FiltersViewController.swift
//  Yelp
//
//  Created by ruiyang_wu on 8/10/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
  optional func filtersViewController(filtersViewController: FiltersViewController, didUpateFilters filters: SearchFilters)
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?

    var categories: [[String:String]]!

    var updatedSearchFilters: SearchFilters!
    var switchStates = [Int:Bool]()
    var distanceCollapsed = true
    var sortCollapsed = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categories = SearchFilters.yelpCategories()

        tableView.delegate = self
        tableView.dataSource = self

        // TODO: Pass the current in prepareForSegue, rather than creating an empty one here
        //       If do so, then also need to change the switch on/off display accordingly. Non trivial
        updatedSearchFilters = SearchFilters()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(sender: AnyObject) {
      dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearch(sender: AnyObject) {
      dismissViewControllerAnimated(true, completion: nil)

      // Categories
      var selectedCategories = [String]()
      for (row,isSelected) in switchStates {
        if isSelected {
          selectedCategories.append(categories[row]["code"]!)
        }
      }
      if selectedCategories.count > 0 {
        updatedSearchFilters.categories = selectedCategories
      }
      else {
        updatedSearchFilters.categories = nil
      }
      
      delegate?.filtersViewController?(self, didUpateFilters: updatedSearchFilters)
    }

    /* Table View Protocols */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 4
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      switch section {
        case 0: return 1
        case 1:
          if distanceCollapsed {
            return 1
          }
          else {
            return 5
          }
        case 2:
          if sortCollapsed {
            return 1
          }
          else {
            return 3 // TODO: change to number of sorting options
          }
        case 3: return categories.count
        default: return 0
      }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      switch section {
        case 0: return ""
        case 1: return "Distance"
        case 2: return "Sort By"
        case 3: return "Category"
        default: return ""
      }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

      switch indexPath.section {
        case 0:
          let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
          cell.delegate = self
          cell.switchLabel.text = "Offering a Deal"
          cell.onSwitch.on = updatedSearchFilters.deals ?? false
          return cell
        case 1:
          if distanceCollapsed {
            let cell = tableView.dequeueReusableCellWithIdentifier("DropDownCell", forIndexPath: indexPath) as! DropDownCell
            cell.nameLabel.text = updatedSearchFilters.distanceDesc ?? "Auto"
            return cell
          }
          else {
            let cell = tableView.dequeueReusableCellWithIdentifier("DropItemCell", forIndexPath: indexPath) as! DropItemCell
            switch indexPath.row {
              case 0: cell.nameLabel.text = "Auto"
              case 1: cell.nameLabel.text = "0.3 Miles"
              case 2: cell.nameLabel.text = "1 Miles"
              case 3: cell.nameLabel.text = "5 Miles"
              case 4: cell.nameLabel.text = "20 Miles"
              default: cell.nameLabel.text = ""
            }
            return cell
          }
        case 2:
          if sortCollapsed {
            let cell = tableView.dequeueReusableCellWithIdentifier("DropDownCell", forIndexPath: indexPath) as! DropDownCell
            cell.nameLabel.text = updatedSearchFilters.sortDesc ?? "Best Matched"
            return cell
          }
          else {
            let cell = tableView.dequeueReusableCellWithIdentifier("DropItemCell", forIndexPath: indexPath) as! DropItemCell
            switch indexPath.row {
              case 0: cell.nameLabel.text = "Best Matched"
              case 1: cell.nameLabel.text = "Distance"
              case 2: cell.nameLabel.text = "Highest Rated"
              default: cell.nameLabel.text = ""
            }
            return cell
          }
        case 3:
          let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
          cell.delegate = self
          cell.switchLabel.text = categories[indexPath.row]["name"]
          cell.onSwitch.on = switchStates[indexPath.row] ?? false
          return cell
        default:
          return tableView.dequeueReusableCellWithIdentifier("BadCell", forIndexPath: indexPath)
      }


    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      print("didSelectRowAtIndexPath")
      let METERS_PER_MILE = 1609
      switch indexPath.section {
        case 1:
          if !distanceCollapsed {
            switch indexPath.row {
              case 0:
                updatedSearchFilters.distance = nil
                updatedSearchFilters.distanceDesc = "Auto"
              case 1:
                updatedSearchFilters.distance = 0.3 * Float(METERS_PER_MILE)
                updatedSearchFilters.distanceDesc = "0.3 Miles"
              case 2:
                updatedSearchFilters.distance = 1.0 * Float(METERS_PER_MILE)
                updatedSearchFilters.distanceDesc = "1 Mile"
              case 3:
                updatedSearchFilters.distance = 5.0 * Float(METERS_PER_MILE)
                updatedSearchFilters.distanceDesc = "5 Miles"
              case 4:
                updatedSearchFilters.distance = 20.0 * Float(METERS_PER_MILE)
                updatedSearchFilters.distanceDesc = "20 Miles"
              default: break
            }
          }
          distanceCollapsed = !distanceCollapsed
          tableView.reloadData()
        case 2:
          if !sortCollapsed {
            switch indexPath.row {
              case 0:
                updatedSearchFilters.sort = YelpSortMode.BestMatched
                updatedSearchFilters.sortDesc = "Best Matched"
              case 1:
                updatedSearchFilters.sort = YelpSortMode.Distance
                updatedSearchFilters.sortDesc = "Distance"
              case 2:
                updatedSearchFilters.sort = YelpSortMode.HighestRated
                updatedSearchFilters.sortDesc = "Highest Rated"
              default: break
            }
          }
          sortCollapsed = !sortCollapsed
          tableView.reloadData()
        default: break
      }
    }

    /* SwitchCell Protocols */
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
      print("didChangeValue")
      let indexPath = tableView.indexPathForCell(switchCell)
      if indexPath == nil {
        return
      }
      switch indexPath!.section {
        case 0:
          updatedSearchFilters.deals = value ? true : nil
        case 3:
          switchStates[indexPath!.row] = value
        default: break
      }
    }

}
