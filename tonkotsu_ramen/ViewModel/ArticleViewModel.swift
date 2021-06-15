//
//  ArticleViewModel.swift
//  tonkotsu_ramen
//
//  Created by 宮本光直 on 2021/06/14.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

protocol ArticleViewModelInputs {
    var searchWord: PublishRelay<String> {get}
}

protocol ArticleViewModelOutputs {
    var articles: Observable<[Article]> {get}
}

protocol ArticleViewModelType {
    var input: ArticleViewModelInputs {get}
    var output: ArticleViewModelOutputs {get}
}

class ArticleViewModel: ArticleViewModelInputs, ArticleViewModelOutputs {
    let searchWord = PublishRelay<String>()
    let articles: Observable<[Article]>
    private let disposeBag = DisposeBag()
    private let provider = MoyaProvider<QiitaAPI>()
    
    init() {
        let _articles = PublishRelay<[Article]>()
        self.articles = _articles.asObservable()
        
        self.featchQiitaArticles().subscribe(onNext: { response in
            _articles.accept(response)
        }).disposed(by: disposeBag)
    }
    
    // 記事一覧
    func featchQiitaArticles() -> Observable<[Article]> {
        provider.rx.request(.all)
            .map([Article].self)
            .asObservable()
    }
}

extension ArticleViewModel: ArticleViewModelType {
    var input: ArticleViewModelInputs {return self}
    var output: ArticleViewModelOutputs {return self}
}


