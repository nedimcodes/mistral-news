//
//	HeadlineRow
//  News
//	Created by: @nedimf on 30/04/2022


import SwiftUI
import SDWebImageSwiftUI

struct HeadlineRowWebImage: View {
    @State var url: String
    @State var width: Double?
    var body: some View {
        
        WebImage(url: URL(string: url))
        // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
            .onSuccess { image, data, cacheType in
                // Success
                // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
            }
            .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
            .placeholder {
                Rectangle().foregroundColor(.gray)
            }
            .indicator(.activity) // Activity Indicator
            .transition(.fade(duration: 0.5)) // Fade Transition with duration
            .scaledToFill()
            .frame(width: width ?? 300)
        
    }
}

struct HeadlineRow: View {
    
    @State var headline: Headline
    
    var body: some View {
        ZStack {
            WebImage(url: URL(string: headline.urlToImage ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            .overlay(.black.opacity(0.4))
            VStack(alignment: .leading) {
                Text(headline.title ?? "Title missing")
                    .fontWeight(.heavy)
                    .font(Font.headline)
                    .foregroundColor(.white)
                
                
                Text(headline.articleDescription ?? "Title missing")
                    .fontWeight(.medium)
                    .font(Font.subheadline)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                HStack(spacing: 1){
                    Text(headline.author ?? "Author Missing")
                }
                .foregroundColor(.white.opacity(0.9))
                .font(.body)
                .padding(.top, 20)
                
            }.padding([.leading,.trailing], 20)
            
           
         }
        }
        
//        VStack{
//                HeadlineRowWebImage(url: headline.urlToImage ?? "-").overlay(content: {
//                    VStack{
//                        VStack{
//                        Text(headline.title ?? "Title missing")
//                            .fontWeight(.heavy)
//                            .font(Font.headline)
//                            .foregroundColor(.white)
//
//
//                        Text(headline.articleDescription ?? "Title missing")
//                                .fontWeight(.medium)
//                                .font(Font.subheadline)
//                                .foregroundColor(.white)
//                                .padding(.top, 10)
//
//                        }.padding([.leading,.trailing], 20)
//
//                        HStack(spacing: 1){
//                            Text(headline.author ?? "Author Missing")
//
//                        }
//                         .foregroundColor(.white.opacity(0.9))
//                         .font(.body)
//                         .padding([.top, .leading,.trailing], 20)
//
//                    }
//                    .background(SwiftUI.Color.black.opacity(0.4))
//                })
//
//
//            }
    }

struct HeadlineRow_Previews: PreviewProvider {
    static var previews: some View {
        HeadlineRow(headline: Headline(source: nil, author: "Preview", title: "Preview Title", articleDescription: "Preview", url: "Preview", urlToImage: "https://assets-prd.ignimgs.com/2022/04/29/pixy-1651241368669.jpg?width=1280", publishedAt: "Preview", content: "Preview"))
    }
}
