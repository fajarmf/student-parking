defmodule Student.PassTest do
  use Student.ModelCase

  alias Student.Pass

  @valid_attrs %{price: "120.5", type: "bike"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Pass.changeset(%Pass{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Pass.changeset(%Pass{}, @invalid_attrs)
    refute changeset.valid?
  end
end
