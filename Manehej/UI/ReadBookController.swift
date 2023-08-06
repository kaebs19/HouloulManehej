//
//  ReadBookController.swift
//  Manehej
//
//  Created by pommestore on 22/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import Alamofire

class ReadBookController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var wbv: UIWebView!
    let url = "http://carlosicaza.com/swiftbooks/SwiftLanguage.pdf" as! String
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // var url = URL(string: self.url)
        /*
         /*if #available(iOS 11.0, *) {
         
         // let pdfDocument = PDFDocument(url: URL(string: "http://carlosicaza.com/swiftbooks/SwiftLanguage.pdf")!)
         
         let url = NSURL(string: ResourceUrl + self.url)
         
         HttpDownloader.loadFileSync(url: url!, completion:{(path:String, error:NSError!) in
         print("pdf downloaded to: \(path)")
         let url1 = URL(fileURLWithPath: path)
         
         
         let pdfDocument = PDFDocument(url: url1)
         self.progressbar.alpha = 0
         self.hud.dismiss(afterDelay: 0.0)
         
         if  (pdfDocument != nil)  {
         self.pdfView.autoScales = true
         self.pdfView.displayMode = .singlePageContinuous
         self.pdfView.displayDirection = .vertical
         self.pdfView.document = pdfDocument
         }else{
         print("error")
         }
         })
         } else {
         */
         let url = NSURL(string: ResourceUrl + self.url)
         
         HttpDownloader.loadFileSync(url: url! as NSURL, completion:{(path:String, error:NSError!) in
         print("pdf downloaded to: \(path)")
         let url = URL(fileURLWithPath: path)
         self.hud.dismiss(afterDelay: 0.0)
         self.progressbar.alpha = 0
         
         var   requset = URLRequest(url: url)
         self.wbv.loadRequest(requset)
         })
         // }

 */

        // let url = NSURL(string: ResourceUrl + self.url)
        let url = NSURL(string:  self.url)
        
        HttpDownloader.loadFileSync(url: url! as NSURL, completion:{(path:String, error:NSError!) in
            print("pdf downloaded to: \(path)")
            let url = URL(fileURLWithPath: path)
            
            var   requset = URLRequest(url: url)
            self.wbv.loadRequest(requset)
        })
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
