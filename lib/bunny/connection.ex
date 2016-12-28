###========================================================================
### File: connection.ex
###
###
### Author(s):
###   - Enrique Fernandez <efcasado@gmail.com>
###
### Copyright (c) 2016, Enrique Fernandez
###========================================================================
defmodule Bunny.Connection do
  ##== Preamble ===========================================================
  use GenServer

  defstruct options: [], pid: nil, ref: nil


  ##== API ================================================================
  def open(name, options \\ []) do
    Bunny.Supervisor.start_connection(name, options)
  end

  def start_link(name, options \\ []) do
    GenServer.start_link(__MODULE__, [], name: name)
  end


  ##== GenServer callbacks ================================================
  def init(options) do
    {:ok, pid} = connect(options)
    Process.link(pid)
    ref = :erlang.monitor(:process, pid)
    {:ok, %Bunny.Connection{pid: pid, ref: ref}}
  end

  def handle_call(:channel, _from, state = %Bunny.Connection{pid: pid}) do
    res = channel(pid)
    {:reply, res, state}
  end

  def handle_info({:DOWN, ref, _, _, _}, state = %Bunny.Connection{ref: ref}) do
    Process.send_after(self(), :reconnect, 5000)
    {:noreply, state}
  end
  def handle_info(:reconnect, state = %Bunny.Connection{options: options}) do
    IO.puts "Attempting to reconnect"
    {:ok, pid} = connect(options)
    ref = :erlang.monitor(:process, pid)
    state = %{state | pid: pid, ref: ref}
    {:noreply, state}
  end
  def handle_info(_, state) do
    {:noreply, state}
  end


  ##== Auxiliary functions ================================================
  defp connect(options) do
    case AMQP.Connection.open(options) do
      {:ok, %AMQP.Connection{pid: pid}} ->
        {:ok, pid}
      {:error, _reason} ->
        {:ok, nil}
    end
  end

  defp channel(pid) do
    parent = self
    ref = :erlang.make_ref
    pid = spawn(
      fn ->
        case :amqp_connection.open_channel(pid) do
          {:ok, pid}        -> send(parent, {ref, {:ok, pid}})
          {:error, _reason} -> send(parent, {ref, {:ok, nil}})
        end
      end)
    receive do
      {^ref, res} -> res
    after
      1000 -> {:ok, nil}
    end
  end

end
