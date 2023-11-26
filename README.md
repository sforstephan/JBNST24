Online material for the paper "Limited information and learning in situations with hidden action: An agent-based approach"
# Table of contents
- [Content](https://gitfront.io/r/user-1726354/79d76c4cfb66419a72a8ac55cec3f5d185dab542/ProjectSarah/#content)
- [Summary](https://gitfront.io/r/user-1726354/79d76c4cfb66419a72a8ac55cec3f5d185dab542/ProjectSarah/#summary)
- [Requirements](https://gitfront.io/r/user-1726354/79d76c4cfb66419a72a8ac55cec3f5d185dab542/ProjectSarah/#requirements)
- [Cloning the model](https://gitfront.io/r/user-1726354/79d76c4cfb66419a72a8ac55cec3f5d185dab542/ProjectSarah/#cloning-the-model)
- [Running the model](https://gitfront.io/r/user-1726354/79d76c4cfb66419a72a8ac55cec3f5d185dab542/ProjectSarah/#running-the-model)
- [Model output](https://gitfront.io/r/user-1726354/79d76c4cfb66419a72a8ac55cec3f5d185dab542/ProjectSarah/#model-output)
- [Explanation of the structure of the datasets](https://gitfront.io/r/user-1726354/79d76c4cfb66419a72a8ac55cec3f5d185dab542/ProjectSarah/#explanation-of-the-structure-of-the-datasets)

# Content
The provided content consists of two parts: First, the code of the agent-based simulation model and, second, the data that is generated using the model and analyzed in the manuscript. 

# Summary
This agent-based simulation model aims to analyze the effects of limited intelligence (in the sense of limitations in memory) in Holmström's hidden action model 
- on the principal’s and the agent’s respective utilities, 
- the effort (action) the agent makes to perform a task, and 
- the premium parameter in the rule to share the outcome between the principal and the agent.

# Requirements
MATLAB R2019b or higher is required to run the model and to analyze the datasets.
In addition, the following packages are required to run the model:
- Parallel Computing Toolbox
- Symbolic Math Toolbox
- Optimization Toolbox
- Global Optimization Toolbox
- Statistics and Machine Learning Toolbox
# Cloning the model
- Install a Git-GUI on your computer (e.g. [GitHub Desktop](https://desktop.github.com/)).
- Start the Programm and make an account.
- Go back to GitFront and click on the "clone"-button on the top right side.
- Copy the link and go back to your Git-GUI.
- Import or "clone" a repository from the internet.
- As soon as the import is finished close the program.
- The whole project should now be at Documents/Git-GUI/ProjectName (e.g. Documents/GitHub/ProjectSarah).
# Running the model
Open the folder "ProjectSarah" >> "Model" >> "agentization". Find and double-click the file main.m. The MATLAB editor opens, and you can change the simulation parameters.

To run the model, you can either:
- Type the script name (main) in the command line and press enter
- Select the main.m file in the editor and press the run button (green triangle)

Please note: If a message pops up with the options "Change Folger", "Add to Path", "Cancel", and "Help", please choose "Add to Path".

You can set all relevant parameters in the file main.m
- umwSD: This is the standard deviation of the normal distribution from which the environmental variable is drawn. It is defined relative (in %) to the optimal outcome. We set it to either 5, 25, or 45.
- jto: This is the number of simulation runs. We set it to 700 in all scenarios. You are free to change it to any number. However, please note that performing many simulation runs might take a long time.
- limitedMemoryP: This parameter defines whether the principal’s memory is limited or not. The variable can be set to either true or false. If set to false, the principal’s memory is unlimited and changes in the variable "memoryP" have no effects.
- limitedMemoryA: This parameter defines whether the principal’s memory is limited or not. The variable can be set to either true or false. If set to false, the agent’s memory is unlimited and changes in the variable "memoryA" have no effects.
- memoryP: This variable defines the length of the principal’s memory (in periods). We set it either to 1, 3, or 5. 
- memoryA: This variable defines the length of the agent’s memory (in periods). We set it either to 1, 3, or 5. 

# Model output
The simulation model creates the folder "Results" in the project directory. This folder consists of at least one subfolder. The subfolder’s name consists, amongst others, of the values assigned to the variables umwSD (environment) and jto (number of simulation runs). This subfolder consists of two further folders named "einzelneSims" (in which only intermediate results are saved) and "final" (in which the final simulation data are saved). 

# Explanation of the structure of the datasets
The datasets are provided in the folder "datasets" in this repository. The folder contains three subfolders: "relatively stable environment", "mid-turbulent environment", and "turbulent environment". In each of these folders, we provide 16 data files, each representing one scenario. Every data file contains 61 variables. However, not all of these variables are used in the analysis because some are saved for verification only. The most important variables are the following (the ones used in the study are printed in bold font):
- **opta**: The effort level proposed by the second-best solution of Holmström’s model.
- **a_A_sims**: This is a 700*20 matrix in our case (700 simulation runs, 20 periods). It contains information on the effort made by the agent to perform a task (in every timestep).
- a_P_sims: This is a 700*20 matrix in our case (700 simulation runs, 20 periods). It contains information on the effort levels incited by the principal (in every timestep).
- **optp**: The premium parameter proposed by the second-best solution of Holmström’s model.
- **p_P_sims**: This is a 700*20 matrix in our case (700 simulation runs, 20 periods). It contains information on the premium parameter set by the principal (in every timestep).
- **optUA**: The agent's utility proposed by the second-best solution of Holmström’s model.
- UA_A_sims: This is a 700*20 matrix in our case (700 simulation runs, 20 periods). It contains information on the (agent’s) utility expected by the agent (in every timestep).
- UA_P_sims: This is a 700*20 matrix in our case (700 simulation runs, 20 periods). It contains information on the agent's utility expected by the principal (in every timestep).
- **UA_realized_sims**: This is a 700*20 matrix in our case (700 simulation runs, 20 periods). It contains information on the utility that realized for the agent (in every timestep).
- lostUA-sims: This is a 700*20 matrix in our case (700 simulation runs, 20 periods). It contains the difference between the optimal and the realized utility for the agent in every timestep (i.e., the optimal minus the achieved utility of the agent). 
- **optUP**: The principal's utility proposed by the second-best solution of Holmström’s model.
- UP_P_sims: This is a 700*20 matrix in our case (700 simulation runs, 20 periods). It contains information on the (principal’s) utility expected by the principal (in every timestep).
- **UP_realized_sims**: This is a 700*20 matrix in our case (700 simulation runs, 20 periods). It contains information on the utility that realized for the principal (in every timestep).
- lostUP-sims: This is a 700*20 matrix in our case (700 simulation runs, 20 periods). It contains the difference between the optimal and the realized utility for the principal in every timestep (i.e., the optimal minus the achieved utility of the principal). 
- optoutcome: The outcome proposed by the second-best solution of Holmström’s model.
- outcome_realized_sims: This is a 700*20 matrix in our case (700 simulation runs, 20 periods). It contains information on the outcome that materialized (in every timestep).
- limitedMemoryA: This variable gives information on whether the agent’s memory was limited or not. Either set to 1 or 0 (If set to 0, the agent’s memory is unlimited).
- limitedMemoryP: This variable gives information on whether the principal’s memory was limited or not. Either set to 1 or 0 (If set to 0, the principal’s memory is unlimited).
- lostoutcome_sims: This is a 700*20 matrix in our case (700 simulation runs, 20 periods). It contains the result of the optimal outcome minus the achieved outcome (in every timestep).
- uwmM: This variable gives information on the mean of the normally distributed environmental factor (set to 0 in our scenarios).
- umwSD: This variable contains the standard deviation of the environmental variable; it is calculated as the chosen deviation in main.m multiplied by the optoutcome.
- jto: This is the number of simulation runs (we set it to 700 in all scenarios).

