defmodule Student.Router do
  use Student.Web, :router

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

  scope "/", Student do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/cart", CartController, singleton: true, except: [:new, :edit, :create]
    resources "/passes", PassController, only: [:index]
  end

  scope "/admin", Student.Admin do
    pipe_through :browser
    resources "/users", UserController
    resources "/passes", PassController, as: :admin_pass
    resources "/carts", CartController, as: :admin_cart
  end

  # Other scopes may use custom stacks.
  # scope "/api", Student do
  #   pipe_through :api
  # end
end
