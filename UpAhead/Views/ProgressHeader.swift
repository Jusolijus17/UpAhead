//
//  ProgressView.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-04-24.
//

import SwiftUI
import PolyKit

struct ProgressHeader: View {
    @EnvironmentObject var timelineData: TimelineData
    @StateObject var model = ViewModel()
    
    var progression: CGFloat {
        let percent = round(timelineData.completionPercent)
        let normalizedPercent = percent / 100
        let fillAmount = CGFloat(normalizedPercent * model.width)
        return fillAmount
    }
    
    var progressionColor: Color {
        return timelineData.isUpToDate ? .green : .yellow
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: model.isExpanded ? 15 : 25)
            .fill(Color.accentColor)
            .frame(width: model.width, height: model.height)
            .overlay(alignment: .top) {
                VStack {
                    progressBar
                    
                    Rectangle()
                        .fill(.gray)
                        .opacity(0.4)
                        .frame(height: 2)
                        .padding(.horizontal, 5)
                    
                    warningList
                }
                .padding(.top, 5)
                .allowsHitTesting(false)
            }
            .clipped()
            .overlay {
                if !timelineData.isUpToDate {
                    WarningTriangle()
                        .opacity(model.isExpanded ? 0 : 1)
                }
            }
            .shadow(radius: 10)
            .onAppear {
                model.currentPercent = Int(round(timelineData.completionPercent))
            }
            .onChange(of: timelineData.completionPercent) { newValue in
                model.updatePercent(newValue)
            }
            .onTapGesture {
                model.onTap(timelineData: timelineData)
            }
    }
    
    var title: some View {
        Text(Constants.appName)
            .font(.system(size: 32, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal)
            .cornerRadius(20)
            .shadow(radius: 10)
    }
    
    var progressBar: some View {
        Group {
            Rectangle()
                .fill(progressionColor)
                .frame(width: progression, height: 40)
        }
        .frame(width: model.width, alignment: .leading)
        .mask {
            RoundedRectangle(cornerRadius: model.isExpanded ? 10 : 20)
                .frame(width: model.width - 10, height: 40)
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray)
                .opacity(model.isExpanded ? 0.4 : 0)
                .padding(.horizontal, 5)
        }
        .overlay {
            let font = Font.system(size: 32, weight: .bold, design: .rounded)
            HStack(spacing: 0) {
                RollingText(font: font, value: $model.currentPercent)
                Text("%")
                    .font(font)
            }
            .foregroundColor(.white)
            .opacity(model.percentState.showCurrentPercent ? 1 : 0)
            
            !model.percentState.showCurrentPercent ? title : nil
        }
    }
    
    struct WarningTriangle: View {
        var body: some View {
            Polygon(count: 3, cornerRadius: 4)
                .fill(.yellow)
                .overlay {
                    Text("!")
                        .foregroundColor(.gray)
                        .offset(y: -2)
                }
                .frame(width: 30, height: 30)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .offset(y: -13)
        }
    }
    
    var warningList: some View {
        GeometryReader { geo in
            VStack {
                ForEach(model.lateList.indices, id: \.self) { i in
                    let weekday = model.lateList[i].0
                    let count = model.lateList[i].1
                    HStack {
                        Text("\(weekday):")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(count) events late")
                            .foregroundColor(.yellow)
                            .opacity(0.5)
                    }
                    .padding(.horizontal, 10)
                }
            }
        }
        .frame(width: 300)
    }
}


struct ProgressHeader_Previews: PreviewProvider {
    static var previews: some View {
        MainView_Previews.previews
    }
}
