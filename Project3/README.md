# Project3 :- Tapestry-Peer-to-Peer-Overlay-Network  

NAME 1: Rahul Wahi  
UFID: 3053-6162  
  
NAME 2: Wins Goyal  
UFID: 7357-1559  
  
*************************************************************************************************************************
1. **STEPS to run the code**
   
__step1:__ Unzip the file and enter into the "Project3" folder through terminal **($cd Project3)** or where *mix.exs* file is present.  
  
If needed to build the script again, then run  
>>> mix escript.build  
  
__step2:__ Run the the following command to execute the file.  
  
For Linux  
>>> ./proj3 numNodes numRequests  

For Windows  
>>> escript proj3 numOfNodes numRequests  

__Output__:-  
Maximum number of Hops  

*************************************************************************************************
2. **For Bonus:**  
   
__step1:__ Unzip the bonus file and enter into the folder where *mix.exs* file is present.  
  
If needed to build the script again, then run  
>>> mix escript.build  

For Linux  
>>> ./proj3 numNodes numRequests percentageFailure  
  
For Windows  
>>>  escript proj3 numNodes numRequests percentageFailure  
  
__Output__:-  
Maximum number of Hops  

*************************************************************************************************
3. **What is working?**  
  
- The Tapestry overlay works properly and smoothly.  
- The program produces sensible results, like the Max. number of Hops should never exceed LogN (base 16)  

- For the argument 'numNodes', we take 90% nodes to create the Tapestry overlay of P2P network, so that we can use the rest 10% for the "Dynamic Node Insertion" step. We only need to do minimum changes in the network to insert a new node. This check confirms the resilience and stability characteristics of the Tapestry overlay.  
  
- System Configuration: 16GB RAM, i7  
- Maximum numbers of nodes for the network vary based on the System's configuration and its computational resources.  

*************************************************************************************************
4. **Tapestry Algorithms for P2P overlay networks, Max. nodes computed for convergence**  
  
  
- Tested For Maximum 10000 nodes, 100 requests, Max. number of Hops = 8 (Produces result in ~30 minutes)  
- System crashes after exceeding above number of nodes.  

- For 10 nodes, Max. number of Hops = 2  
- For 20 nodes, Max. number of Hops = 3  
- For 28 nodes, Max. number of Hops = 4  
- For 100 nodes, Max. number of Hops = 4  
- For 500 nodes, Max. number of Hops = 5  
- For 1000 nodes, Max. number of Hops = 6  

- We have used the length of 40 digits for the NodeID (radix used is hexadecimal)  
  
  
*Additional details about the analysis can be found in* **report.pdf** *and* **bonus.pdf** *in their corresponding folders.*
