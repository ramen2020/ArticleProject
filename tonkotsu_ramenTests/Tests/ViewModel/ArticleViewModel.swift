//
//  ArticleViewModel.swift
//  tonkotsu_ramenTests
//
//  Created by 宮本光直 on 2022/03/06.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest

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

        dependency.viewModel.fetchAriticles.onNext(Void())
        wait(for: [expect], timeout: 0.1)
        disposable.dispose()
    }

    func test_カテゴリの入力値に対し記事を出力できているかどうか() {
        let searchArticleCategoryButtons: [SearchArticleCategoryButton] = SettingConst.searchCategoryButtons
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        let swiftCategory = searchArticleCategoryButtons.filter{$0.name == "Swift"}.first!
        let flutterCategory = searchArticleCategoryButtons.filter{$0.name == "Flutter"}.first!
        let laravelCategory = searchArticleCategoryButtons.filter{$0.name == "Laravel"}.first!
        let vueCategory = searchArticleCategoryButtons.filter{$0.name == "Vue"}.first!
        
        let searchCategoryButtonTapped: TestableObservable<SearchArticleCategoryButton> = scheduler.createHotObservable([
            Recorded.next(100, swiftCategory),
            Recorded.next(200, flutterCategory),
            Recorded.next(300, laravelCategory),
            Recorded.next(400, vueCategory),
        ])

        let observer = scheduler.createObserver(Int.self)
        
        searchCategoryButtonTapped
            .bind(to: dependency.viewModel.input.searchCategoryButtonTapped)
            .disposed(by: disposeBag)
        
        dependency.viewModel.output.articles
            .map{$0.count}
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        let expectedEvents = [
            Recorded.next(100, 1), // swiftの記事は1個
            Recorded.next(200, 1), // flutterの記事は１個
            Recorded.next(300, 0), // laravelは0個
            Recorded.next(400, 0) // vuewは0個
        ]

        scheduler.start()
        
        XCTAssertEqual(observer.events, expectedEvents)
    }
}
