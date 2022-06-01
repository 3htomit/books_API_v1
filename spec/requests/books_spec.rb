require 'rails_helper'

describe 'Books API', type: :request do
  describe 'GET /books' do
    before do
      author1 = FactoryBot.create(:author, first_name: 'George', last_name: 'Orwell')
      author2 = FactoryBot.create(:author, first_name: 'HG', last_name: 'Wells')
      FactoryBot.create(:book, title: '1984', author: author1)
      FactoryBot.create(:book, title: 'The Time Machine', author: author2)
    end

    it 'returns all books' do
      get '/api/v1/books'

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'POST /books' do
    it 'creates a new book' do
      expect {
        post '/api/v1/books', params: { book: { title: 'The Martian' }, author: { first_name: 'Andy', last_name: 'Weir' } }
      }.to change { Book.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
      expect(Author.count).to eq(1)
    end
  end

  describe 'DELETE /books/:id' do
    before do
      author1 = FactoryBot.create(:author, first_name: 'George', last_name: 'Orwell')
      @book1 = FactoryBot.create(:book, title: '1984', author: author1)
    end
    # let!(:book) { FactoryBot.create(:book, title: '1984', author: author1) }

    it 'deletes a book' do
      expect {
        delete "/api/v1/books/#{@book1.id}"
      }.to change { Book.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end
  end
end
