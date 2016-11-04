defmodule Student.Repo.Migrations.CreatePass do
  use Ecto.Migration

  def change do
    create table(:passes) do
      add :type, :string
      add :price, :float

      timestamps()
    end

  end
end
