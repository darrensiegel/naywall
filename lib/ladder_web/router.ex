defmodule LadderWeb.Router do
  use LadderWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LadderWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/pg", PageController, :index

    get "/pg/home", PageController, :home
    get "/pg/news", PageController, :news
    get "/pg/local", PageController, :local
    get "/pg/sports", PageController, :sports
    get "/pg/opinion", PageController, :opinion
    get "/pg/ae", PageController, :ae
    get "/pg/life", PageController, :life
    get "/pg/business", PageController, :business

    get "/pg/article", PageController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", LadderWeb do
  #   pipe_through :api
  # end
end
