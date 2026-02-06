defmodule BuscaLivroWeb.HomeLive do
  use BuscaLivroWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    query = Map.get(params, "book-query", "")

    socket =
      socket
      |> assingn_books(query)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="grid grid-cols-1 gap-4 lg:grid-cols-3 lg:gap-8">
        <div class="h-32 rounded lg:col-span-2">
          <div class="w-full flex justify-center px-6 py-8">
            <.form for={nil} class="w-full max-w-md" phx-change="search">
              <div class="relative">
                <span class="absolute inset-y-0 left-0 flex items-center pl-4 pointer-events-none z-10">
                  <.icon name="hero-magnifying-glass" class="w-5 h-5 text-base-content/50" />
                </span>

                <input
                  type="search"
                  placeholder="Buscar livros..."
                  name="search_form[book_name]"
                  autocomplete="off"
                  class="
                  w-full h-14 pl-12 pr-4
                  input input-bordered
                  text-base
                  focus:outline-none focus:ring-2 focus:ring-primary/30
                  transition-all duration-150
                  shadow-sm
                "
                />
              </div>
            </.form>
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

  def handle_event("search", %{"search_form" => %{"book_name" => book_name}}, socket) do
    book_name = String.trim(book_name)

    case book_name do
      "" -> {:noreply, push_patch(socket, to: ~p"/home")}
      _ -> {:noreply, push_patch(socket, to: ~p"/home?book-query=#{book_name}")}
    end
  end

  def assingn_books(socket, query) do
    case query do
      "" ->
        assign_async(socket, :books, fn ->
          books =
            BuscaLivro.Founds.list_books!(page: [limit: 10, offset: 0])
            |> Map.get(:results, [])

          {:ok, %{books: books}}
        end)

      _ ->
        assign_async(socket, :books, fn ->
          books =
            BuscaLivro.Founds.search_books!(query, page: [limit: 10, offset: 0])
            |> Map.get(:results, [])

          {:ok, %{books: books}}
        end)
    end
  end
end
