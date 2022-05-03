//
//	HeadlineRow
//  News
//	Created by: @nedimf on 30/04/2022


import SwiftUI
import SDWebImageSwiftUI

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
        
    }

struct HeadlineRow_Previews: PreviewProvider {
    static var previews: some View {
        HeadlineRow(headline: Headline(source: nil, author: "Preview", title: "Preview Title", articleDescription: "Preview", url: "Preview", urlToImage: "https://assets-prd.ignimgs.com/2022/04/29/pixy-1651241368669.jpg?width=1280", publishedAt: "Preview", content: "Preview"))
    }
}
