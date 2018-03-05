//
//  PasturesTableViewCell.swift
//  Myra
//
//  Created by Amir Shayegh on 2018-02-22.
//  Copyright © 2018 Government of British Columbia. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

/*
 Pastures uses a different logic than range years cell for height:
 the height of pasture cells within the table view depends on the height
 of the content of a pasture's conent which will be unpredictable.
*/
class PasturesTableViewCell: UITableViewCell {

    // Mark: Variables
    var pastures = List<Pasture>()
    var mode: FormMode = .Create

    // Mark: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    // Mark: Outlet actions
    @IBAction func addPastureAction(_ sender: Any) {
        let parent = self.parentViewController as! CreateNewRUPViewController

        let pasture1 = Pasture()
        pasture1.name = "name"
//        pasture1.plantCommunities.append(PlantCommunity())
        parent.rup?.pastures.append(pasture1)
//        parent.rup?.pastures.append(Pasture(name: "name"))
        self.pastures = (parent.rup?.pastures)!
        updateTableHeight()
    }

    // Mark: Functions
    func setup(mode: FormMode, pastures: List<Pasture>) {
        self.mode = mode
        self.pastures = pastures
        setUpTable()
//        setupNotifications()
    }

    func updateTableHeight() {
        self.tableView.reloadData()
        tableView.layoutIfNeeded()
//        tableHeight.constant =  tableView.contentSize.height
        tableHeight.constant = computeHeight()
        let parent = self.parentViewController as! CreateNewRUPViewController
        parent.realodAndGoTO(indexPath: parent.pasturesIndexPath)
    }

    func computeHeight() -> CGFloat {
        /*
         Height of Pastures cell =

        */
        var h: CGFloat = 0.0
        for pasture in pastures {
            h = h + computePastureHeight(pasture: pasture)
        }
        return h
    }

    func computePastureHeight(pasture: Pasture) -> CGFloat {
        // 395 is the right number but clearly needed more padding
//        let staticHeight: CGFloat = 395
        let staticHeight: CGFloat = 410

        let pastureHeight: CGFloat = 105
        return (staticHeight + pastureHeight * CGFloat(pasture.plantCommunities.count))
    }
    
}

// TableView
extension PasturesTableViewCell: UITableViewDelegate, UITableViewDataSource {

    func setUpTable() {
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        registerCell(name: "PastureTableViewCell")
    }

    func registerCell(name: String) {
        let nib = UINib(nibName: name, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: name)
    }

    func getYearCell(indexPath: IndexPath) -> PastureTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PastureTableViewCell", for: indexPath) as! PastureTableViewCell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getYearCell(indexPath: indexPath)
        if pastures.count <= indexPath.row {return cell}
        cell.setup(mode: mode, pasture: pastures[indexPath.row], pastures: self)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastures.count
    }

}

// Notifications
extension PasturesTableViewCell {
    func setupNotifications() {
        NotificationCenter.default.addObserver(forName: .updatePasturesCell, object: nil, queue: nil, using: catchAction)
//         NotificationCenter.default.addObserver(forName: .updateTableHeights, object: nil, queue: nil, using: catchUpdateAction)
    }

    func catchAction(notification:Notification) {
        self.updateTableHeight()
    }

    func catchUpdateAction(notification:Notification) {
        self.updateTableHeight()
    }
}

