defmodule Student.CartController do
  use Student.Web, :controller

  alias Student.Cart
  alias Plug.Conn

  plug :authorize_user

  def create(conn, %{"cart" => cart_params}) do
    current_user = Conn.get_session(conn, :current_user)
    changeset = Cart.changeset(%Cart{}, cart_params |> Map.put("user_id", current_user.id))

    case Repo.insert(changeset) do
      {:ok, cart} ->
        conn
        |> put_flash(:info, "Cart created successfully.")
        |> redirect(to: cart_path(conn, :show))
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Cart failed to be created.")
        |> redirect(to: cart_path(conn, :show))
    end
  end

  def show(conn, _params) do
    current_user = Conn.get_session(conn, :current_user)
    cart = Repo.get_by(Cart, %{user_id: current_user.id}) || %Cart{user_id: current_user.id}
    render(conn, "show.html", cart: cart)
  end

  def update(conn, %{"cart" => cart_params}) do
    current_user = Conn.get_session(conn, :current_user)
    cart = Repo.get_by!(Cart, %{user_id: current_user.id})
    changeset = Cart.changeset(cart, cart_params |> Map.put("user_id", current_user.id))

    case Repo.update(changeset) do
      {:ok, _cart} ->
        conn
        |> put_flash(:info, "Cart updated successfully.")
        |> redirect(to: cart_path(conn, :show))
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Cart failed to update.")
        |> redirect(to: cart_path(conn, :show))
    end
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
