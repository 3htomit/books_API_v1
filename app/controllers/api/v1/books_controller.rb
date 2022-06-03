module Api
  module V1
    class BooksController < ApplicationController
      MAX_PAGINATION_LIMIT = 100

      def index
        books = Book.limit(limit).offset(params[:offset])

        render json: BooksRepresenter.new(books).as_json
      end

      def create
        new_author = Author.create!(author_params)
        new_book = Book.new(book_params.merge(author_id: new_author.id))

        if new_book.save
          render json: BookRepresenter.new(new_book).as_json, status: :created
        else
          render json: new_book.errors, status: :unprocessable_entity
        end
      end

      def destroy
        Book.find(params[:id]).destroy!

        head :no_content
      end

      private

      def limit
        [
          params.fetch(:limit, 100).to_i,
          MAX_PAGINATION_LIMIT
        ].min
      end

      def author_params
        params.require(:author).permit(:first_name, :last_name)
      end

      def book_params
        params.require(:book).permit(:title)
      end
    end
  end
end
