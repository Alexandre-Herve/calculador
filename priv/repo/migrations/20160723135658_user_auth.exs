defmodule Calculador.Repo.Migrations.UserAuth do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email, :string
      add :crypted_password, :string
    end
  end
end
