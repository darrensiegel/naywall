defmodule Ladder.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    field :article_id, :string
    field :author, :string
    field :body, :string
    field :title, :string
    field :article, :map

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:article_id, :title, :author, :body, :article])
    |> validate_required([:article_id, :title, :author, :body, :article])
  end
end
