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

  def sports(conn, _params) do
    headers = ["Accept": "Application/json; Charset=utf-8"]
    options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
    articles =
      case HTTPoison.get("https://api2.post-gazette.com/page/2/sports/", headers, options) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          IO.inspect(body)
          PostGazette.sports_articles(body)
        e ->
          IO.inspect(e)
        []
      end

    featured = Map.get(articles, "featuredpack") |> Map.get("articles")
    trending = Map.get(articles, "recent") |> Map.get("articles")

    IO.inspect featured
    IO.inspect trending


    render(conn, "sports.html",
      featured: featured,
      trending: trending
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
