defmodule Student.PassController do
  use Student.Web, :controller

  alias Student.Pass

  def index(conn, _params) do
    passes = Repo.all(Pass)
    render(conn, "index.html", passes: passes)
  end

end
