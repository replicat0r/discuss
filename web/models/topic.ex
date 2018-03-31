defmodule Discuss.Topic do
  use Discuss.Web, :model
  #model requires 2 things,
  #schema file to tell phoenix how to to interact with the
  #the database
  schema "topics" do
    field :title, :string
  end

  def changeset(struct, params \\%{} ) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
