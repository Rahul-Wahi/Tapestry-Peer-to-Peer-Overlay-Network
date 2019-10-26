defmodule Tapestry  do 
use GenServer

def start_link(n) do
   GenServer.start_link(__MODULE__, %{routing_table: [],nodeid: "", objectpointers: %{}},name: String.to_atom(n) )
  
  # get_in(users, ["john", :age])
  # put_in(users.obj["2344"],["a"])

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

def send_to_nodes(pid , numNodes, numRequests) do
  
  repair_network(pid)
  Enum.each(1..numRequests, fn _n -> 
    route_to_node( pid , Generic.generate_id(Integer.to_string(Enum.random(1..numNodes) )), 0 )
  end
    )
end

def route_to_node(pid, destination_nodeid, hop_count \\ 0) do
  
  GenServer.cast(pid, {:route_to_node,destination_nodeid , hop_count})
end
#serverid is the nodeid of node where the node is actually stored
def publish_object(pid , objectid, serverid) do  
  GenServer.cast(pid, {:publish_object,objectid, serverid})
end

def kill(pid) do
  GenServer.call(pid, :kill, :infinity)
end


def repair_network(pid) do
  GenServer.call(pid, :repair_network, :infinity)
end

#to add neighbours to the existing list
def handle_cast({:route_to_node,destination_nodeid, hop_count} ,%{routing_table: routing_list, nodeid: node_id } = state) do
  
  level = find_level(destination_nodeid,node_id)
  if level == 1 do
    IO.puts "route_to_node1"
    nodeids = Enum.at(routing_list,0) #search in level1
    {destination_nodeid_digit,_}  = Integer.parse(String.at(destination_nodeid, 0) , 16)
    matched_node = find_closest_digit_node(destination_nodeid_digit,nodeids, 0 , 0)
    #matched_node = Enum.filter(nodeids, fn nodeid -> String.starts_with?(nodeid, String.at(destination_nodeid, 0)) end) 
    matched_node = matched_node ++ [node_id]
    pid = Process.whereis(String.to_existing_atom((Enum.at(matched_node,0)) ))
   
    GenServer.cast(pid, {:next_hop,1,destination_nodeid, hop_count + 1})
  
    
  else
    nodeids = Enum.at(routing_list,1) #search in level2, if common
    {destination_nodeid_digit,_}  = Integer.parse(String.at(destination_nodeid, 0) , 16)
    matched_node = find_closest_digit_node(destination_nodeid_digit,nodeids, 0 , 0)
    matched_node = matched_node ++ [node_id]
    #matched_node = Enum.filter(nodeids, fn nodeid -> String.starts_with?(nodeid, String.at(destination_nodeid, 0)) end) 
    pid = Process.whereis(String.to_existing_atom((Enum.at(matched_node,0)) ))
    
    GenServer.cast(pid, {:next_hop,1,destination_nodeid, hop_count + 1})
    
  end 
  {:noreply, state }
  
end

#to add neighbours to the existing list
def handle_cast({:set_state,routing_table_value,node_id} ,%{routing_table: _list, nodeid: _} = state) do

  
  {:noreply,%{state | routing_table: routing_table_value , nodeid: node_id }  }
  
end

#to add neighbours to the existing list
def handle_cast({:set_objectds, new_objectid_list} ,%{objectids: objectid_list} = state) do

  
  {:noreply,%{state | objectids: objectid_list ++ new_objectid_list}  }
  
end

#function to find the next hop and send message to continue the process
#n : previous hop number, destination_node: node to be reached 
def handle_cast({:next_hop, n, destination_nodeid, hop_count} ,%{routing_table: routing_list, nodeid: node_id} = state) do

  #IO.puts "next_hop #{destination_nodeid} #{node_id} "
  nodeids = Enum.at(routing_list,n) 
  if node_id != destination_nodeid && n < 40 && length(nodeids) > 0 do
    #search in level n+1 for finding the next hop
    IO.puts "inside please finish"
    #find node matching with prefix upto n+1 lenght, as we have to match n+1th charater
    #matched_node = Enum.filter(nodeids, fn nodeid -> String.starts_with?(nodeid, String.slice(destination_nodeid, 0..n)) end) 
    {destination_nodeid_digit,_}  = Integer.parse(String.at(destination_nodeid, 0) , 16)
    matched_node = find_closest_digit_node(destination_nodeid_digit,nodeids, n , 0)
    #matched_node = Enum.filter(nodeids, fn nodeid -> String.starts_with?(nodeid, String.at(destination_nodeid, 0)) end) 
    matched_node = matched_node ++ [node_id]
    pid = Process.whereis(String.to_existing_atom((Enum.at(matched_node,0)) ))
    IO.puts node_id
    IO.puts "hahaha"
    GenServer.cast(pid, {:next_hop,n+1,destination_nodeid , hop_count + 1})
    {:noreply,state }
  else
    IO.puts "Node done"
    NodeInfo.done( hop_count + 1 )
    {:noreply,state }
  end

end
#to add neighbours to the existing list
#def handle_cast({:publish_object,objectid, serverid} ,%{objectids: objectid_list} = state) do

  
 # {:noreply,%{state | objectids: objectid_list ++ objectid}  }
  
#end


def handle_call(:get, _from, state) do
  {:reply,state, state , 100000}
end

def handle_call(:set, _from, state) do
  {:reply,state, [] , 100000}
end

def handle_call(:kill, _from, state) do
  {:stop,:normal, state , 100000}
end

def handle_call(:repair_network, _from, %{routing_table: routing_list} = state) do
  
  Enum.map(routing_list, fn level_list ->  filter_nodeids(level_list) end )
  {:reply,state, state , 100000}
end

#to remove nodeids which are dead or nill
defp filter_nodeids(list) do
  
  Enum.filter(list, fn x -> Process.whereis(String.to_atom( x)) != nil end)
end

#find level for searching the next hop
defp find_level(objectid,nodeid) do
  
  index = Enum.find_index(0..String.length(objectid), fn i -> String.at(objectid,i) != String.at(nodeid,i) end)
  #IO.puts "Index #{index}"
  if objectid == nodeid do
    40
  else
    index+1
  end
  

end

defp find_closest_digit_node(objectid_digit,nodeids, position , count ) when count >= 16 do
  
  #node_digit  = Integer.parse(String.at(nodeid, position) , 16) #hex digit string to integer decima
  object_digithex =  Integer.to_string(objectid_digit, 16) #decimal to hex string
  Enum.filter(nodeids, fn nodeid -> String.at(nodeid, position) == object_digithex end) 
  
end

defp find_closest_digit_node(objectid_digit,nodeids, position , count ) do
  
  #node_digit  = Integer.parse(String.at(nodeid, position) , 16) #hex digit string to integer decima
  object_digithex =  Integer.to_string(objectid_digit, 16) #decimal to hex string
  matched_node = Enum.filter(nodeids, fn nodeid -> String.at(nodeid, position) == object_digithex end) 
  
  if length(matched_node) == 0 do
    objectid_digit  =  objectid_digit + 1
    if objectid_digit >= 16 do
      find_closest_digit_node(0,nodeids, position , count + 1)
    else
      find_closest_digit_node(objectid_digit,nodeids, position , count + 1)
    end
    
  else
    matched_node
  end
  

end


  
  end