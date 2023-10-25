//
//  AppIntent.swift
//  QuokkaWidget
//
//  Created by 이유진 on 10/9/23.
//

import WidgetKit
import AppIntents

@available(iOSApplicationExtension 17.0, *)
struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
//    @Parameter(title: "Favorite Emoji", default: "😃")
//    var favoriteEmoji: String
}
