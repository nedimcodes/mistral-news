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
    @State var paginationCount = 1
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
                    ZStack{
                        Rectangle()
                            .fill(.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                            .frame(width: 200, height: 200, alignment: .center)
                        HStack{
                            Text("Fetching Headlines")
                                .fontWeight(.medium)
                                .padding(.trailing, 10)
                                .foregroundColor(.gray)
                            ProgressView()
                                .foregroundColor(.black)

                        }
                    }.padding()
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
                        .isHidden(headlinesManager.errorLoading)
                    }
                }
            })
            .listStyle(.plain)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: searchText, perform: { _ in
                if searchText.isEmpty{
                    isListLoaded = false
                    headlinesManager.fetchedHeadlines = nil
                    searchManager.hideSticky = true
                }
            })
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
                searchManager.hideSticky = true
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
        SearchView(headlinesManager: HeadlinesManager(), navigationManager: NavigationManager())
    }
}
