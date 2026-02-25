defmodule BuscaLivroWeb.Profile.BookLists do
  use BuscaLivroWeb, :html

  import BuscaLivroWeb.Profile.BookCard

  attr :books, :list, required: true

  def book_list(assigns) do
    ~H"""
    <ul class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
      <.book_card :for={book <- @books} book={book} />
    </ul>
    """
  end

  attr :found_books, :list, required: true

  def found_book_list(assigns) do
    ~H"""
    <ul class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-1 gap-4">
      <.book_card :for={book <- @books} book={book} />
    </ul>
    """
  end
end
