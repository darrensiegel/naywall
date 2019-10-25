defmodule Ladder.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :article_id, :string
      add :title, :string
      add :body, :string
      add :author, :string
      add :article, :map

      timestamps()
    end

  end
end
