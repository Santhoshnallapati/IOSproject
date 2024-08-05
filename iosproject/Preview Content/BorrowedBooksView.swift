import SwiftUI

struct BorrowedBooksView: View {
    @StateObject private var databaseManager = DatabaseManager()
    
    var body: some View {
        VStack {
            List(databaseManager.BorrowedBooks) { item in
                VStack(alignment: .leading) {
                    Text(item.bookname).font(.headline)
                    Text(item.Authorname).font(.subheadline)
                    Text(item.bookdescription).font(.body)
                    
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
                    
                    Button("Return") {
                        databaseManager.returnBook(item) {
                            databaseManager.fetchBorrowedBooks { books in
                                databaseManager.BorrowedBooks = books
                            }
                        }
                    }
                    .padding(.top, 5)
                    .foregroundColor(.green)
                }
            }
            .onAppear {
                databaseManager.fetchBorrowedBooks { books in
                    databaseManager.BorrowedBooks = books
                }
            }
        }
        .navigationTitle("Borrowed Books")
    }
}

struct BorrowedBooksView_Previews: PreviewProvider {
    static var previews: some View {
        BorrowedBooksView()
    }
}