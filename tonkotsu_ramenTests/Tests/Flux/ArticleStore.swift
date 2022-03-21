//
//  ArticleStore.swift
//  tonkotsu_ramenTests
//
//  Created by 宮本光直 on 2022/03/06.
//

import XCTest
import RxCocoa
import RxSwift

@testable import tonkotsu_ramen

class ArticleStoreTests: XCTestCase {
    
    private struct Dependency {
        
        let store: ArticleStore
        let dispatcher: ArticleDispatcher
        
        init() {
            let flux = Flux.mock()
            
            self.store = flux.articleStore
            self.dispatcher = flux.articleDispatcher
        }
    }
    
    private var dependency: Dependency!
    
    override func setUp() {
        super.setUp()
        
        dependency = Dependency()
    }
    
    func test_dispatcherから送られてきた記事をstoreの記事に更新できているか() {
        let mockArticles: [Article] = [
            Article.mockArticle(),
            Article.mockArticle2()
        ]
        
        let expect = expectation(description: "wait for updating store article")
        let disposable = dependency.store.articles
            .subscribe(onNext: { articles in
                if let articles = articles {
                    XCTAssertEqual(articles.count, mockArticles.count)
                    XCTAssertNotNil(articles.first)
                    XCTAssertEqual(articles[0].title, mockArticles[0].title)
                    XCTAssertEqual(articles[1].url, mockArticles[1].url)
                    expect.fulfill()
                }
            })
        
        dependency.dispatcher.articles.accept(mockArticles)
        wait(for: [expect], timeout: 0.1)
        disposable.dispose()
    }
}
