defmodule Student.UserTest do
  use Student.ModelCase

  alias Student.User

  @valid_attrs %{email: "test@test.com", name: "student a", password: "test123", password_confirmation: "test123"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?, (inspect changeset) <> "  " <> (inspect @valid_attrs)
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "password_digest value gets set to a hash" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert Comeonin.Bcrypt.checkpw(@valid_attrs.password, get_change(changeset, :password_digest))
  end

  test "password_digest value does not get set if password is nil" do
    changeset = User.changeset(%User{}, %{email: "test@test.com", password: nil, password_confirmation: nil, name: "student b"})
    refute get_change(changeset, :password_digest)
  end
end
