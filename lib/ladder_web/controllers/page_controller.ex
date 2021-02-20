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


  defp section(body, name) do
    case Map.get(body, name) do
      nil -> []
      section -> case Map.get(section, "articles") do
        nil -> []
        articles -> articles
      end
    end
  end

  def home(conn, _params) do
    render_section(conn, "Home", "home")
  end

  def news(conn, _params) do
    render_section(conn, "News", "news")
  end

  def local(conn, _params) do
    render_section(conn, "Local", "local")
  end

  def sports(conn, _params) do
    render_section(conn, "Life", "life")
  end

  def opinion(conn, _params) do
    render_section(conn, "Opinion", "opinion")
  end

  def ae(conn, _params) do
    render_section(conn, "Arts and Entertainment", "ae")
  end

  def life(conn, _params) do
    render_section(conn, "Life", "life")
  end

  def business(conn, _params) do
    render_section(conn, "Business", "business")
  end


  defp render_section(conn, title, url) do

    headers = ["Accept": "Application/json; Charset=utf-8"]
    options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
    articles =
      case HTTPoison.get("https://api2.post-gazette.com/page/2/#{url}/", headers, options) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->

          Poison.decode!(body)
        e ->
          IO.inspect(e)
        []
      end

    render(conn, "section.html",
      title: title,
      featured: section(articles, "featuredpack"),
      trending: section(articles, "trending"),
      recent: section(articles, "recent")
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
