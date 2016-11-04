defmodule Student.Cart do
  use Student.Web, :model

  schema "cart" do
    field :total, :float
    field :items, {:array, :map}
    belongs_to :user, Student.User

    timestamps()

    field :new_item_type, :string, virtual: true
    field :new_item_quantity, :float, virtual: true
    field :new_item_price, :float, virtual: true

  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :new_item_price, :new_item_quantity, :new_item_type])
    |> validate_required([:new_item_price, :new_item_quantity, :new_item_type])
    |> unique_constraint(:user_id)
    |> build_items
    |> calculate_total
  end

  defp build_items(changeset) do
    price = get_change(changeset, :new_item_price)
    quantity = get_change(changeset, :new_item_quantity)
    type = get_change(changeset, :new_item_type)
    if not is_nil(price) and not is_nil(quantity) and not is_nil(type) do
      new_items = (changeset.data.items || []) ++ [
        %{
          "price" => price,
          "quantity" => quantity,
          "type" => type
        }]
      changeset
      |> put_change(:items, new_items)
    else
      changeset
    end
  end

  defp calculate_total(changeset) do
    if items = get_change(changeset, :items) do
      require IEx
      IEx.pry
      {_, total} = Enum.flat_map_reduce(items, 0.0, fn (i, acc) -> {i, acc + i["price"] * i["quantity"]} end)
      changeset
      |> put_change(:total, total)
    else
      changeset
    end
  end
end
