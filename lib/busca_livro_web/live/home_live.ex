defmodule BuscaLivroWeb.HomeLive do
  use BuscaLivroWeb, :live_view

  on_mount {BuscaLivroWeb.LiveUserAuth, :current_user}
  on_mount {BuscaLivroWeb.LiveUserAuth, :live_user_optional}

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    query = Map.get(params, "book-query", "")

    socket =
      socket
      |> assingn_books(query)
      |> assign_found_books()

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="grid grid-cols-1 gap-4 lg:grid-cols-3 lg:gap-8 px-4 py-6">
        <div class="h-32 rounded lg:col-span-2">
          <div class="w-full flex justify-center px-6 py-8">
            <.form for={nil} class="w-full max-w-md" phx-change="search">
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
            <%= if books == [] do %>
              <.empty_books />
            <% else %>
              <ul class="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
                <.book_card :for={book <- books} book={book} />
              </ul>
            <% end %>
          </.async_result>
        </div>
        <div class="h-32 rounded ">
          <.header>
            Achados
            <:subtitle>
              Seus livros encontrados
            </:subtitle>
          </.header>
          <div :if={@current_user} class="flex flex-row gap-2 mb-4">
            <p :for={word <- @current_user.wanted_words} class="badge badge-primary badge-outline">
              {word}
            </p>
          </div>
          <.async_result :let={books_founds} assign={@books_founds}>
            <:loading>
              <ul class="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
                <.books_card_skeleton :for={_ <- 1..6} />
              </ul>
            </:loading>
            <ul class="grid grid-cols-1 gap-4 md:grid-cols-1 lg:grid-cols-2">
              <.found_book_card :for={book_found <- books_founds} book_found={book_found} />
            </ul>
          </.async_result>
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

  defp found_book_card(assigns) do
    ~H"""
    <div class="card cursor-pointer border border-dotted bg-base-200 w-vh shadow-xl hover:shadow-2xl transition-shadow duration-300">
      <div class="card-body">
        <h2 class="card-title">{@book_found.book.title}</h2>
        <p>
          {@book_found.book.price}
        </p>
        <p>
          {@book_found.book.inserted_at}
        </p>
      </div>
      <figure>
        <img
          src={@book_found.book.image_url}
          alt="Shoes"
        />
      </figure>
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

  defp empty_books(assigns) do
    ~H"""
    <div class="max-w-md text-center card mx-auto my-16">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        stroke-width="1.5"
        stroke="currentColor"
        class="mx-auto size-20 text-gray-400"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          d="M15.182 16.318A4.486 4.486 0 0 0 12.016 15a4.486 4.486 0 0 0-3.198 1.318M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0ZM9.75 9.75c0 .414-.168.75-.375.75S9 10.164 9 9.75 9.168 9 9.375 9s.375.336.375.75Zm-.375 0h.008v.015h-.008V9.75Zm5.625 0c0 .414-.168.75-.375.75s-.375-.336-.375-.75.168-.75.375-.75.375.336.375.75Zm-.375 0h.008v.015h-.008V9.75Z"
        >
        </path>
      </svg>

      <h2 class="mt-6 text-2xl font-bold text-gray-900">Hmm, nothing found</h2>

      <p class="mt-4 text-pretty text-gray-700">
        We couldn't find what you were looking for. Try a different search term or explore our
        popular categories.
      </p>

      <div class="mt-6 space-y-2">
        <.button
          href="#"
          class="w-full btn btn-primary"
        >
          Browse Popular Items
        </.button>

        <.button
          href="#"
          class="w-full btn btn-secundary"
        >
          Refine Search
        </.button>
      </div>

      <p class="mt-6 flex flex-wrap justify-center gap-8 text-sm">
        <a href="#" class="text-indigo-600 hover:underline">Trending</a>
        <a href="#" class="text-indigo-600 hover:underline">New</a>
        <a href="#" class="text-indigo-600 hover:underline">Best sellers</a>
      </p>
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
