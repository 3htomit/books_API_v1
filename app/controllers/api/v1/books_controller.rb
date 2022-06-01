module Api
  module V1
    class BooksController < ApplicationController
      def index
        render json: Book.all, status: :accepted
      end

      def create
        new_book = Book.new(book_params)

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

      def book_params
        params.require(:book).permit(:title, :author)
      end
    end
  end
end
