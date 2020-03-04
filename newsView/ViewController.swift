//
//  ViewController.swift
//  newsView
//
//  Created by 김지오 on 2020/03/04.
//  Copyright © 2020 JiO. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TableViewMain: UITableView!
    
    var newsData :Array<Dictionary<String, Any>>?
    //1. http 통신방법
    //2. JSON 데이터 형태 네트워크 통신을 하면서 정보를 주고 받을때의 형태 {"키":"value"}
    
    func getNews() {
        let task = URLSession.shared.dataTask(with: URL(string:"http://newsapi.org/v2/top-headlines?country=kr&apiKey=5710c5c2daec4110a5138d42cdff2197")!) { (data, response, error) in
            
            if let dataJson = data {
                
                //JSON 형태로 파싱
                do{
                    let json = try JSONSerialization.jsonObject(with: dataJson, options: []) as! Dictionary<String, Any>
                    
                    //스위프트에서 제이슨은 dictionary라 함
                    let articles = json["articles"] as! Array<Dictionary<String,Any>>
                    print(articles)
                    self.newsData = articles
                    
                    //프론트앤드 메인에서 적용되도록 해줌.
                    DispatchQueue.main.async {
                        self.TableViewMain.reloadData()                    }
                   
                  
                }
                catch {}
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        
        if let news = newsData{
            return news.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        //let cell = UITableViewCell.init(style: .default, reuseIdentifier: "TableCellType1")
        let cell = TableViewMain.dequeueReusableCell(withIdentifier: "Type1",for: indexPath) as! Type1
      
          let idx = indexPath.row
        if let news = newsData{
            let row = news[idx]
            if let r = row as? Dictionary<String, Any> {
                if let title = r["title"] as? String{
             cell.LabelText.text = title
            }
            }
        }
//        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    //클릭
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("click 감지 \(indexPath.row)")
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "NewsDetailController") as! NewsDetailController
        
        if let news = newsData{
           let row = news[indexPath.row]
                      if let r = row as? Dictionary<String, Any> {
                       if let imageUrl = r["urlToImage"] as? String{
                     controller.imageUrl = imageUrl
                      }
                       if let desc = r["description"] as? String{
                      controller.desc = desc
                   }
       }
    }
        // 수동으로 이동
        //showDetailViewController(controller, sender: nil)
    }
    
    //세그웨이 방식
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "NewsDetail" == id {
            if let controller = segue.destination as? NewsDetailController{
                
                 if let news = newsData{
                    if let indexPath = TableViewMain.indexPathForSelectedRow{
                        let row = news[indexPath.row]
                    if let r = row as? Dictionary<String, Any> {
                    if let imageUrl = r["urlToImage"] as? String{
                            controller.imageUrl = imageUrl
                                                    }
                     if let desc = r["description"] as? String{
                     controller.desc = desc
                 }
                                     }
                    }
                    
                 
            }
        }
        }
        
        //자동으로 이동
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        TableViewMain.delegate = self
        TableViewMain.dataSource = self
        
        getNews()
    }

    //tableview 테이블로 된 뷰 - 여러개의 행이 모여있는 목록

}

