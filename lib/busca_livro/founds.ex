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
      define :list_books, action: :read
    end

    resource BuscaLivro.Founds.Plataform
  end
end
