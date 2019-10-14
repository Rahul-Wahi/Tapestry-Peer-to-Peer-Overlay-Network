defmodule MySupervisor do
  @moduledoc """
  This module acts as the supervisor. It creates the children and assigns them to the supervisor.
  """
  use Supervisor

  def start_link(init_arg) do 
    Supervisor.start_link(__MODULE__,init_arg)
  end

  def init([arg1]) do
    
    children = Enum.map(1..arg1, fn(n) ->

     
        worker(Tapestry, [n], [id: n, restart: :transient, shutdown: :infinity])
      

    end)

    #children = children ++ [worker(NodeInfo , [] , [id: NodeInfo, restart: :transient, shutdown: :infinity])]

    supervise(children, strategy: :one_for_one)
  
  end

end