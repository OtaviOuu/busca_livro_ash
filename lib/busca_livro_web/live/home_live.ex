defmodule BuscaLivroWeb.HomeLive do
  use BuscaLivroWeb, :live_view

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="grid grid-cols-1 gap-4 lg:grid-cols-3 lg:gap-8">
        <div class="h-32 rounded bg-gray-300 lg:col-span-2">
          oi
        </div>
        <div class="h-32 rounded bg-gray-300">
          tchau
        </div>
      </div>
    </Layouts.app>
    """
  end
end
