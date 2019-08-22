defmodule SaffronWeb.Router do
  use SaffronWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {SaffronWeb.LayoutView, :app}
  end

  scope "/", SaffronWeb do
    pipe_through :browser
    get "/", PageController, :index
  end
end
