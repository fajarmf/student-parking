defmodule Student.CartTest do
  use Student.ModelCase

  alias Student.Cart

  @valid_attrs %{new_item_type: "bike", new_item_quantity: 3, new_item_price: 1.2}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Cart.changeset(%Cart{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset calculate total based on items price and quantity" do
    changeset = Cart.changeset(%Cart{}, @valid_attrs)
    assert changeset.valid?
    assert Float.round(get_change(changeset, :total), 1) == 3.6
  end
end
