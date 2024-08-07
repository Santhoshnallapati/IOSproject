//
//  AboutLibraryView.swift
//  iosproject
//
//  Created by Subash Gaddam on 2024-08-06.
//

import SwiftUI

struct AboutLibraryView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("About Library")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(10).background(.gray)

            Text("library offer a wide range of books from various genres and authors. Our mission is to foster a love of reading and provide a community space for learning and growth.")
                .foregroundColor(.gray)

            Text("Library Hours")
                .font(.headline)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
               

            Text("""
                Monday - Friday: 9 AM - 6 PM
                Saturday: 10 AM - 4 PM
                Sunday: Closed
                """)
            .foregroundColor(.gray)

            Text("Location")
                .font(.headline)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

            Text("5290 Chem. de la Côte-des-Neiges, Montréal, QC H3T 1Y2")
                .foregroundColor(.gray)

            Spacer()
        }
        .padding()
        .navigationTitle("About Library")
    }
}

struct AboutLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        AboutLibraryView()
    }
}

