//
//  progressiceView.swift
//  Music Progressive Bar
//
//  Created by 하승민 on 10/16/23.
//

import SwiftUI
//import AVFAudio

struct ProgressMusicBarView: View {
    @State private var audio = AudioPlayer()
    @State private var nowTime = 0.0 // 현재 재생 시간(초)
    
    // Frame Per Seconds
    let timer = Timer.publish(every: Const.fps, on: .main, in: .common).autoconnect()
    
    // For Rotation
    @State private var totalAngle = 0.0 // 총 회전 각도 (0 ~ 360)
    @State private var preAngle = 0.0 // 이전 드래그 각도
   
    // For EventHandle
    @State private var paused = true
    @State private var nowDragging = false
    @State private var musicSelected = false
    
    var body: some View {
        GeometryReader{ proxy in
            VStack {
                ZStack{
                    //앨범 표지
                
                    Image(uiImage: audio.info.albumCover)
                        .resizable()
                        .rotationEffect(Angle(degrees: totalAngle))
                        .clipShape(Circle())
                        .frame(width: viewModel.getProFrame(),
                               height: viewModel.getProFrame())
                        .position(viewModel.getProPosition())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    
                                    // music Selceted?
                                    guard musicSelected else {
                                        return
                                    }
                                    
                                    // 센터 == 원의 중심점
                                    let center = viewModel.getProPosition()
                                    let curAngle = angle.getAtan(center: center, pos: value.location)
                                    
                                    // 만약 막 드래그를 시작했다면
                                    if nowDragging == false {
                                        preAngle = angle.getAtan(center: center, pos: value.startLocation)
                                        stateManager.letDrag()
                                    }
                                    
                                    totalAngle += angle.modifyDiffer(differ: curAngle - preAngle)
                                    totalAngle = angle.getNomalizedAngle(angle: totalAngle)
                                    
                                    // 변한 totalAngle 만큼 현재 음악 재생 시간 업데이트
                                    nowTime = (totalAngle / Const.oneCycle) * totalTime
                                    
                                    // preAngle 업데이트
                                    preAngle = curAngle
                                }
                                .onEnded { _ in
                                    if musicSelected == false { return }
                                    
                                    audio.play(from: nowTime)
                                    stateManager.letDragEnd()
                                }
                        )
                    
                    //Stroke Circle
                    Circle()
                        .trim(from: 0, to: (nowTime / totalTime))
                        .rotation(Angle(degrees: -90))
                        .stroke(.concept.opacity(viewModel.getStrokeOpacity()),
                                style: StrokeStyle (lineWidth: viewModel.getStrokeLineWidth(),
                                                    lineCap: .round))
                        .frame(width: viewModel.getStrokeFrame(),
                               height: viewModel.getStrokeFrame())
                        .position(viewModel.getProPosition())
                    
                    // Inner Circle
                    Circle()
                        .fill(.concept)
                        .frame(width: viewModel.getInnerCircleFrame(), height: viewModel.getInnerCircleFrame())
                        .position(viewModel.getProPosition())
                    
                    mp3FileImporterView(audio: $audio, musicSelected: $musicSelected)
                        .position(viewModel.getProPosition())
                }
                .frame(maxHeight: viewModel.getStackFrame())
                
                // Title, artist, ProgressView
                tearedTextView(text: audio.info.title, size: 40)
                tearedTextView(text: audio.info.artist, size: 20)
                
                ProgressView(value: nowTime, total: totalTime)
                    .progressViewStyle(ProgressBarWithTime(nowTime: nowTime, totalTime: totalTime))
                    .padding(.top)
                    .padding(.bottom, 20)
                    .padding(.horizontal)
                
                // play Controller
                MusicControllerView(paused: $paused, musicSelected: $musicSelected)
                Spacer()
                Spacer()
            }
            .ignoresSafeArea()
            
        }
        .background(viewModel.getBackGroundLinear())
        .background(
            Image(uiImage: audio.info.blurredAlbumCover)
                .resizable()
                .frame(width: viewModel.getBackgroundFrame().width,
                       height: viewModel.getBackgroundFrame().height)
        )
        //when event occured
        .onReceive(timer, perform: { _ in
            
            if stateManager.isPlayable() == false  { return }
            
            if nowTime < totalTime {
                
                totalAngle += angle.anglePerSec(totalTime: totalTime)
                totalAngle = angle.getNomalizedAngle(angle: totalAngle)
                
                nowTime = (totalAngle / Const.oneCycle) * totalTime
            }
            else {
                nowTime = totalTime
                paused = true
            }
        })
        .onChange(of: paused) { _ in
            if !musicSelected { return }
            
            if paused == true {
                audio.pause()
            }
            else if paused == false {
                audio.play()
            }
        }
    }
    
    // ViewModels and Model.
    var viewModel: ProgressiveViewModel {
        ProgressiveViewModel(Image: $audio.info.albumCover)
    }
    var stateManager: stateManager {
        Music_Progressive_Bar.stateManager(paused: $paused, nowDragging: $nowDragging, musicSelected: $musicSelected)
    }
    var angle: AngleCalculator {
        AngleCalculator()
    }
    var totalTime: Double {
        return audio.info.totalTime
    }
    
    
}


@ViewBuilder
func tearedTextView(text: String, size: CGFloat) -> some View {
    Text(text)
        .foregroundStyle(Color.white)
        .font(.system(size: size, design: .rounded))
}

@ViewBuilder
func MusicControllerButton(systemName: String, frame: CGFloat, action: (() -> Void)? = nil) -> some View {
    Button(
        action: {
            action?()
        },
        label: {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .foregroundStyle(Color.white)
            .frame(width: frame, height: frame)
        }
    )
}

@ViewBuilder
func InnerCircle() -> some View {
    
}

struct MusicControllerView: View {
    @Binding var paused: Bool
    @Binding var musicSelected: Bool
    
    var body: some View {
        HStack {
            Spacer()
            MusicControllerButton(systemName: "repeat", frame: 20.0)
            Spacer()
            MusicControllerButton(systemName: "backward.fill", frame: 25.0)
            Spacer()
            MusicControllerButton(systemName: paused ? "play.fill" : "pause.fill", frame: 34.0, action: {
                if musicSelected {
                    paused.toggle()
                }
            })
            Spacer()
            MusicControllerButton(systemName: "forward.fill", frame: 25.0)
            Spacer()
            MusicControllerButton(systemName: "shuffle", frame: 20.0)
            Spacer()
        }
    }
}

// File Importer View
struct mp3FileImporterView: View {
    
    @Binding var audio: AudioPlayer
    @State var isFileImporterPresented = true
    @Binding var musicSelected: Bool
    
    var body: some View {
        Button {
            isFileImporterPresented = true
            
        } label: {
            Image(systemName: !musicSelected ? "folder.fill" : "")
                .resizable()
                .frame(width: 39, height: 26)
                .foregroundStyle(.gray)
        }
        .fileImporter(isPresented: $isFileImporterPresented, allowedContentTypes: [.mp3]) { result in
            
            switch result {
            case .success(let url):
                let _ = url.startAccessingSecurityScopedResource()
                audio.load(from: url)
                musicSelected = true
                Task {
                    audio.info = await fetchAudioMetadata(from: url)
                    audio.info.totalTime = audio.getTotalTime()
                }
                let _ = url.stopAccessingSecurityScopedResource()
                
                print(audio.info.totalTime)
            case .failure(let failure):
                print(failure.localizedDescription)
                musicSelected = false
            }
            
            isFileImporterPresented = false
        }
        .disabled(musicSelected)
    }
}

struct preview: PreviewProvider {
    static var previews: some View {
        ProgressMusicBarView()
    }
}

