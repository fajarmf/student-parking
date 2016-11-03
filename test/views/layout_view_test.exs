defmodule Student.LayoutViewTest do
  use Student.ConnCase, async: true
  alias Student.LayoutView
  alias Student.User
  setup do
    User.changeset(%User{}, %{name: "test", password: "test", password_confirmation: "test", email: "test@test.com"})
    |> Repo.insert
    {:ok, conn: build_conn()}
  end
  test "current user returns the user in the session", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: %{email: "test@test.com", password: "test"}
    assert LayoutView.current_user(conn)
  end
  test "current user returns nothing if there is no user in the session", %{conn: conn} do
    user = Repo.get_by(User, %{email: "test@test.com"})
    conn = delete conn, session_path(conn, :delete, user)
    refute LayoutView.current_user(conn)
  end
end