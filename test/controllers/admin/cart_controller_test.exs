defmodule Student.Admin.CartControllerTest do
  use Student.ConnCase

  alias Student.Cart
  @valid_attrs %{items: [], total: "0.0"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, admin_cart_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing cart"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, admin_cart_path(conn, :new)
    assert html_response(conn, 200) =~ "New cart"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, admin_cart_path(conn, :create), cart: @valid_attrs
    assert redirected_to(conn) == admin_cart_path(conn, :index)
    assert Repo.get_by(Cart, @valid_attrs)
  end

  test "shows chosen resource", %{conn: conn} do
    cart = Repo.insert! %Cart{}
    conn = get conn, admin_cart_path(conn, :show, cart)
    assert html_response(conn, 200) =~ "Show cart"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, admin_cart_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    cart = Repo.insert! %Cart{}
    conn = get conn, admin_cart_path(conn, :edit, cart)
    assert html_response(conn, 200) =~ "Edit cart"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    cart = Repo.insert! %Cart{}
    conn = put conn, admin_cart_path(conn, :update, cart), cart: @valid_attrs
    assert redirected_to(conn) == admin_cart_path(conn, :show, cart)
    assert Repo.get_by(Cart, @valid_attrs)
  end

  test "deletes chosen resource", %{conn: conn} do
    cart = Repo.insert! %Cart{}
    conn = delete conn, admin_cart_path(conn, :delete, cart)
    assert redirected_to(conn) == admin_cart_path(conn, :index)
    refute Repo.get(Cart, cart.id)
  end
end
