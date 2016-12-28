###========================================================================
### File: channel.ex
###
###
### Author(s):
###   - Enrique Fernandez <efcasado@gmail.com>
###
### Copyright (c) 2016, Enrique Fernandez
###========================================================================
defmodule Bunny.Channel do
  ##== Preamble ===========================================================
  use GenServer

  defstruct [
    conn: nil, # Connection this channel belongs to
    pid: nil,  # PID of the RMQ channel
    ref1: nil, # Reference used to monitor the RMQ channel
    ref2: nil  # Reference used to monitor the owner of the channel
  ]


  ##== API ================================================================
  def open(name, connection) do
    Bunny.Supervisor.start_channel(name, connection, self)
  end

  def close(channel) do
  end

  def start_link(name, connection, owner) do
    args = [connection, owner]
    GenServer.start_link(__MODULE__, args, name: name)
  end


  ##== GenServer callbacks ================================================
  def init([connection, owner]) do
    {:ok, pid} = GenServer.call(connection, :channel)
    ref1 = :erlang.monitor(:process, pid)
    ref2 = :erlang.monitor(:process, owner)
    {:ok, %Bunny.Channel{conn: connection, pid: pid, ref1: ref1, ref2: ref2}}
  end

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  # The owner of the channel went down
  def handle_info({:DOWN, ref, _, _, _}, state = %Bunny.Channel{ref2: ref}) do
    {:stop, :normal, state}
  end
  # The RMQ channel went down
  def handle_info({:DOWN, ref, _, _, _}, state = %Bunny.Channel{ref1: ref}) do
    Process.send_after(self(), :recreate, 5000)
    {:noreply, state}
  end
  def handle_info(:recreate, state = %Bunny.Channel{conn: conn}) do
    IO.puts "Attempting to recreate"
    {:ok, pid} = GenServer.call(conn, :channel)
    ref = :erlang.monitor(:process, pid)
    state = %{state | pid: pid, ref1: ref}
    {:noreply, state}
  end


  ##== Auxiliary functions ================================================
  def call(pid, method, content \\ :none) do
    :amqp_channel.call(pid, method, content)
  end

  def cast(pid, method, content \\ :none) do
    :amqp_channel.cast(pid, method, content)
  end

end

