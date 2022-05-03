//
//	SearchStickyView
//  News
//	Created by: @nedimf on 01/05/2022


import SwiftUI
import Awesome

struct SearchStickyView: View {
    @ObservedObject var searchManager:SearchManager
    
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .fill(.blue.opacity(0.2))
                    .frame(height: 35)
                HStack{
                    Text("Get Notified For Keyword")
                        .font(.system(size: 14))
                    Divider().foregroundColor(.gray).frame(height: 25)
                    VStack{
                        HStack{
                            Awesome.Solid.bell.image
                                .foregroundColor(.systemBlue)
                            Text("Yes, Please")
                                .foregroundColor(.blue)
                                .font(.system(size: 14))
                        }
                    }.onTapGesture {
                        searchManager.hideSticky = true
                        searchManager.storeSearchKeyword(notify: true)
                    }
                }
            }
        }
    }
}

struct SearchStickyView_Previews: PreviewProvider {
    static var previews: some View {
        SearchStickyView(searchManager: SearchManager())
    }
}
