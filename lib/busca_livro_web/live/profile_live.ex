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
      <div class="max-w-2xl mx-auto space-y-6">
        <div class="card bg-base-100 shadow-sm">
          <div class="card-body space-y-4">
            <div>
              <h3 class="font-semibold text-base-content">Palavras monitoradas</h3>
            </div>

            <div class="flex flex-wrap gap-2 min-h-8">
              <span
                :for={word <- @current_user.wanted_words}
                class="badge badge-primary gap-1 cursor-default select-none"
              >
                {word}
                <button
                  phx-click="remove_wanted_word"
                  phx-value-word={word}
                  class="hover:text-primary-content/60 transition-opacity"
                  aria-label={"Remover #{word}"}
                >
                  <.icon name="hero-x-mark" class="size-3" />
                </button>
              </span>

              <span
                :if={@current_user.wanted_words == []}
                class="text-sm text-base-content/40 italic"
              >
                Nenhuma palavra adicionada ainda.
              </span>
            </div>

            <div class="divider my-0"></div>

            <.form
              id="add-wanted-word-form"
              for={@form_to_add_wanted_word}
              phx-submit="add_wanted_word"
              class="flex gap-2 items-start"
            >
              <div class="flex-1">
                <.input
                  type="text"
                  field={@form_to_add_wanted_word[:new_word]}
                  placeholder="Nova palavra..."
                  autocomplete="off"
                />
              </div>
              <.button
                type="submit"
                class="btn btn-primary"
                disabled={length(@current_user.wanted_words) >= 5}
              >
                <.icon name="hero-plus" class="size-4" /> Adicionar
              </.button>
            </.form>

            <p :if={length(@current_user.wanted_words) >= 5} class="text-xs text-warning">
              Limite de 5 palavras atingido.
            </p>
          </div>
        </div>
      </div>
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
          |> put_flash(:info, "Palavra adicionada com sucesso.")
          |> push_navigate(to: ~p"/profile")

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form_to_add_wanted_word: form)}
    end
  end

  def handle_event("remove_wanted_word", %{"word" => word}, socket) do
    actor = socket.assigns.current_user

    case BuscaLivro.Accounts.remove_wanted_word(actor, word, actor: actor) do
      {:ok, user} ->
        socket =
          socket
          |> assign(current_user: user)
          |> put_flash(:info, "Palavra removida com sucesso.")
          |> push_navigate(to: ~p"/profile")

        {:noreply, socket}

      {:error, reason} ->
        socket =
          socket
          |> put_flash(:error, "Não foi possível remover a palavra. Tente novamente.")

        {:noreply, socket}
    end
  end
end
