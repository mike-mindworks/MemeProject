//
//  MemeDetailViewController.swift
//  MemeProject
//
//  Created by Mike Allan on 2020-05-18.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeImage: UIImageView!
    
    var meme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the Back Button
        let backButton = UIBarButtonItem()
        backButton.title = "Sent Memes"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        if let detailMeme = meme {
            self.memeImage?.image = detailMeme.memedImage
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
