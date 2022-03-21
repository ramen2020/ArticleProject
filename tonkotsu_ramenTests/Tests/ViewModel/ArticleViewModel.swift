//
//  ArticleViewModel.swift
//  tonkotsu_ramenTests
//
//  Created by 宮本光直 on 2022/03/06.
//

import XCTest
import RxCocoa
import RxSwift

@testable import tonkotsu_ramen

class ArticleViewModelTests: XCTestCase {
    
    private struct Dependency {

        let viewModel: ArticleViewModel
        
        let apiSession = MockQiitaApiRepository(articles: Article.mockArticles())

        let searchStore: ArticleStore
        let searchDispatcher: ArticleDispatcher
        let searchActionCreator: ArticleActionCreator

        init() {
            let flux = Flux.mock(apiSession: apiSession)

            self.searchStore = flux.articleStore
            self.searchDispatcher = flux.articleDispatcher
            self.searchActionCreator = flux.articleActionCreator

            self.viewModel = ArticleViewModel(flux: flux)
        }
    }
    
    private var dependency: Dependency!

    override func setUp() {
        super.setUp()
        dependency = Dependency()
    }
    
    func test_記事一覧取得() {
        let expect = expectation(description: "wait for updating apiSession article")
        
        let disposable = dependency.viewModel.output.articles
            .subscribe(onNext: { articles in
                XCTAssertEqual(articles.count, Article.mockArticles().count)
                XCTAssertNotNil(articles.first)
                expect.fulfill()
            })
            
        dependency.viewModel.featchArticles.onNext(Void())
        wait(for: [expect], timeout: 0.1)
        disposable.dispose()
    }
    
//    func test_カテゴリの入力値に対し、記事を出力できているかどうか() {
//        let searchArticleCategoryButtons: [SearchArticleCategoryButton] = SettingConst.searchCategoryButtons
//
//        let expect = expectation(description: "wait for updating apiSession article")
//        
//        let disposable = dependency.viewModel.output.articles
//            .subscribe(onNext: { articles in
//                XCTAssertEqual(articles.count, Article.mockArticles().count)
//                XCTAssertNotNil(articles.first)
//                expect.fulfill()
//            })
//            
//        dependency.viewModel.featchArticles.onNext(Void())
//        wait(for: [expect], timeout: 0.1)
//        disposable.dispose()
//        
//        dependency.viewModel.featchArticles.onNext(Void())
//    }
    
}
