defmodule Student.Admin.CartControllerTest do
  use Student.ConnCase

  alias Student.{Cart, User}
  @valid_attrs %{new_item_price: 1.4, new_item_type: "bike", new_item_quantity: 2}
  @valid_user_attrs %{email: "test@test.com", name: "student a", password: "test123", password_confirmation: "test123"}
  @invalid_attrs %{}

  setup do
    user_changeset = User.changeset(%User{}, @valid_user_attrs)
    user = Repo.insert! user_changeset
    {:ok, conn: build_conn, user: user}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, admin_cart_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing cart"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, admin_cart_path(conn, :new)
    assert html_response(conn, 200) =~ "New cart"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, user: user} do
    conn = post conn, admin_cart_path(conn, :create), cart: (@valid_attrs |> Map.put(:user_id, user.id))
    assert redirected_to(conn) == admin_cart_path(conn, :index)
    assert Repo.get_by(Cart, %{user_id: user.id})
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

  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
    cart = Repo.insert! %Cart{}
    conn = put conn, admin_cart_path(conn, :update, cart), cart: (@valid_attrs |> Map.put(:user_id, user.id))
    assert redirected_to(conn) == admin_cart_path(conn, :show, cart)
    assert Repo.get_by(Cart, %{user_id: user.id})
  end

  test "deletes chosen resource", %{conn: conn} do
    cart = Repo.insert! %Cart{}
    conn = delete conn, admin_cart_path(conn, :delete, cart)
    assert redirected_to(conn) == admin_cart_path(conn, :index)
    refute Repo.get(Cart, cart.id)
  end
end
