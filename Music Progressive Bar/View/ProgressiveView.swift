//
//  progressiceView.swift
//  Music Progressive Bar
//
//  Created by 하승민 on 10/16/23.
//

import SwiftUI

/*
 What we need => time to CGfloat (현재 재생 비율 백분위로)
 Image...
 */

struct ProgressiveView: View {
    
    @State var albumImage: UIImage = UIImage(resource: .album)
    @State var blurredAlbumImage: UIImage = ImageEditor().blurImage(image: UIImage(resource: .album), blurAmount: 5.0)
    
    
    @State private var nowTime = 0.0 // 현재 재생 시간(초)
    @State private var totalTime = 180.0 // 총 재생 시간(초)
    static let fps = 0.01
    let timer = Timer.publish(every: fps, on: .main, in: .common).autoconnect()
  
    @State private var paused = false
    
    var body: some View {
        
        VStack {
            Spacer()
            //Spacer()
            ZStack {
                //앨범 표지
                Image(uiImage: albumImage)
                    .resizable()
                    .rotationEffect(Angle(degrees: timerModel.getDegressFromTime()))
                    .clipShape(Circle())
                    .overlay {
                        // 앨범 테두리 ver .1
                        Circle()
                            .trim(from: CGFloat(nowTime / 100), to: 1.0)
                            .rotation(Angle(degrees: -90))
                            .stroke(.concept.opacity(viewModel.strokeOpacity), 
                                    lineWidth: viewModel.strokeLineWidth)
                            .frame(width: viewModel.getStrokeFrame(), 
                                   height: viewModel.getStrokeFrame())
                    }
                    .frame(width: viewModel.getProgressBarFrame(), 
                           height: viewModel.getProgressBarFrame())
            }
            
          
                Text("Attention")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 40))
                Text("NewJeans")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 20))
            Spacer()
            HStack {
                Spacer()
                makeButton(systemName: "repeat", frame: 20.0)
                Spacer()
                makeButton(systemName: "backward.fill", frame: 25.0)
                Spacer()
                Button(
                    action: {
                        paused.toggle()
                },
                    label: {
                        Image(systemName: paused ? "play.fill" : "pause.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .foregroundStyle(Color.white)
                            .frame(width: 34.0, height: 34.0)
                })
                
                
                Spacer()
                makeButton(systemName: "forward.fill", frame: 25.0)
                Spacer()
                makeButton(systemName: "shuffle", frame: 20.0)
                Spacer()
                
            }
            Spacer()
        }
        
        .onReceive(timer, perform: { _ in
            if !paused
            {
                nowTime += ProgressiveView.fps
            }
        })
        .background(LinearGradient(colors: [Color.concept.opacity(0.5),
                                            Color.concept.opacity(0.0)],
                                   startPoint: .bottom, endPoint: .top))
        .background(
            Image(uiImage: blurredAlbumImage)
                .resizable()
                .frame(width: viewModel.getImageFrame().width, 
                       height: viewModel.getImageFrame().height)
                .ignoresSafeArea()
        )
        
    }
    var timerModel: timerModel {
        Music_Progressive_Bar.timerModel(secondsElapsed: $nowTime)
    }
    
    var viewModel: ProgressiveViewModel {
        ProgressiveViewModel(Image: $albumImage)
    }
    
    @ViewBuilder
    func makeButton(systemName: String, frame: CGFloat) -> some View {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            Image(systemName: systemName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .foregroundStyle(Color.white)
                .frame(width: frame, height: frame)
        }
        )
    }
}

struct preview: PreviewProvider {
    static var previews: some View {
        ProgressiveView()
    }
}
