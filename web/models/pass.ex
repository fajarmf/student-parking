defmodule Student.Pass do
  use Student.Web, :model

  schema "passes" do
    field :type, :string
    field :price, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type, :price])
    |> validate_required([:type, :price])
  end
end
