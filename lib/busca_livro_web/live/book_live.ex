defmodule BuscaLivroWeb.BookLive do
  use BuscaLivroWeb, :live_view

  on_mount {BuscaLivroWeb.LiveUserAuth, :current_user}
  on_mount {BuscaLivroWeb.LiveUserAuth, :live_user_optional}

  def mount(%{"id" => book_id}, _session, socket) do
    case BuscaLivro.Founds.get_book(book_id) do
      {:ok, book} -> {:ok, assign(socket, book: book)}
      {:error, _} -> {:ok, push_navigate(socket, to: "/home")}
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
      <img src={@book.image_url} />
    </Layouts.app>
    """
  end
end
