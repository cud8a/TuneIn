//
//  MonthsView.swift
//  TuneIn
//
//  Created by Tamas Bara on 26.01.22.
//

import SwiftUI

struct MonthButton: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @Binding var navigation: Bool
    let month: Month
    
    var body: some View {
        
        Button {
            viewModel.showMonth = month
            navigation = true
        } label: {
            VStack(spacing: 6) {
                Text(month.title)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.text)
                    .pinLeft()
                
                Text(month.entries)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray)
                    .pinLeft()
                
                Text(month.rockEntries)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.text)
                    .pinLeft()
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            .background() {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct MonthsView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @State var recordsNavigation = false
    @State var editorNavigation = false
    
    let gridItemLayout = [GridItem(.flexible(), spacing: 16), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background", bundle: nil)
                    .resizable()
                    .background(.black)
                    .navigationTitle("Records")
                    .ignoresSafeArea()
                
                NavigationLink(destination: RecordsView().environmentObject(viewModel), isActive: $recordsNavigation) { EmptyView() }
                
                NavigationLink(destination: EditorView().environmentObject(viewModel), isActive: $editorNavigation) { EmptyView() }
                
                ScrollView {
                    LazyVGrid(columns: gridItemLayout, spacing: 16) {
                        ForEach(viewModel.months, id: \.self) {
                            MonthButton(navigation: $recordsNavigation, month: $0).environmentObject(viewModel)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                }
                .animation(.easeInOut, value: viewModel.records.count)
                .frame(maxWidth: .infinity)
                
                VStack {
                    Spacer()
                    Button {
                        viewModel.newRecord = Record()
                        editorNavigation = true
                    } label: {
                        PlusButton()
                    }
                    .pinRight()
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 20))
            }
        }
        .accentColor(.neon)
    }
}

struct MonthsView_Previews: PreviewProvider {
    
    static let viewModel = ViewModel()

    static var previews: some View {
        MonthsView()
            .environmentObject(viewModel)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Mini"))
    }
}
