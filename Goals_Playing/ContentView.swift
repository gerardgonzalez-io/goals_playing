//
//  ContentView.swift
//  Goals_Playing
//
//  Created by Adolfo Gerard Montilla Gonzalez on 14-05-26.
//

import SwiftUI

struct ContentView: View
{
    var body: some View
    {
        NavigationStack
        {
            List
            {
                ForEach(NavigationOptions.mainPages)
                { page in
                    NavigationLink(value: page)
                    {
                        Label(page.name, systemImage: page.symbolName)
                    }
                }
            }
            .navigationTitle("Goals")
            .navigationDestination(for: NavigationOptions.self)
            { page in
                switch page
                {
                case .topics:
                    TopicListView()
                case .achievements:
                    EmptyView()
                }
            }
        }
    }
}

#Preview
{
    ContentView()
        .sampleDataContainer()
}
