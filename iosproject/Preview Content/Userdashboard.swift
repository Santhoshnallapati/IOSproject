import SwiftUI
import FirebaseAuth

struct UserDashboard: View {
    @StateObject private var databaseManager = DatabaseManager()
    @State private var selectedItem: AdminBookItem?
    @State private var showingAlert = false
    @State private var isReturning = false
    private var currentUserID = Auth.auth().currentUser?.uid ?? ""

    var body: some View {
        NavigationView {
            VStack {
                List(databaseManager.Books) { item in
                    VStack(alignment: .leading) {
                        Text(item.bookname).font(.headline)
                        Text(item.Authorname).font(.headline)
                        Text(item.bookdescription).font(.subheadline)
                        
                        AsyncImage(url: URL(string: item.bookurl)) { phase in
                            switch phase {
                            case .empty:
                                Image(systemName: "photo")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            case .failure:
                                Image(systemName: "photo")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                             default:
                                Image(systemName: "photo")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        if item.isAvailable {
                            Button("Borrow") {
                                selectedItem = item
                                isReturning = false
                                showingAlert = true
                            }
                            .padding(.top, 5)
                            .foregroundColor(.blue)
                        } else if item.borrowedUserID == currentUserID {
                            Button("Return") {
                                selectedItem = item
                                isReturning = true
                                showingAlert = true
                            }
                            .padding(.top, 5)
                            .foregroundColor(.green)
                        } else {
                            Text("Unavailable")
                                .foregroundColor(.red)
                                .padding(.top, 5)
                        }
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text(isReturning ? "Confirm Return" : "Confirm Borrow"),
                        message: Text(isReturning ? "Do you want to return \(selectedItem?.bookname ?? "this book")?" : "Do you want to borrow \(selectedItem?.bookname ?? "this book")?"),
                        primaryButton: .default(Text(isReturning ? "Return" : "Borrow")) {
                            if let item = selectedItem {
                                if isReturning {
                                    databaseManager.returnBook(item){
                                        databaseManager.fetchItem { books in
                                            databaseManager.Books = books
                                        }
                                    }
                                }
                                else {
                                    databaseManager.borrowItem(item) {
                                        databaseManager.fetchItem { books in
                                            databaseManager.Books = books
                                        }
                                    }
                                }
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                .padding()
                NavigationLink(destination: BorrowedBooksView()) {
                                   Text("View Borrowed Books")
                                       .padding()
                                       .background(Color.blue)
                                       .foregroundColor(.white)
                                       .cornerRadius(8)
                               }
                
                NavigationLink(destination: Profilepage()) {
                    Text("Go to Profile")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Available Books")
            .onAppear {
                databaseManager.fetchItem { books in
                    databaseManager.Books = books
                }
            }
        }
    }
}

struct UserDashboard_Previews: PreviewProvider {
    static var previews: some View {
        UserDashboard()
    }
}
