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
    
    @IBOutlet var table: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
        
    private let disposeBag = DisposeBag()
    private var articleViewModel: ArticleViewModel!
    
    override func viewDidLoad() {
        articleViewModel = ArticleViewModel()
        
        // 入力欄の変化をviewModelへ伝える
        searchTextField.rx.text.orEmpty
            .bind(to: articleViewModel.input.searchWord)
            .disposed(by: disposeBag)
        
        // viewModelの変化をUIに伝える
        articleViewModel.output.articles
            .bind(to: table.rx.items) { tableView, row, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
                
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
