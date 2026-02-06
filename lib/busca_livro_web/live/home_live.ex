defmodule BuscaLivroWeb.HomeLive do
  use BuscaLivroWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_async(:books, fn ->
        books =
          BuscaLivro.Founds.list_books!(page: [limit: 10, offset: 0])
          |> Map.get(:results)

        {:ok, %{books: books}}
      end)

    {:ok, socket}
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

          <.async_result :let={books} assign={@books}>
            <:loading>
              <ul class="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
                <.books_card_skeleton :for={_ <- 1..6} />
              </ul>
            </:loading>
            <ul class="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
              <.book_card :for={book <- books} book={book} />
            </ul>
          </.async_result>
        </div>
        <div class="h-32 rounded bg-gray-300">
          tchau
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp books_card_skeleton(assigns) do
    ~H"""
    <div class="card cursor-pointer border border-dotted bg-base-200 w-96 shadow-xl">
      <figure class="px-4 pt-4">
        <div class="skeleton h-72 w-full rounded-xl"></div>
      </figure>

      <div class="card-body gap-4 flex-1 min-h-[250px]">
        <div class="skeleton h-7 w-4/5"></div>
        <div class="skeleton h-6 w-2/5"></div>
        <div class="skeleton h-6 w-3/5"></div>
      </div>
    </div>
    """
  end

  defp book_card(assigns) do
    ~H"""
    <div class="card cursor-pointer border border-dotted bg-base-200 w-96 shadow-xl hover:shadow-2xl transition-shadow duration-300">
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
