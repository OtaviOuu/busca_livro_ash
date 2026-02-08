defmodule BuscaLivroWeb.PageController do
  use BuscaLivroWeb, :controller

  def redirec(conn, _params) do
    redirect(conn, to: "/home")
  end
end
