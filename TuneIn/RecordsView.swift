//
//  RecordsView.swift
//  TuneIn
//
//  Created by Tamas Bara on 25.01.22.
//

import SwiftUI

struct RecordView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @Binding var navigation: Bool
    let record: Record
    
    var body: some View {
        Button {
            viewModel.editedRecord = record
            navigation = true
        } label: {
            HStack(spacing: 6) {
                VStack {
                    Text(record.wher.shorten)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.neon)
                        .frame(width: 50, height: 50)
                }
                .background() {
                    Circle()
                        .foregroundColor(.button2)
                }
                
                VStack(spacing: 6) {
                    
                    HStack {
                        Text(record.what)
                            .font(.system(size: 16, weight: .bold))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.text)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        if record.type == .rock {
                            Text("R")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.neon)
                                .offset(x: 12, y: 10)
                        }
                        Text(record.when.stringify)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color.gray)
                            .offset(x: 10, y: 10)
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .background() {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.button)
        }
    }
}

struct RecordsView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @State var editorNavigation = false
    
    var body: some View {
        ZStack {
            Image("background", bundle: nil)
                .resizable()
                .background(.black)
                .navigationTitle(viewModel.showMonth?.title ?? "")
                .ignoresSafeArea()
            
            NavigationLink(destination: EditorView().environmentObject(viewModel), isActive: $editorNavigation) { EmptyView() }
            
            ScrollView {
                VStack() {
                    Spacer()
                    VStack(spacing: 16) {
                        ForEach(viewModel.records, id: \.self) {
                            RecordView(navigation: $editorNavigation, record: $0).environmentObject(viewModel)
                        }
                    }
                }
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
}

struct RecordsView_Previews: PreviewProvider {
    
    static let viewModel = ViewModel()
    
    static var previews: some View {
        RecordsView()
            .environmentObject(viewModel)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Mini"))
    }
}
