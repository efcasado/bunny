###========================================================================
### File: supervisor.ex
###
###
### Author(s):
###   - Enrique Fernandez <efcasado@gmail.com>
###
### Copyright (c) 2016, Enrique Fernandez
###========================================================================
defmodule Bunny.Supervisor do
  ##== Preamble ===========================================================
  use Supervisor


  ##== API ================================================================
  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_args) do
    children = []
    supervise(children, strategy: :one_for_one)
  end

  def start_connection(name, options \\ []) do
    args = [name, options]
    Supervisor.start_child(__MODULE__, worker(Bunny.Connection, args, id: name))
  end

  def start_channel(name, connection, owner) do
    args = [name, connection, owner]
    Supervisor.start_child(__MODULE__, worker(Bunny.Channel, args, id: name))
  end

end
