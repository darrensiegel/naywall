defmodule LadderWeb.PageController do
  use LadderWeb, :controller

  alias Ladder.PostGazette
  alias Ladder.Article

  def index(conn, _params) do
    articles =
      case HTTPoison.get("https://www.post-gazette.com") do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> PostGazette.articles(body)
        _ -> []
      end

    categories =
      PostGazette.categories(articles)
      |> Enum.map(fn c -> {c, PostGazette.per_category(c, articles)} end)

    featured = Enum.filter(categories, fn {c, _} -> c == "atf-featured" end) |> hd
    trending = Enum.filter(categories, fn {c, _} -> c == "trending" end) |> hd
    mustread = Enum.filter(categories, fn {c, _} -> c == "mustread" end) |> hd
    breaking = Enum.filter(categories, fn {c, _} -> c == "breaking" end) |> hd

    render(conn, "index.html",
      featured: featured,
      trending: trending,
      mustread: mustread,
      breaking: breaking
    )
  end

  def root(conn, _params) do
    render(conn, "root.html")
  end

  def show(conn, _parms) do
    article =
      case conn.query_params do
        %{"link" => link} ->
          case HTTPoison.get(link) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> PostGazette.article(body)
            _ -> %Article{}
          end

        _ ->
          %Article{}
      end

    render(conn, "show.html", article: article)
  end
end
