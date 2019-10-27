defmodule NodeInfo do 
    use GenServer

    def start_link(numNodes,numRequests) do
        GenServer.start_link(__MODULE__, {numNodes*numRequests,1},name: __MODULE__ )
    end
    def init(state) do
       {:ok, state}
    end

    def get() do  
        GenServer.call(__MODULE__, :get, :infinity)
      end
    def initiate_requests(numNodes, numRequests, failedNodes) do
        
        nodeids = Enum.map(1..numNodes, fn n ->
             Generic.generate_id(Integer.to_string(n)) end )
        nodeids = nodeids -- failedNodes 
        Enum.each(nodeids, fn nodeid ->
            pid = Process.whereis(String.to_existing_atom(nodeid ))
            
           # IO.inspect Tapestry.get(pid)
            Tapestry.send_to_nodes( pid , numNodes , numRequests )
          end
            )
        
    end

    #Tapsetry nodes will use this function to send done requests
    #to nodeinfo, and will send the  counts of hops for routing to a node
    def done(hop_count) do
        
       # IO.puts "Done"
       GenServer.cast(__MODULE__, {:done,hop_count})
    end

  
   
    def handle_cast({:done,hop_count},{remaining_requests, maxhop_count}) do
       
        #IO.puts "YDone"
        # Reduce the request count on receivind done message and also updae the max_hop if necessry
       {:noreply, {remaining_requests - 1 , find_max(maxhop_count, hop_count)} }
    end


    
    def handle_call(:get,_from,state) do
        #IO.puts (Enum.at(list,length(list) -1 ) - start_time)
        {:reply, state,state}
    end

   def find_max(n1,n2) do
       if n1 > n2 do
           n1
       else
           n2
       end
   end



end