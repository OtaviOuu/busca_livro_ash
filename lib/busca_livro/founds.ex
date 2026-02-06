defmodule BuscaLivro.Founds do
  use Ash.Domain,
    otp_app: :busca_livro,
    extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource BuscaLivro.Founds.Book do
      define :create_book, action: :create
    end
    resource BuscaLivro.Founds.Plataform
  end
end
