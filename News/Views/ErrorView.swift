//
//	ErrorView
//  News
//	Created by: @nedimf on 03/05/2022


import SwiftUI
import Awesome

struct ErrorView: View {
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.red.opacity(0.8))
            HStack{
                Awesome.Solid.exclamationTriangle.image
                    .foregroundColor(.white)
                Text("Connection with server can not established! Please try again.")
                    .fontWeight(.medium)
            }.padding()
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
