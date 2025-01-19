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
                            .shadow(color: .orange, radius: 4)
                            .padding(8)
                    }
                }
            )
    }
}

struct GridCellView_Previews: PreviewProvider {
    static var previews: some View {
        GridCellView(content: Content(contentType: .drop), isVisible: true, width: 200)
    }
}

