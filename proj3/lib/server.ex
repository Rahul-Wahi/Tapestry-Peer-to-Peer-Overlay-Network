defmodule Tapestry  do 
use GenServer

def start_link(n) do
   GenServer.start_link(__MODULE__, %{routing_table: [],nodeid: "",objectids: []},name: String.to_atom(Integer.to_string(n)) )
  
end

def init(state) do
  {:ok, state}
end

def get(pid) do  
  GenServer.call(pid, :get, :infinity)
end

def set(pid) do  
  GenServer.call(pid, :set, :infinity)
end

def set_state(pid, nodeid, routing_table) do  
  GenServer.cast(pid, {:set_state,routing_table,nodeid})
end


def set_objectds(pid , objectids) do  
  GenServer.cast(pid, {:set_state,objectids})
end

#to add neighbours to the existing list
def handle_cast({:set_state,routing_table_value,node_id} ,%{routing_table: _list, nodeid: _} = state) do

  
  {:noreply,%{state | routing_table: routing_table_value , nodeid: node_id }  }
  
end

#to add neighbours to the existing list
def handle_cast({:set_objectds, new_objectid_list} ,%{objectids: objectid_list} = state) do

  
  {:noreply,%{state | objectids: objectid_list ++ new_objectid_list}  }
  
end


def handle_call(:get, _from, state) do
  {:reply,state, state , 100000}
end

def handle_call(:set, _from, state) do
  {:reply,state, [] , 100000}
end




  
  end