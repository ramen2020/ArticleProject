//
//  ViewController.swift
//  tonkotsu_ramen
//
//  Created by 宮本光直 on 2021/06/10.
//

import UIKit
import Moya
import Kingfisher
import RxSwift
import RxCocoa


class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private let disposeBag = DisposeBag()
    private var articleViewModel: ArticleViewModel!
    
    override func viewDidLoad() {
        articleViewModel = ArticleViewModel()
        self.tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        
        tableView.delegate = self
        
        searchTextField.rx.text.orEmpty
            .filter { $0.count >= 1 }   
            .bind(to: articleViewModel.input.searchWord)
            .disposed(by: disposeBag)
        
                articleViewModel.output.articles
                    .bind(to: tableView.rx.items) { tableView, row, element in
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell")!
        
                        let imageView = cell.contentView.viewWithTag(3) as! UIImageView
                        let url = URL(string: element.user.profile_image_url)!
                        imageView.kf.setImage(with: url)
        
                        let labelTitle = cell.viewWithTag(1) as! UILabel
                        labelTitle.text = element.title
        
                        let labelName = cell.viewWithTag(2) as! UILabel
                        labelName.text = element.user.name
        
                        return cell
                    }
                    .disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
