//
//  ContactTableView.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 20.12.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

class ContactTableView: ContentSizedTableView, UITableViewDataSource, UITableViewDelegate {
  private var contactList: [IncognitoContact] = []
  
  private var clickCell: ((_ contact: IncognitoContact) -> Void)? = nil
  
  convenience init(_ contactList: [IncognitoContact], _ clickCell: @escaping (_ contact: IncognitoContact) -> Void) {
    self.init()
    self.contactList = contactList
    self.clickCell = clickCell
    
    dataSource = self
    delegate = self
  }
  
  override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)
    
    backgroundColor = ColorCompatibility.secondarySystemBackground
    layer.cornerRadius = 10
    layer.masksToBounds = true
    clipsToBounds = true
    
    /*
     * custom height of table cells.
     */
    estimatedRowHeight = 58
    rowHeight = 58
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (contactList.count)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    /*
     * add contacts with their names, images etc.
     */
    let tableCell = ContactTableCell(
      contactList[indexPath.row]
    )
    return (tableCell)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    clickCell?(contactList[indexPath.row])
  }
}
