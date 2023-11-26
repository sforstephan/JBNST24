clear all;
umwSD=5; %standard deviation of the environment - in % of optimal outcome (in the simulation study it is either 5,25,or 45)
jto=700; %amount of simulation runs
%----
%variable definition for the memory of P&A
limitedMemoryP=true; %true or false; false=unlimited memory
limitedMemoryA=true; %true or false; false=unlimited memory
memoryP=5; %length of the memory in periods (in simulation study either seit to 1,3,5 or untlimited(see above))
memoryA=1; %length of the memory in periods (in simulation study either seit to 1,3,5 or untlimited(see above))
%----
A_bekannt_agentization_v4_limitedMemory