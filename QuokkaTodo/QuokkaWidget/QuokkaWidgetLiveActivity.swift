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
        var remainingTimeString: String
    }
    
    // Fixed non-changing properties about your activity go here!
    var todo: String
}
@available(iOS 16.2, *)
struct QuokkaWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: QuokkaWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Spacer()
                Text("\(context.attributes.todo)")
                    .foregroundColor(.black)
                    .font(.system(size: 13, weight: .regular))
                let future = Calendar.current.date(byAdding: .second, value: 1500, to: Date())!
                let date = Date.now...future
                Text(timerInterval:date ,countsDown: true)
                    .multilineTextAlignment(.center)
                    .monospacedDigit()
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundColor(Color.white)
                Spacer()
            }
            .activityBackgroundTint(Color.brown)
            
        } dynamicIsland: { context in
            DynamicIsland {
                expandedContent(
                    todo: context.attributes.todo,
                    contentState: context.state,
                    isStale: context.isStale
                )
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.remainingTimeString)")
            } minimal: {
                Text(context.state.remainingTimeString)
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
