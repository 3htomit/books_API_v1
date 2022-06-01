module Api
  module V1
    class BooksController < ApplicationController
      def index
        books = Book.all

        render json: BooksRepresenter.new(books).as_json
      end

      def create
        new_author = Author.create!(author_params)
        new_book = Book.new(book_params.merge(author_id: new_author.id))

        if new_book.save
          render json: new_book, status: :created
        else
          render json: new_book.errors, status: :unprocessable_entity
        end
      end

      def destroy
        Book.find(params[:id]).destroy!

        head :no_content
      end

      private

      def author_params
        params.require(:author).permit(:first_name, :last_name)
      end

      def book_params
        params.require(:book).permit(:title)
      end
    end
  end
end
