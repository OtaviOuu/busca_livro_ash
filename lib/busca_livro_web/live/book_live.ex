defmodule BuscaLivroWeb.BookLive do
  use BuscaLivroWeb, :live_view

  on_mount {BuscaLivroWeb.LiveUserAuth, :current_user}
  on_mount {BuscaLivroWeb.LiveUserAuth, :live_user_optional}

  def mount(%{"id" => book_id}, _session, socket) do
    case BuscaLivro.Founds.get_book(book_id) do
      {:ok, book} ->
        socket =
          socket
          |> assign(:current_user, socket.assigns.current_user)
          |> assign(:book, book)

        {:ok, socket}

      {:error, _} ->
        {:ok, push_navigate(socket, to: "/home")}
    end
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.link navigate="/home" class="btn btn-ghost">
        <.icon name="hero-arrow-left" class="w-5 h-5" /> back
      </.link>
      <.header>
        <h1 class="text-2xl font-bold">{@book.title}</h1>
      </.header>
      <.button
        phx-click="delete"
        class="btn btn-error"
      >
        Delete
      </.button>
      <img src={@book.image_url} />
    </Layouts.app>
    """
  end

  def handle_event("delete", _params, socket) do
    current_user = socket.assigns.current_user

    case BuscaLivro.Founds.delete_found_book(socket.assigns.book, actor: current_user) do
      {:ok, _} -> {:noreply, push_navigate(socket, to: "/home")}
      {:error, _} -> {:noreply, socket}
    end
  end
end
