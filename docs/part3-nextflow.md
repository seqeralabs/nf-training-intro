# Part 3. Critter classification with Nextflow

## Introduction to Running a Nextflow Workflow

Nextflow is a workflow tool that enables the orchestration of complex computational pipelines with ease. It provides an abstraction layer over the underlying execution environment, whether it's your local computer, a high-performance computing cluster, or cloud infrastructure. This means you can write your workflow once and run it anywhere, ensuring reproducibility across different environments.

Importantly this approach addresses a number of the problems you might have noticed using the Bash scripting:

 * Processes will run in parallel, limited only by available compute resources (it takes some effort to make that happen in Bash). In fact you often use compute resources outside of the machine you execute the workflow on.
 * Software is automatically made available specific to each process. You might not have appreciated that in the previous examples because we prepared your software environment for you, but it's a very important consideration.

### Step 1: Setting Up Your Workspace

Before we start, we need make sure Nextflow is installed in your environment. This should already have been set up for you, but we can run commands like the following to see exactly what version of Nextflow we will be using:

```bash
nextflow -version
```

You should see the version info printed to the console.

### Step 2: Understanding Your Nextflow Workflow

Navigate to the `activity/nextflow/` directory where you will see a `main.nf` script. This script will define our workflow - let's take a closer look.

Your workflow has several key components:

a. Channel Creation

In Nextflow, channels are used to transport data between processes. Think of them as pipelines through which your data flows. In this workflow, the `pics` channel is created from a file path specified by the parameter named `input`. This channel is responsible for making the images available to the first process (Classify) in the workflow.

b. Parameters

Parameters (`params`) allow for flexible, user-defined inputs into the workflow. They enable users to specify input directories (`params.input`), labels for classification (`params.prompts`), and output directories (params.outdir) at runtime. This flexibility is a stark contrast to our earlier Bash scripts, where such values would need to be hardcoded or passed in a less structured way.

c. Processes
`process Classify`: This process will execute the `classify` command we have been running in earlier steps manually, for each image based on the provided labels, and outputs the classification results to a text file (out.txt) alongside the original image.

`process Collage`: After classification, this process takes groups of labeled images and creates a collage for each label. It uses the montage command from ImageMagick (a software suite for image manipulation). Recall, we were running two commands to achieve this earlier.

`process CombineImages`: This final process gathers all the collages created by the earlier `Collage` process and combines them into one large image (collage.png). This demonstrates Nextflow's ability to aggregate outputs from previous steps and produce a consolidated result, a task that would be cumbersome and error-prone in bash, especially with varying numbers of intermediate files.

### Step 3: Running the Workflow

Now that you understand how the Workflow is structured, you can now start running some Nextflow magic!

All of the data you will use as input for the workflow is provided in `activity/nextflow/data`. With Nextflow, initiating the workflow is as simple as running a command in your terminal, specifying your image folder and labels. Nextflow takes care of the rest, efficiently managing resources and ensuring the process is smooth.

Run the following command on the command line:

```bash
nextflow run main.nf --prompts 'cat,dog,cute dog'
```

You'll see the log output subsequently displayed to the terminal, and the status of each process in the workflow.

### Step 4: Analyze workflow log and outputs

As the pipeline runs in the background, Nextflow be doing the following tasks:

- Nextflow Initialization: Nextflow initializes the workflow based on your script, prepare the environment, and make software available through containers.

- Data Handling: Nextflow reads the input parameters and creates channels that facilitate the flow of data between processes. This automatic handling of data paths is more efficient and less error-prone than manual specification in Bash scripts.

- Parallel Execution: As the workflow progresses, Nextflow automatically manages the distribution of running `classify` multiple times, across available computational resources. This parallel execution is managed internally by Nextflow and is transparent to the user, contrasting with the sequential nature of Bash scripts.

- Container Management: For each process that specifies a container, Nextflow pulls the necessary images and executes the commands within isolated environments. This ensures consistency and reproducibility, addressing the common challenge of "it works on my machine".

Once it completes, you'll see the final `collage.png` available in a new directory called `results` - just like that!

### Key Differences from Bash Scripting

- Parallel Processing: Nextflow inherently supports parallel processing of tasks. This means, we don't need to specify images to our `classify` command, one-by-one.

- Containerization: Each process in the Nextflow workflow can be executed within a container, ensuring consistency across different computing environments. Bash scripts, by themselves, do not provide such isolation, making it harder to reproduce results.

- Modularity: Nextflow workflows are composed of modular processes (or scripts) that can be easily reused or modified. Bash scripts can be modular but tend to become more unwieldy as complexity increases.
