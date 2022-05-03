//
//	KeywordRepresentableView
//  Struct conforming to UIViewControllerRepresentable
//  News
//	Created by: @nedimf on 02/05/2022


import SwiftUI

struct KeywordRepresentableView: UIViewControllerRepresentable{
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> KeywordsViewController {
        return KeywordsViewController()
    }
}
