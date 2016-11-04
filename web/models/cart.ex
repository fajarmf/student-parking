defmodule Student.Cart do
  use Student.Web, :model

  schema "cart" do
    field :total, :float
    field :items, {:array, :map}
    belongs_to :user, Student.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:items, :user_id, :total])
    |> calculate_total
  end

  defp calculate_total(changeset) do
    if items = get_change(changeset, :items) do
      {_, total} = Enum.flat_map_reduce(items, 0.0, fn (i, acc) -> {i, acc + String.to_float(i["price"]) * String.to_integer(i["quantity"])} end)
      changeset
      |> put_change(:total, total)
    else
      changeset
    end
  end
end
