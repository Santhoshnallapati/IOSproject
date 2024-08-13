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
                        } 
                        //                        else if item.borrowedUserID == currentUserID {
                        //                            Button("Return") {
                        //                                selectedItem = item
                        //                                isReturning = true
                        //                                showingAlert = true
                        //                            }
                        //                            .padding(.top, 5)
                        //                            .foregroundColor(.green)
                        //                        } 
                        else 
                        {
                            Button("Unavailable")
                            {
                                selectedItem = item
                                showingAlert = true
                                isReturning = false
                            }
                            .padding(.top, 5)
                            .foregroundColor(.red)
                        }
                    }
                }
                .alert(isPresented: $showingAlert) {
                    if isReturning {
                        return Alert(
                            title: Text("Confirm Return"),
                            message: Text("Do you want to return \(selectedItem?.bookname ?? "this book")?"),
                            primaryButton: .default(Text("Return")) {
                                if let item = selectedItem {
                                    databaseManager.returnBook(item) {
                                        databaseManager.fetchItem { books in
                                            databaseManager.Books = books
                                        }
                                    }
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    } else
                    {
                        return Alert(
                            title: Text(selectedItem?.isAvailable == true ? "Confirm Borrow" : "Unavailable"),
                            message: Text(selectedItem?.isAvailable == true ? "Do you want to borrow \(selectedItem?.bookname ?? "this book")?" : "\(selectedItem?.bookname ?? "This book") is not available to borrow."),
                            primaryButton: .default(Text(selectedItem?.isAvailable == true ? "Borrow" : "OK")) {
                                if let item = selectedItem, selectedItem?.isAvailable == true {
                                    databaseManager.borrowItem(item) {
                                        databaseManager.fetchItem { books in
                                            databaseManager.Books = books
                                        }
                                    }
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                .padding()
                HStack{
                    
                    NavigationLink(destination: AboutLibraryView()) {
                        Text("About Library")
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                    NavigationLink(destination: BorrowedBooksView()) {
                        Text(" Borrowed Books")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                    
                    NavigationLink(destination: Profilepage()) {
                        Text("Go to Profile")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
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
