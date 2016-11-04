defmodule Student.CartControllerTest do
  use Student.ConnCase

  alias Student.{Cart, Pass, User}
  @valid_attrs %{items: [], total: "120.5"}
  @valid_user_attrs %{email: "test@test.com", name: "student a", password: "test123", password_confirmation: "test123"}
  @valid_pass_attrs %{type: "bike", price: 12.3}
  @invalid_attrs %{}

  setup do
    pass_changeset = Pass.changeset(%Pass{}, @valid_pass_attrs)
    pass = Repo.insert! pass_changeset
    user_changeset = User.changeset(%User{}, @valid_user_attrs)
    user = Repo.insert! user_changeset
    conn = build_conn() |> login_user(user)
    {:ok, conn: conn, user: user, item: pass}
  end

  defp login_user(conn, user) do
    post conn, session_path(conn, :create), user: %{email: user.email, password: user.password}
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    cart = Repo.insert! %Cart{user_id: user.id}
    conn = get conn, cart_path(conn, :show)
    assert html_response(conn, 200) =~ "Show cart"
    assert html_response(conn, 200) =~ "<strong>User ID:</strong>\n#{cart.user_id}"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user, item: item} do
    Repo.insert! %Cart{user_id: user.id}
    conn = put conn, cart_path(conn, :update), cart: %{pass_id: item.id}
    assert redirected_to(conn) == cart_path(conn, :show)
    assert Repo.get_by(Cart, %{user_id: user.id})
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    Repo.insert! %Cart{user_id: user.id}
    conn = put conn, cart_path(conn, :update), cart: @invalid_attrs
    assert redirected_to(conn) == cart_path(conn, :show)
  end

  test "deletes chosen resource", %{conn: conn, user: user} do
    cart = Repo.insert! %Cart{user_id: user.id}
    conn = delete conn, cart_path(conn, :delete)
    assert redirected_to(conn) == page_path(conn, :index)
    refute Repo.get(Cart, cart.id)
  end
end
