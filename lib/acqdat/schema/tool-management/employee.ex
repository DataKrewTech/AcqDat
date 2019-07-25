defmodule Acqdat.Schema.ToolManagement.Employee do
  @moduledoc """
  Models an Employee in tool-management.
  """

  use Acqdat.Schema
  @emp_prefix "U"

  @typedoc """
  `name`: name of the employee.
  `phone`: phone number of the employee.
  `address`: employee address
  `uuid`: unique id assigned to the employee.
  `role`: role of the employee in factory.
  """
  @type t :: %__MODULE__{}

  schema("acqdat_tm_employees") do
    field(:name, :string)
    field(:phone_number, :string)
    field(:address, :string)
    field(:uuid, :string)
    field(:role, :string)

    timestamps()
  end

  @required_fields ~w(name phone_number uuid role)a
  @optional_fields ~w(address)a

  @permitted @required_fields ++ @optional_fields

  @spec create_changeset(__MODULE__.t(), map) :: Ecto.Changeset.t()
  def create_changeset(%__MODULE__{} = employee, params) do
    employee
    |> cast(params, @permitted)
    |> add_uuid()
    |> common_changeset()
  end

  @spec update_changeset(__MODULE__.t(), map) :: Ecto.Changeset.t()
  def update_changeset(%__MODULE__{} = employee, params) do
    employee
    |> cast(params, @permitted)
    |> common_changeset()
  end

  defp common_changeset(changeset) do
    changeset
    |> validate_required(@required_fields)
    |> validate_length(:phone_number, max: 10, min: 5)
    |> unique_constraint(:name, name: :acqdat_tm_employees_name_phone_number_index,
      message: "User already exists!")
  end

  defp add_uuid(%Ecto.Changeset{valid?: true} = changeset) do
    uuid = @emp_prefix <> permalink(4)
    changeset
    |> put_change(:uuid, uuid)
  end
  defp add_uuid(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  #TODO: Look for a possible way to check using ExPhoneNumber if the
  #      number is valid.
  # defp validate_number(%Ecto.Changeset{valid?: true} = changeset) do
  # end
  # defp validate_number(%Ecto.Changeset{valid?: false} = changeset), do: false

end
