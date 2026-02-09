defmodule BuscaLivro.Founds.Changes.AssociateWantedBookToUser do
  use Ash.Resource.Change

  require Logger

  def change(changeset, _opts, _ctx) do
    Ash.Changeset.after_action(changeset, fn _changeset, book ->
      Logger.debug("Associating wanted book to user...")

      book = Ash.load!(book, :title_words)
      # mmelhor fazer um query e botar o filtro na db, talvez
      users = BuscaLivro.Accounts.list_users!(authorize?: false)

      Enum.each(users, fn user ->
        if Enum.any?(user.wanted_words, &(&1 in book.title_words)) do
          BuscaLivro.Founds.associate_wanted_book_to_user(book.id, user.id,
            upsert?: true,
            upsert_identity: :unique_found_book,
            upsert_fields: [:book_id, :user_id],
            authorize?: false
          )
        end
      end)

      {:ok, book}
    end)
  end
end
