import SwiftUI

struct ConViewNavigationBar<Leading: View, Trailing: View>: View {
    let title: String
    let leading: Leading
    let trailing: Trailing
    
    init(
        title: String,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.leading = leading()
        self.trailing = trailing()
    }
    
    var body: some View {
        HStack {
            leading
                .frame(width: 44)
            
            Spacer()
            
            Text(title)
                .font(.headline)
            
            Spacer()
            
            trailing
                .frame(width: 44)
        }
        .padding()
        .background(
            ConViewStyle.Colors.background
                .ignoresSafeArea(edges: .top)
                .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
        )
    }
} 