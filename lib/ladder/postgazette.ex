defmodule Ladder.PostGazette do

  alias Ladder.Article

  def article(content) when is_map(content) do
    %Article{
      article_id: Map.get(content, "storyID"),
      title: Map.get(content, "title"),
      author: Map.get(content, "author"),
      body: Map.get(content, "body"),
      article: content
    }
  end

  def article(content) do
    content
    |> line_to_map("pgStoryZeroJSON = ")
    |> Map.get("articles")
    |> hd
    |> article
  end

  defp substr(s, index) do
    String.slice(s, index, String.length(s) - index - 1)
  end

  defp line_to_map(content, prefix) do
    String.split(content, "\n")
    |> Enum.filter(fn s -> String.starts_with?(s, prefix) end)
    |> hd
    |> String.trim
    |> substr(String.length(prefix))
    |> Poison.decode!
  end

  def per_category(category, articles) do
    a = articles
    |> Map.get(category)
    |> Map.get("articles")

    case a do
      nil -> []
      _ -> Enum.map(a, &article/1)
    end

  end

  def categories(articles) do
    articles |> Map.keys()
  end

  def articles(content) do
    content
    |> line_to_map("PGPAGEDATA = ")
  end

  def sports_articles(content) do
    content
    |> line_to_map("PGPAGEDATA = ")
  end

end
