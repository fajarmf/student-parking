defmodule Student.CartController do
  use Student.Web, :controller

  alias Student.{Cart, Pass}
  alias Plug.Conn

  plug :authorize_user

  def show(conn, _params) do
    current_user = Conn.get_session(conn, :current_user)
    cart = Repo.get_by(Cart, %{user_id: current_user.id}) || %Cart{user_id: current_user.id}
    render(conn, "show.html", cart: cart)
  end

  def update(conn, %{"cart" => %{"pass_id" => pass_id} = cart_params}) do
    current_user = Conn.get_session(conn, :current_user)
    cart = Repo.get_by(Cart, %{user_id: current_user.id}) || %Cart{}

    full_params = populate_cart(cart_params, current_user.id, pass_id)
    changeset = Cart.changeset(cart, full_params)

    case upsert(changeset) do
      {:ok, _cart} ->
        conn
        |> put_flash(:info, "Cart updated successfully.")
        |> redirect(to: cart_path(conn, :show))
      {:error, _changeset} ->
        conn
        |> put_flash(:info, "Cart failed to update.")
        |> redirect(to: cart_path(conn, :show))
    end
  end

  def update(conn, _) do
    conn
    |> put_flash(:info, "Missing item.")
    |> redirect(to: cart_path(conn, :show))
  end

  def delete(conn, _params) do
    current_user = Conn.get_session(conn, :current_user)
    cart = Repo.get_by!(Cart, %{user_id: current_user.id})

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(cart)

    conn
    |> put_flash(:info, "Cart deleted successfully.")
    |> redirect(to: page_path(conn, :index))
  end

  defp populate_cart(params, user_id, pass_id) do
    new_item = Repo.get!(Pass, pass_id)
    params
    |> Map.put("user_id", user_id)
    |> Map.put("new_item_type", new_item.type)
    |> Map.put("new_item_quantity", "1")
    |> Map.put("new_item_price", new_item.price)
  end

  defp upsert(changeset) do
    if is_nil changeset.data.id do
      Repo.insert(changeset)
    else
      Repo.update(changeset)
    end
  end

  defp authorize_user(conn, _opts) do
    if get_session(conn, :current_user) do
      conn
    else
      conn
      |> put_flash(:error, "You need to login to access your cart")
      |> redirect(to: page_path(conn, :index))
      |> halt
    end
  end
end
