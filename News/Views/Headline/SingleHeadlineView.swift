//
//	SingleHeadlineView
//  News
//	Created by: @nedimf on 30/04/2022


import SwiftUI
import Awesome
import SDWebImageSwiftUI

struct SingleHeadlineView: View {
    let headline: Headline?
    var body: some View {
        ZStack {
            WebImage(url: URL(string: headline?.urlToImage ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
                .overlay(.black.opacity(0.7))
            VStack(alignment: .leading) {
                Text(headline?.title ?? "Title missing")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Divider()
                    .background(Color.white)
                    .padding(.trailing, 50)
                
                HStack {
                    Text(headline?.source?.name ?? "Source missing")
                        .font(.subheadline)
                    Spacer()
                    Text(headline?.author ?? "Author missing")
                        .font(.subheadline)
                    Spacer()
                    Text(headline?.publishedAt?
                        .replacingOccurrences(of: "T", with: "\n")
                        .replacingOccurrences(of: "Z", with: "")
                         ?? "Missing")
                    .font(.subheadline)
                }.padding(.trailing, 50)
                
                Divider()
                    .background(Color.white)
                    .padding(.trailing, 50)
                
                
                Text(headline?.content?.replacingOccurrences(of: "\\…(.*)", with: "...", options: .regularExpression) ?? "Content Missing")
                    .fontWeight(.medium)
                
                Divider()
                    .background(Color.white)
                    .padding(.trailing, 50)
                
                if let headlineURL = headline?.url {
                    if let destination = URL(string: headlineURL){
                        Link(destination: destination) {
                            Text("View Full Article")
                                .foregroundColor(.blue)
                                .underline()
                        }
                    }else{
                        Text("Article URL is not valid")
                    }
                }
                
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.bottom, 64)
        }
        .toolbar {
            HStack{
                Button {
                    print("Share")
                } label: {
                    Awesome.Brand.twitter.image
                        .foregroundColor(.systemBlue)
                }
                Button {
                    print("Share")
                } label: {
                    Awesome.Brand.facebookMessenger.image
                        .foregroundColor(.white)
                }
                Button {
                    print("Share")
                } label: {
                    Awesome.Brand.instagram.image
                        .foregroundColor(.white)
                }
            }
            
        }
        .onAppear {
            if let headline = headline {
                if headline.content == nil{
                    if let url = headline.url{
                        if let URL = URL(string: url){
                            UIApplication.shared.open(URL)
                        }
                    }
                }
            }
        }
    }
    
    struct SingleHeadlineView_Previews: PreviewProvider {
        static var previews: some View {
            SingleHeadlineView(headline: Headline(source: nil, author: "Preview", title: "Preview", articleDescription: "Preview", url: "Preview", urlToImage: "Preview", publishedAt: "Preview", content: "Preview"))
        }
    }
}
