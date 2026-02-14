defmodule BuscaLivroWeb.HomeLive do
  use BuscaLivroWeb, :live_view

  on_mount {BuscaLivroWeb.LiveUserAuth, :current_user}
  on_mount {BuscaLivroWeb.LiveUserAuth, :live_user_optional}

  def mount(_params, _session, socket) do
    {:ok, book_count} = BuscaLivro.Founds.count_books()
    {:ok, assign(socket, book_count: book_count)}
  end

  def handle_params(params, _url, socket) do
    query = Map.get(params, "book-query", "")

    socket =
      socket
      |> assign(:current_user, socket.assigns.current_user)
      |> assingn_books(query)

    case socket.assigns.current_user do
      nil -> {:noreply, socket}
      _ -> {:noreply, assign_found_books(socket)}
    end
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="container mx-auto px-4 py-6">
        <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">
          <div class="xl:col-span-2 space-y-6">
            <div class="card bg-base-100 shadow-sm">
              <div class="card-body">
                <.form for={nil} class="w-full" phx-change="search">
                  <div class="relative">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-4 pointer-events-none z-10">
                      <.icon name="hero-magnifying-glass" class="w-5 h-5 text-base-content/50" />
                    </span>

                    <input
                      phx-debounce="100"
                      type="search"
                      placeholder="Buscar livros..."
                      name="search_form[book_name]"
                      autocomplete="off"
                      class="input input-bordered w-full pl-12 h-12"
                    />
                  </div>
                </.form>

                <div class="flex justify-end">
                  <div class="badge badge-primary badge-lg">{@book_count}</div>
                </div>
              </div>
            </div>

            <.async_result :let={books} assign={@books}>
              <:loading>
                <ul class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                  <.books_card_skeleton :for={_ <- 1..6} />
                </ul>
              </:loading>

              <%= if books == [] do %>
                <.empty_books />
              <% else %>
                <ul class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                  <.book_card :for={book <- books} book={book} />
                </ul>
              <% end %>
            </.async_result>
          </div>

          <div class="space-y-6">
            <div class="card bg-base-100 shadow-sm">
              <div class="card-body">
                <.header>
                  Achados
                  <:subtitle>
                    Seus livros encontrados
                  </:subtitle>
                </.header>

                <div :if={@current_user} class="flex flex-wrap gap-2">
                  <p
                    :for={word <- @current_user.wanted_words}
                    class="badge badge-primary badge-outline"
                  >
                    {word}
                  </p>
                </div>
              </div>
            </div>

            <.async_result :let={books_founds} :if={@current_user} assign={@books_founds}>
              <:loading>
                <ul class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-1 gap-4">
                  <.books_card_skeleton :for={_ <- 1..4} />
                </ul>
              </:loading>

              <ul class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-1 gap-4">
                <.found_book_card :for={book_found <- books_founds} book_found={book_found} />
              </ul>
            </.async_result>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp books_card_skeleton(assigns) do
    ~H"""
    <div class="card bg-base-200 w-full">
      <figure class="aspect-[3/4] p-4">
        <div class="skeleton w-full h-full rounded-xl"></div>
      </figure>

      <div class="card-body gap-3">
        <div class="skeleton h-5 w-4/5"></div>
        <div class="skeleton h-4 w-2/5"></div>
        <div class="skeleton h-4 w-3/5"></div>
      </div>
    </div>
    """
  end

  defp found_book_card(assigns) do
    ~H"""
    <div class="card bg-base-200 shadow hover:shadow-xl transition w-full">
      <figure class="aspect-[4/3] overflow-hidden">
        <a href={@book_found.book.url} class="w-full h-full">
          <img
            src={@book_found.book.image_url}
            class="w-full h-full object-cover"
          />
        </a>
      </figure>

      <div class="card-body p-4">
        <h2 class="card-title text-base line-clamp-2">
          {@book_found.book.title}
        </h2>
        <p class="text-sm opacity-70">{@book_found.book.price}</p>
        <p class="text-xs opacity-50">{@book_found.book.inserted_at}</p>
      </div>
    </div>
    """
  end

  defp book_card(assigns) do
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

  defp empty_books(assigns) do
    ~H"""
    <div class="card bg-base-100 shadow max-w-lg mx-auto">
      <div class="card-body text-center space-y-4">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="mx-auto w-16 h-16 opacity-40"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="1.5"
            d="M15.182 16.318A4.486 4.486 0 0 0 12.016 15a4.486 4.486 0 0 0-3.198 1.318M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
          />
        </svg>

        <h2 class="text-xl font-bold">Nenhum livro encontrado</h2>
        <p class="text-sm opacity-70">
          Tente outro termo de busca ou explore novas categorias.
        </p>

        <div class="flex flex-col gap-2">
          <.button class="btn btn-primary w-full">Explorar</.button>
          <.button class="btn btn-outline w-full">Refinar busca</.button>
        </div>
      </div>
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
            BuscaLivro.Founds.list_books!(page: [limit: 20, offset: 0])
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

  def assign_found_books(socket) do
    current_user = socket.assigns.current_user

    assign_async(socket, :books_founds, fn ->
      books_founds =
        BuscaLivro.Founds.list_achados!(actor: current_user, page: [limit: 10, offset: 0])
        |> Map.get(:results, [])

      {:ok, %{books_founds: books_founds}}
    end)
  end
end
