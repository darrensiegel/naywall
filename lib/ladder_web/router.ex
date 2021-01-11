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

    get "/", PageController, :root
    get "/pg", PageController, :index
    get "/pg/sports", PageController, :sports
    get "/pg/article", PageController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", LadderWeb do
  #   pipe_through :api
  # end
end
