defmodule Plustwo.Application.Router do
  use Plustwo.Application, :router

  pipeline :api do
    nil
  end
  # plug :accepts, ["json"]
  scope "/" do
    pipe_through :api
    get "/graphiql", Absinthe.Plug.GraphiQL, schema: Plustwo.Application.Schema
    post "/graphiql", Absinthe.Plug.GraphiQL, schema: Plustwo.Application.Schema
    forward "/graphql", Absinthe.Plug, schema: Plustwo.Application.Schema
  end
end
