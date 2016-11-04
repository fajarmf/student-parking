defmodule Student.PassController do
  use Student.Web, :controller

  alias Student.{Cart, Pass}

  def index(conn, _params) do
    passes = Repo.all(Pass)
    render(conn, "index.html", passes: passes, changeset: Cart.changeset(%Cart{}), action: cart_path(conn, :update))
  end

end
