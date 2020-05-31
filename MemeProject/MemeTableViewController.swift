//
//  MemeTableViewController.swift
//  MemeProject
//
//  Created by Mike Allan on 2020-05-02.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell", for: indexPath)

        // Configure the cell...
        let meme = self.memes[indexPath.row]
        var text = ""
        if let memeTopText = meme.topText {
            text = memeTopText
        }
        if let memeBottomText = meme.bottomText {
            if text.count > 0 {
                text.append(" ")
            }
            text.append(memeBottomText)
        }
        cell.textLabel?.text = text
        cell.imageView?.image = meme.memedImage

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "memeDetailViewController") as! MemeDetailViewController
        let meme = self.memes[indexPath.row]
        memeDetailViewController.meme = meme
        self.navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
    
}
