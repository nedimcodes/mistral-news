//
//	HeadlinesView
//  News
//	Created by: @nedimf on 29/04/2022


import SwiftUI

struct HeadlinesView: View {
    @ObservedObject var headlinesManager = HeadlinesManager()
    @ObservedObject var navigationManager = NavigationManager()
    @State var singleHeadline:Headline?
    @State var category:NewsCategory?
    @State var paginationCount = 0
    @State var scrollViewId: UUID?

    var body: some View {
        NavigationView{
            VStack{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack {
                        ForEach(NewsCategory.allCases){ category in
                            Text("\(category.rawValue.capitalized)")
                                .onTapGesture {
                                    if category == .trending{
                                        headlinesManager.fetchHeadlines()
                                        self.category = nil
                                        self.scrollViewId = UUID()
                                    }else{
                                        headlinesManager.fetchHeadlines(category: category)
                                        self.category = category
                                        self.scrollViewId = UUID()
                                    }
                                }
                            Divider()
                            
                        }
                    }
                }.padding(.bottom, 10)
                    .padding([.leading, .trailing], 20)
                    .frame(height: 40)
                
                ScrollViewReader{ scrollView in
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

                                                if headline.id == headlinesManager.fetchedHeadlines?.last?.id{
                                                    paginationCount += 1
                                                    headlinesManager.fetchHeadlines(page: paginationCount)
                                                }
                                            }
                                    }
                                }.simultaneousGesture(TapGesture().onEnded{
                                    guard let singleHeadline = singleHeadline else {
                                        return
                                    }
                                    navigationManager.pushHistoryState(history: NavigationHistory(screen: .headlines, id: singleHeadline.id, category: category, headlines: fetchedHeadlines))
                                })
                                
                            }

                        }
                        .onAppear {
                            let lastHistory = navigationManager.mostRecentHistoryState()
                            guard let lastHistory = lastHistory else {
                                return
                            }
                            self.category = lastHistory.category
                            self.headlinesManager.fetchedHeadlines = lastHistory.headlines
                            
                            scrollView.scrollTo(lastHistory.id)
                        }
                    }
                }
                .id(self.scrollViewId)
                .overlay {
                    ErrorView().isHidden(!headlinesManager.errorLoading)
                }
                
            }.navigationTitle(
                Text("\(self.category?.rawValue.capitalized ?? "News")")
            )
                .toolbar{
                    if headlinesManager.loadingAction{
                        HStack{
                            Text("Fetching Headlines")
                                .fontWeight(.light)
                                .padding(.trailing, 10)
                            ProgressView()
                        }
                    }
                    
                }
                .onAppear{
                    if navigationManager.listNavigationHistory.isEmpty{
                        headlinesManager.fetchHeadlines()
                    }
                }
        }
    }
    
}

struct HeadlinesView_Previews: PreviewProvider {
    static var previews: some View {
        HeadlinesView()
    }
}
