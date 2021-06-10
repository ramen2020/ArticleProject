//
//  ViewController.swift
//  tonkotsu_ramen
//
//  Created by 宮本光直 on 2021/06/10.
//

import UIKit
import Moya
import Kingfisher


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet var table: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var articles = [Article]()
    
    override func viewDidLoad() {
        self.featchQiitaArticles();
        table.delegate = self
        table.dataSource = self
        searchTextField.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let imageView = cell.contentView.viewWithTag(3) as! UIImageView
        let url = URL(string: articles[indexPath.row].user.profile_image_url)!
        imageView.kf.setImage(with: url)
        
        let labelTitle = cell.viewWithTag(1) as! UILabel
        labelTitle.text = articles[indexPath.row].title
        
        let labelName = cell.viewWithTag(2) as! UILabel
        labelName.text = articles[indexPath.row].user.name

        return cell
    }

    // 記事一覧取得
    func featchQiitaArticles() -> Void {
        let provider = MoyaProvider<QiitaAPI>()
        provider.request(.all) { result in
            switch result {
            case let .success(response):
                do{
                    let decoder = JSONDecoder()
                    self.articles = try decoder.decode([Article].self, from: response.data)
                } catch {
                    print("decodeでエラー:\(error)")
                }
                
                self.table.reloadData()

            case let .failure(error):
                print("リクエストでエラー:\(error)")
            }

        }
    }
    
    // 記事検索
    func featchQiitaArticlesBySearchWord(searchWord: String) -> Void {
        let provider = MoyaProvider<QiitaAPI>()

        provider.request(.search(searchWord: searchWord)) { result in
            switch result {
            case let .success(response):
                do{
                    let decoder = JSONDecoder()
                    self.articles = try decoder.decode([Article].self, from: response.data)
                } catch {
                    print("decodeでエラー:\(error)")
                }
                
                self.table.reloadData()

            case let .failure(error):
                print("リクエストでエラー:\(error)")
            }

        }
    }
    
    // textFieldでenterキー押した時
    func textFieldShouldReturn(_ serchTextField: UITextField) -> Bool {
        let searchWord = serchTextField.text!
        self.featchQiitaArticlesBySearchWord(searchWord: searchWord);
        return true;
    }
    
}



