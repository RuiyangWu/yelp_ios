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
      print("onCancel")
      dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearch(sender: AnyObject) {
      print("onSearch")
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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 4
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      switch section {
        case 0: return 1
        case 1: return 5 // TODO: change to number of distance options
        case 2: return 3 // TODO: change to number of sorting options
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
      let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
      switch indexPath.section {
        case 0:
          cell.switchLabel.text = "Offering a Deal"
          cell.onSwitch.on = updatedSearchFilters.deals ?? false
        case 1:
          switch indexPath.row {
            case 0: cell.switchLabel.text = "Auto"
            case 1: cell.switchLabel.text = "0.3 Miles"
            case 2: cell.switchLabel.text = "1 Miles"
            case 3: cell.switchLabel.text = "5 Miles"
            case 4: cell.switchLabel.text = "20 Miles"
          default: cell.switchLabel.text = ""
          }
          cell.onSwitch.on = false // TODO
        case 2:
          switch indexPath.row {
            case 0: cell.switchLabel.text = "Best Match"
            case 1: cell.switchLabel.text = "Distance"
            case 2: cell.switchLabel.text = "Highest Rated"
          default: cell.switchLabel.text = ""
          }
          cell.onSwitch.on = false // TODO
        case 3:
          cell.switchLabel.text = categories[indexPath.row]["name"]
          cell.onSwitch.on = switchStates[indexPath.row] ?? false
        default: break
      }

      cell.delegate = self
      return cell
    }

    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
      let METERS_PER_MILE = 1609
      let indexPath = tableView.indexPathForCell(switchCell)
      if indexPath == nil {
        return
      }
      switch indexPath!.section {
        case 0:
          updatedSearchFilters.deals = value ? true : nil
        case 1: // TODO
          if value {
            switch indexPath!.row {
              case 0: updatedSearchFilters.distance = nil
              case 1:updatedSearchFilters.distance = 0.3 * Float(METERS_PER_MILE)
              case 2:updatedSearchFilters.distance = 1.0 * Float(METERS_PER_MILE)
              case 3:updatedSearchFilters.distance = 5.0 * Float(METERS_PER_MILE)
              case 4:updatedSearchFilters.distance = 20.0 * Float(METERS_PER_MILE)
            default: break
            }
          }
          else {
            updatedSearchFilters.distance = nil
        }
        case 2: // Sort
          // Update stored value
          if value {
            updatedSearchFilters.sort = YelpSortMode(rawValue: indexPath!.row)
          }
          else {
            updatedSearchFilters.sort = nil
          }
          // Update display
          // TODO: probably no need coz will change to use drop down
        case 3:
          switchStates[indexPath!.row] = value
        default: break
      }
    }

}
