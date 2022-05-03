//
//	SearchView
//  News
//	Created by: @nedimf on 01/05/2022


import SwiftUI
import Awesome

struct SearchView: View {
    @ObservedObject var headlinesManager = HeadlinesManager()
    @ObservedObject var navigationManager = NavigationManager()
    @ObservedObject var searchManager = SearchManager()
    @State var isListLoaded = false
    @State private var searchText = ""
    @State var singleHeadline:Headline?
    @State var paginationCount = 0
    @State var enteredFromTabController = true
    var body: some View {
        NavigationView {
            ScrollViewReader{ scrollView in
                SearchStickyView(searchManager: searchManager)
                    .isHidden(searchManager.hideSticky)
                ScrollView{
                    LazyVStack{
                        if let fetchedHeadlines = headlinesManager.fetchedHeadlines{
                            ForEach (fetchedHeadlines, id: \.id) {headline in
                                NavigationLink {
                                    SingleHeadlineView(headline: headline)
                                } label: {
                                    HeadlineRow(headline: headline)
                                        .cornerRadius(13)
                                        .frame(width: 300, height: 400, alignment: .center)
                                        .padding([.leading, .trailing], 10)
                                        .onAppear {
                                            singleHeadline = headline
                                            if !isListLoaded{
                                                isListLoaded = true
                                                let foundKeyword = searchManager.listOfSearchedKeywords.filter{ $0.keyword == searchText && $0.notify == true}
                                                if foundKeyword.isEmpty{
                                                    searchManager.hideSticky = false
                                                }else{
                                                    searchManager.hideSticky = true
                                                }
                                                
                                            }
                                            if headline.id == headlinesManager.fetchedHeadlines?.last?.id{
                                                paginationCount += 1
                                                headlinesManager.fetchHeadlinesPerQuery(query: searchText ,page: paginationCount)
                                            }
                                        }
                                }
                            }.simultaneousGesture(TapGesture().onEnded{
                                guard let singleHeadline = singleHeadline else {
                                    return
                                }
                                enteredFromTabController = false
                                navigationManager.pushHistoryState(history: NavigationHistory(screen: .search, id: singleHeadline.id, category: nil, headlines: fetchedHeadlines))
                            })
                            
                        }
                        
                    }
                    .onAppear {
                        let lastHistory = navigationManager.mostRecentHistoryState()
                        guard let lastHistory = lastHistory else {
                            return
                        }
                        let sortedHistory = navigationManager.listNavigationHistory.sorted{
                            $0.screen == $1.screen
                        }
                        print(sortedHistory)
                        if !enteredFromTabController{
                            self.headlinesManager.fetchedHeadlines = sortedHistory[0].headlines
                            scrollView.scrollTo(lastHistory.id)
                        }
                    }
                }
                .overlay {
                    ErrorView().isHidden(!headlinesManager.errorLoading)
                }
            }
            
            .overlay(content: {
                if headlinesManager.loadingAction{
                    HStack{
                        Text("Fetching Headlines")
                            .fontWeight(.light)
                            .padding(.trailing, 10)
                        ProgressView()
                    }
                }
                if headlinesManager.fetchedHeadlines == nil{
                    if !headlinesManager.loadingAction{
                        VStack{
                            Awesome.Brand.piedPiperAlt.image
                                .foregroundColor(.systemBlue)
                                .resizable()
                                .frame(width: 25, height: 25)
                            
                            Text("Search for example: cute dogs...")
                                .foregroundColor(.gray)
                        }
                        .isHidden(!headlinesManager.errorLoading)
                    }
                }
            })
            .listStyle(.plain)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always)){
                ForEach(searchManager.listOfSearchedKeywords, id: \.id) { searchedKeyword in
                    Text(searchedKeyword.keyword)
                        .searchCompletion(searchedKeyword.keyword)
                }.onAppear{
                    searchManager.listOfSearchedKeywords = [Search]()
                    searchManager.fetchStoredKeywords()
                }
            }
            .onSubmit(of: .search, {
                searchManager.searchKeyword = searchText
                isListLoaded = false
                searchManager.storeSearchKeyword()
                headlinesManager.fetchHeadlinesPerQuery(query: searchText)
                
            })
            .onAppear(perform: {
                if navigationManager.listNavigationHistory.isEmpty{
                    searchText = ""
                    headlinesManager.fetchedHeadlines = nil
                }
                searchManager.fetchStoredKeywords()
                
            })
            .toolbar{
                NavigationLink(destination: KeywordRepresentableView()) {
                    VStack{
                        Awesome.Solid.archive.image
                            .foregroundColor(.systemBlue)
                    }
                }
            }
            .navigationTitle("Search")
        }
    }
    
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(enteredFromTabController: false)
    }
}
