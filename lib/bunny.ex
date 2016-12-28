###========================================================================
### File: bunny.ex
###
###
### Author(s):
###   - Enrique Fernandez <efcasado@gmail.com>
###
### Copyright (c) 2016, Enrique Fernandez
###========================================================================
defmodule Bunny do
  ##== Preamble ===========================================================
  use Application


  ##== API ================================================================
  def start(_type, _args) do
    Bunny.Supervisor.start_link
  end

  def stop(_state) do
    Bunny.Supervisor.stop
  end

end
