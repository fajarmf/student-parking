defmodule Student.Repo.Migrations.CreateCart do
  use Ecto.Migration

  def change do
    create table(:cart) do
      add :total, :float
      add :items, {:array, :map}
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:cart, [:user_id])

  end
end
