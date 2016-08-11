//
//  SearchFilters.swift
//  Yelp
//
//  Created by ruiyang_wu on 8/10/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class SearchFilters: NSObject {
  var categories: [String]?
  var sort: YelpSortMode?
  var distance: String?
  var deals: Bool?

  override init() {

  }


}
