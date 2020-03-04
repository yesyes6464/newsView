//
//  NewsDetailController.swift
//  newsView
//
//  Created by 김지오 on 2020/03/04.
//  Copyright © 2020 JiO. All rights reserved.
//

import UIKit

class NewsDetailController : UIViewController {
    
    @IBOutlet weak var ImageMain: UIImageView!
    @IBOutlet weak var LabelMain: UILabel!
    
    //image url
    //desc
    
    var imageUrl: String?
    var desc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //이미지를 가져와서 뿌림
        if let img = imageUrl {
            if let data = try? Data(contentsOf: URL(string:img)!) {
                //UI가 바뀌는 것은 main 스레드에서 실행되어져야함
                DispatchQueue.main.async {
                     self.ImageMain.image = UIImage(data: data)
                }
            }
        }
        
        //본문을 가져와서 뿌림
        if let d = desc {
            self.LabelMain.text = d
        }
    }
}
