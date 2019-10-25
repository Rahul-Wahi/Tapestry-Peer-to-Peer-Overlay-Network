defmodule Proj3.Tapestry do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  #use Application
  #use Topologies
  import Supervisor, warn: false
  def main(args \\ []) do
    
    
    {_ ,[noOfNodes, numRequests ],_} = OptionParser.parse(args ,  strict: [n: :integer, n: :integer])
    #case OptionParser.parse(System.argv() ,  strict: [n: :integer, k: String, o: String]) do
  
      #{_ ,[noOfNodes, topology , algorihm],_} -> divideArgAndCallFunc(String.to_integer(a),\\b))  ### For Nodes
      #{_ ,[a,b],_} -> app(String.to_integer(a),String.to_integer(b))
     # _ -> app(1,2)
      #end
    
        noOfNodes = String.to_integer(noOfNodes)
        numRequests = String.to_integer(numRequests)
        nodeids = generate_nodeids(noOfNodes) 
        #IO.inspect nodeids
        #IO.puts "rahul"
        {:ok, _pid} =   MySupervisor.start_link([noOfNodes,numRequests])

        ##--Wins--##
        # 10% of the nodes will be added later to the network
        noOfInsertNodes = floor(noOfNodes*0.1)
        insert_nodeids = if noOfInsertNodes > 0, do: Enum.take_random(nodeids, noOfInsertNodes), else: []
        IO.inspect insert_nodeids
        IO.inspect length(insert_nodeids)

        # remaining nodes to add for now
        nodeids = nodeids -- insert_nodeids
        IO.inspect nodeids
        IO.inspect length(nodeids)

        IO.inspect insert_nodes(insert_nodeids, nodeids)
        ##--Wins--##

        set_routing_table(nodeids)
        pid = Process.whereis(String.to_atom(Enum.at(nodeids,0)) )
        Tapestry.route_to_node(pid, Enum.at(nodeids,5))
        NodeInfo.initiate_requests(noOfNodes, numRequests)
        
        
       # IO.inspect Tapestry.get(pid)
        #pid  = Process.whereis(String.to_atom("C097638F92DE80BA8D6C696B26E6E601A5F61EB7"))
        #IO.inspect Tapestry.get(pid)
        #IO.puts Enum.at(nodeids,5)
       # Enum.each(nodeids, fn x -> pid = Process.whereis(String.to_atom( x))
        #IO.inspect Tapestry.get(pid) end)
        #:timer.sleep(2000)
        #{_, maxhop_count} = NodeInfo.get()
        #IO.puts "kar na print"
        #IO.puts maxhop_count
        print_maxhop(0)
        #IO.inspect filter_nodeid(nodeids, Enum.at(nodeids,0), 1 , [])
       # IO.puts String.length(lcp(["ra","aaa"]))
       #failure_percentage = String.to_integer(failure_percentage)
        #noOfFailedNodes = trunc(failure_percentage*noOfNodes/100)
        #algorihm = "gossip"
        #topology = "line"
        
       


      #no_of_nodes = [30, 50, 100,500, 1000,1500, 2000,2500, 3000, 3500, 4000, 4500, 5000]
    

    #Topologies.full_network(noOfNodes,algorihm)
    #threeDtorus_network(noOfNodes,algorihm)
    #if check_args(noOfNodes, topology, algorihm ) == true do
    #organize_nodes_in_topology(noOfNodes , topology , algorihm)
    #NodeInfo.initiate_algorithm(algorihm)
    
    #print_convergence_time("anyvalue",0)
    end

    #{:ok, pid}
    
  #end

  #pass string to this method
  

  defp generate_nodeids(noOfNodes) do
     
    Enum.map(1..noOfNodes,fn x -> Generic.generate_id(Integer.to_string(x)) end)
  end

  defp set_routing_table(nodeids) do
    
    Enum.each(1..length(nodeids), fn node_number -> 
    nodeid = Enum.at(nodeids, node_number-1)
    nodeids  = nodeids -- [nodeid]
    pid = Process.whereis(String.to_atom(nodeid) )
    Tapestry.set_state(pid,nodeid, nodeid_routing_table(nodeids,nodeid, 1, []) ) end)
  end

  defp nodeid_routing_table(nodeids, nodeid, level, routing_table) when level >=40 do
    #String.starts_with?("elixir", "eli")
    #Enum.filter(nodeids, fn nodeid -> end)
    prefix = String.slice(nodeid, 0..level-1)
    ##filterNodeids = Enum.filter(nodeids, fn nodeid -> String.starts_with?(nodeid, prefix) end)
    ##nodeids = nodeids -- filterNodeids
    #routing_table ++ [Enum.take_random(nodeids, 16)]
    routing_table ++ [find_entries(nodeids , [], 0, String.slice(prefix, 0..-2))]
  end
  defp nodeid_routing_table(nodeids, nodeid, level, routing_table) do
    #String.starts_with?("elixir", "eli")
    #Enum.filter(nodeids, fn nodeid -> )
    prefix = String.slice(nodeid, 0..level-1)
    level = level + 1
    filterNodeids = Enum.filter(nodeids, fn nodeid -> String.starts_with?(nodeid, prefix) end)
    ##nodeids = nodeids -- filterNodeids
    #routing_table =  routing_table ++ [Enum.take_random(nodeids, 16)]
    #To get the i entry, prefix : remove last character beacause we need prefix for this level
    routing_table =  routing_table ++ [find_entries(nodeids , [], 0, String.slice(prefix, 0..-2))]

   # IO.puts level;
    #IO.puts nodeid;
    nodeid_routing_table(filterNodeids, nodeid, level, routing_table)
    #IO.puts level;
  end

   #will fillup the 1st,2nd,3rd...16th entry
   #nodeid: nodeis to filter, list: resulting list, i -> ith entry, skipi: value of i to skip matching the digit of root node
   defp find_entries(nodeids,list,i, prefix) when i>=15 do
     if  i > 15 do
      list
     else
      filterNodeids = Enum.filter(nodeids, fn nodeid -> String.starts_with?(nodeid, prefix<>Integer.to_string(i, 16)) end)
      if length(filterNodeids) > 0 do
         list ++ [Enum.random(filterNodeids)]
      else
        list
      end
    end
    
    
   end
  #will fillup the 1st,2nd,3rd...16th entry
  defp find_entries(nodeids,list,i, prefix) do
    
    filterNodeids = Enum.filter(nodeids, fn nodeid -> String.starts_with?(nodeid, prefix<>Integer.to_string(i,16)) end)
    nodeids = nodeids -- filterNodeids
    if length(filterNodeids) > 0 do
      list = list ++ [Enum.random(filterNodeids)]
      find_entries(nodeids,list,i+1, prefix)
    else
      find_entries(nodeids,list,i+1, prefix)
    end
   
  end

  def print_maxhop(condition) when condition == 1 do
    {_remaining_requests, maxhop_count} = NodeInfo.get()
    IO.puts maxhop_count
  end

  def print_maxhop(_condition) do
    {remaining_requests, _maxhop_count} = NodeInfo.get()
    if remaining_requests >= 0 do
      print_maxhop(0)
    else
      print_maxhop(1)
    end
  end

  ##--Wins--##
  def insert_nodes(insert_nodeids, nodeids) do
    Enum.map(insert_nodeids, fn addnode -> 
      surrogate_node(addnode, nodeids)
    end)
  end

  def surrogate_node(addnode, nodeids) do # multicasts the message for the incoming node
    find_closest_entry(addnode, nodeids, 0) # Initiating with "lvl 1" match, so i = 0
  end
  
  def find_closest_entry(addnode, nodeids, i) do
    filterNodeids = Enum.filter(nodeids, fn nodeid -> String.starts_with?(nodeid, String.slice(addnode, 0..i)) end)
    if length(filterNodeids) > 0 and i < 15 do
      find_closest_entry(addnode, filterNodeids, i+1) # increment "lvl", lvl is always 1 more than i.
    else # i denotes the prefix length that matches
      close(addnode, nodeids, i, 15, List.first(nodeids)) # max_diff is 15, default closest <= first(nodeids)
    end
  end

  def close(_, [], i, _, closest) do
    {closest, i+1} # lvl = i+1
  end

  def close(addnode, [id | nodeids], i, diff, closest) do
    x = String.to_integer(String.at(addnode, i), 16)
    y = String.to_integer(String.at(id, i), 16)
    new_diff = abs(x-y)
    if new_diff < diff do
      closest = id
      close(addnode, nodeids, i, new_diff, closest)
    else # new_diff >= diff
      close(addnode, nodeids, i, diff, closest)
    end
  end

  def needToKnow_nodes() do
    
  end
  ##--Wins--##

end
