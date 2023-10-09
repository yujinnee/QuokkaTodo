//
//  QuokkaWidgetLiveActivity.swift
//  QuokkaWidget
//
//  Created by 이유진 on 10/9/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct QuokkaWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var todo: String
//        var startTime: Date
//        var endTime: Date
        var seconds: TimeInterval
        var isPaused: Bool
    }
    
    // Fixed non-changing properties about your activity go here!
   
}
@available(iOS 16.2, *)
struct QuokkaWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: QuokkaWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            if(!context.state.isPaused){
                VStack {
                    Spacer()
                    Text("\(context.state.todo)")
                        .foregroundColor(.black)
                        .font(.system(size: 13, weight: .regular))
    //                let future = Calendar.current.date(byAdding: .second, value: 1500, to: Date())!
    //                let future = Date(timeInterval: 25 * 60, since: .now)
    //                let date = Date.now...future
//                    let date = context.state.startTime...context.state.endTime
                    let date = Date.now...Date(timeInterval: context.state.seconds,since: .now)
                    Text(timerInterval:date ,countsDown: true)
                        .multilineTextAlignment(.center)
                        .monospacedDigit()
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundColor(Color.white)
                    Spacer()
                }
                .activityBackgroundTint(Color.brown)
            } 
            else {
                VStack {
                    Spacer()
                    Text("\(context.state.todo)")
                        .foregroundColor(.black)
                        .font(.system(size: 13, weight: .regular))
                    let seconds = Int(context.state.seconds)
                    let dateString = String(format:"%02d:%02d",seconds/60, seconds%60)
                    Text(dateString)
                        .multilineTextAlignment(.center)
                        .monospacedDigit()
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundColor(Color.white)
                    Spacer()
                }
                .activityBackgroundTint(Color.brown)
            }
            
            
        } dynamicIsland: { context in
            DynamicIsland {
                expandedContent(
                    todo: context.state.todo,
                    contentState: context.state,
                    isStale: context.isStale
                )
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("M")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
    
    @DynamicIslandExpandedContentBuilder
    private func expandedContent(todo: String,
                                 contentState: QuokkaWidgetAttributes.ContentState,
                                 isStale: Bool) -> DynamicIslandExpandedContent<some View> {
        DynamicIslandExpandedRegion(.leading) {
            EmptyView()
        }
        
        DynamicIslandExpandedRegion(.trailing) {
            EmptyView()
        }
        
        DynamicIslandExpandedRegion(.bottom) {
            EmptyView()
        }
    }
}

extension QuokkaWidgetAttributes {
//    fileprivate static var preview: QuokkaWidgetAttributes {
//        QuokkaWidgetAttributes(todo: "World")
//    }
}

extension QuokkaWidgetAttributes.ContentState {
//    fileprivate static var time1: QuokkaWidgetAttributes.ContentState {
//        QuokkaWidgetAttributes.ContentState(remainingTimeString: "25:00")
//    }
//    
//    fileprivate static var time2: QuokkaWidgetAttributes.ContentState {
//        QuokkaWidgetAttributes.ContentState(remainingTimeString: "24:00")
//    }
}
//@available(iOS 16.1, *)
//#Preview("Notification", as: .content, using: QuokkaWidgetAttributes.preview) {
//   QuokkaWidgetLiveActivity()
//} contentStates: {
//    QuokkaWidgetAttributes.ContentState.time1
//    QuokkaWidgetAttributes.ContentState.time2
//}
