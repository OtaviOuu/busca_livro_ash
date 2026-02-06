defmodule BuscaLivroWeb.HomeLive do
  use BuscaLivroWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, %{results: books}} = BuscaLivro.Founds.list_books()

    {:ok, assign(socket, books: books)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="grid grid-cols-1 gap-4 lg:grid-cols-3 lg:gap-8">
        <div class="h-32 rounded lg:col-span-2">
          <div class="p-8 flex items-center justify-center w-full">
            <label class="input input-xl w-full max-w-none flex items-center gap-2">
              <.icon name="hero-magnifying-glass" class="w-6 h-6 text-gray-500" />

              <input
                type="search"
                required
                placeholder="Search"
                class="w-full outline-none bg-transparent"
              />
            </label>
          </div>

          <ul class="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
            <.book_card :for={book <- @books} book={book} />
          </ul>
        </div>
        <div class="h-32 rounded bg-gray-300">
          tchau
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp book_card(assigns) do
    ~H"""
    <div class="card bg-base-200 w-96 shadow-xl hover:shadow-2xl transition-shadow duration-300">
      <div class="card-body">
        <h2 class="card-title">{@book.title}</h2>
        <p>
          {@book.price}
        </p>
        <p>
          {@book.inserted_at}
        </p>
      </div>
      <figure>
        <img
          src={@book.image_url}
          alt="Shoes"
        />
      </figure>
    </div>
    """
  end
end
