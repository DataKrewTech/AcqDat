defmodule Acqdat.Schema.SensorType do
  @moduledoc """
  Models a sensor type for the different sensors
  used in the system.
  """

  # The sensor types would be taken for every device request, it's better
  # to keep these in a cache for fast response.

  use Acqdat.Schema

  @typedoc """
  `name`: Name of the sensor type, could be temperature, humidity etc.
  `make`: Make of the sensor can be used to contain information related
          to manufacturer, model etc.
  `visualizer`: chart type that should be used to visualize the sensor
                in the live view.
  'identifier': A unique identifier for the sensor type. For example A
                temperature sensor can be itself different for differnt types.
                Identifier uniquely identifies the sensor. This identifier would
                be used by devices sending data for different types of sensors.
  """
  @type t :: %__MODULE__{}

  schema("acqdat_sensor_types") do
    field(:name, :string)
    field(:make, :string)
    field(:visualizer, :string)
    field(:identifier, :string)

    timestamps()
  end

  @required_params ~w(name identifier)a
  @optional_parmas ~w(make visualizer)a

  @permitted @required_params ++ @optional_parmas

  @spec changeset(__MODULE__.t(), map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = sensor_type, params) do
    sensor_type
    |> cast(params, @permitted)
    |> validate_required(@required_params)
    |> unique_constraint(:name)
    |> unique_constraint(:identifier)
  end

end
