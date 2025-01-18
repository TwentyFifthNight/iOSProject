import SwiftUI

struct GridCellView: View {
    let content: Content
    let isVisible: Bool
    let width: Double
    
    var body: some View {
        Rectangle()
            .frame(width: nil, height: width)
            .cornerRadius(8)
            .foregroundColor(.white)
            .overlay (
                VStack{
                    if isVisible && content.contentType != .blank {
                        Image(systemName: "\(content.systemName)")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(content.foregroundColor)
                            .shadow(color: Color(red: 187/255, green: 174/255, blue: 161/255), radius: 2)
                            .padding(8)
                    }
                }
            )
    }
}
