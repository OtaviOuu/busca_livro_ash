defmodule BuscaLivroWeb.Profile.BookCard do
  use BuscaLivroWeb, :html

  attr :book, :map, required: true

  def book_card(assigns) do
    ~H"""
    <div class="card bg-base-200 shadow hover:shadow-xl transition w-full h-full">
      <figure class="aspect-[3/4] overflow-hidden">
        <.link navigate={~p"/books/#{@book.id}"} class="w-full h-full">
          <img
            src={@book.image_url}
            alt="book cover"
            class="w-full h-full object-cover"
          />
        </.link>
      </figure>

      <div class="card-body p-4">
        <h2 class="card-title text-base line-clamp-2">{@book.title}</h2>
        <p class="text-sm opacity-70">{@book.price}</p>
        <p class="text-xs opacity-50">{@book.inserted_at}</p>
      </div>
    </div>
    """
  end
end
