//
//  EditorView.swift
//  TuneIn
//
//  Created by Tamas Bara on 25.01.22.
//

import SwiftUI

enum RecordType: String {
    
    case gym
    case rock
    
    var text: String {
        switch self {
        case .gym: return "Halle"
        case .rock: return "Fels"
        }
    }
}

struct WhenView: View {
    
    @Binding var date: Date
    
    var body: some View {
        VStack {
            Text("Wann?")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.gray)
                .pinLeft()
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .invertDark()
                .labelsHidden()
                .transformEffect(.init(scaleX: 1.2, y: 1.2))
                .pinLeft()
        }
    }
}

struct WhereView: View {
    
    @Binding var text: String
    
    var body: some View {
        VStack {
            Text("Wo?")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.gray)
                .pinLeft()
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 36, maxHeight: 36)
                
                TextField("", text: $text)
                    .foregroundColor(.button)
                    .padding(.horizontal, 10)
            }
        }
    }
}

struct WhatView: View {
    
    @Binding var text: String
    
    var body: some View {
        VStack {
            Text("Was?")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.gray)
                .pinLeft()
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
                
                TextEditor(text: $text)
                    .foregroundColor(.button)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            }
        }
    }
}

struct SelectableButton: View {
    
    @Binding var selectedType: RecordType
    let type: RecordType
    
    var selected: Bool {
        selectedType == type
    }
    
    var body: some View {
        Button {
            selectedType = type
        } label: {
            Text(type.text)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(selected ? .black : .gray)
                .frame(width: 120, height: 40)
                .background() {
                    if selected {
                        Capsule()
                            .foregroundColor(.gray)
                    } else {
                        Capsule()
                            .stroke(lineWidth: 2)
                            .foregroundColor(.gray)
                    }
                }
        }
    }
}

struct SwitchView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 10)
            
            HStack(spacing: 16) {
                SelectableButton(selectedType: viewModel.recordBinding().type, type: .rock).environmentObject(viewModel)
                SelectableButton(selectedType: viewModel.recordBinding().type, type: .gym).environmentObject(viewModel)
                Spacer()
            }
        }
    }
}


struct EditorView: View {
    
    enum Mode {
        case add
        case edit
        
        var image: String {
            switch self {
            case .add: return "plus"
            default: return "pencil"
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .add: return 44
            default: return 34
            }
        }
        
        var padding: EdgeInsets {
            switch self {
            case .add: return EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            default: return EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            }
        }
    }
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ZStack {
            Image("background", bundle: nil)
                .resizable()
                .background(.black)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    WhenView(date: viewModel.recordBinding().when)
                    WhereView(text: viewModel.recordBinding().wher)
                    WhatView(text: viewModel.recordBinding().what)
                    SwitchView().environmentObject(viewModel)
                }
                .padding(.horizontal, 16)
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        viewModel.save()
                        presentation.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: viewModel.editorMode.image)
                            .font(.system(size: viewModel.editorMode.fontSize, weight: .bold))
                            .foregroundColor(.neon)
                            .padding(viewModel.editorMode.padding)
                            .background() {
                                Circle()
                                    .foregroundColor(.button)
                            }
                        
                    }
                    if viewModel.editorMode == .edit {
                        Button {
                            viewModel.delete()
                            presentation.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.neon)
                                .padding(EdgeInsets(top: 18, leading: 18, bottom: 18, trailing: 18))
                                .background() {
                                    Circle()
                                        .foregroundColor(.button)
                                }
                            
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 20))
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    
    static let viewModel = ViewModel()
    
    static var previews: some View {
        EditorView()
            .environmentObject(viewModel)
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Mini"))
    }
}
