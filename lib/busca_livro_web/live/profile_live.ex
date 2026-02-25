defmodule BuscaLivroWeb.ProfileLive do
  use BuscaLivroWeb, :live_view

  on_mount {BuscaLivroWeb.LiveUserAuth, :current_user}
  on_mount {BuscaLivroWeb.LiveUserAuth, :live_user_required}

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    form_to_add_wanted_word =
      BuscaLivro.Accounts.form_to_add_wanted_word(current_user, actor: current_user)
      |> to_form()

    {:ok, assign(socket, form_to_add_wanted_word: form_to_add_wanted_word)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        Profile
        <:subtitle></:subtitle>
      </.header>
      <.form for={@form_to_add_wanted_word} phx-submit="add_wanted_word" class="form-inline">
        <.input
          class="input"
          type="text"
          field={@form_to_add_wanted_word[:new_word]}
          placeholder="Add wanted word"
        />
        <.button class="btn btn-primary" type="submit">Add</.button>
      </.form>
    </Layouts.app>
    """
  end

  def handle_event("add_wanted_word", %{"form" => params}, socket) do
    current_user = socket.assigns.current_user
    form = socket.assigns.form_to_add_wanted_word

    case AshPhoenix.Form.submit(form, params: params, actor: current_user) do
      {:ok, _form} ->
        socket =
          socket
          |> put_flash(:info, "Wanted word added successfully.")
          |> push_navigate(to: ~p"/profile")

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form_to_add_wanted_word: form)}
    end
  end
end
