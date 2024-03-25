# Part 3: Critter classification with Nextflow

## Introduction to Running a Nextflow Workflow

Nextflow is a workflow tool that enables the orchestration of complex computational pipelines with ease. It provides an abstraction layer over the underlying execution environment, whether it's your local computer, a high-performance computing cluster, or cloud infrastructure. This means you can write your workflow once and run it anywhere, ensuring reproducibility across different environments.

Importantly this approach addresses a number of the problems you might have noticed using the Bash scripting:

- Processes will run in parallel, limited only by available compute resources (it takes some effort to make that happen in Bash). In fact you often use compute resources outside of the machine you execute the workflow on.
- Software is automatically made available specific to each process. You might not have appreciated that in the previous examples because we prepared your software environment for you, but it's a very important consideration.

### Step 1: Setting Up Your Workspace

Before we start, we need make sure Nextflow is installed in your environment. This should already have been set up for you, but we can run commands like the following to see exactly what version of Nextflow we will be using:

```bash
nextflow -version
```

You should see the version info printed to the console.

### Step 2: Understanding Your Nextflow Workflow

Navigate to the `activity/nextflow/` directory:

```bash
cd /workspace/nf-training-intro/activity/nextflow
```

In this directory, you will see a `main.nf` script. This script will define our workflow - let's take a closer look.

Your workflow has several key components:

### Processes

These are the building blocks of your workflow. Here is the 'Classify' process:

```groovy
process Classify {
    memory '8G'
    container 'robsyme/clip-cpu:1.0.0'

    input:
    path(pic)
    val(prompts)

    output:
    tuple path("out.txt"), path(pic)

    script:
    "classify.py --image $pic --labels '$prompts' > out.txt"
}
```

This process will execute the `classify` command we have been running in earlier steps manually, for each image based on the provided labels, and outputs the classification results to a text file (out.txt) alongside the original image. You can see that there are sections for the input, output, and the command.

You should also recognise the other processes:

```groovy
process Resize {
    container 'robsyme/imagemagick:latest'

    input:
    tuple val(label), path("pics/*")

    output:
    tuple val(label), path("*.png")

    script:
    """
    mogrify -resize 100x100 -path . -format png pics/*
    """
}
```

Immediately after classification, we resize the (potentially large) image to something that will fit in a 100x100 pixel box. The resized image is saved as a png file to the current directory (`.` is the directory in which the command is being run).

```groovy
process Collage {
    container 'robsyme/imagemagick:latest'

    input:
    tuple val(label), path("pics/*")

    output:
    path "collage.png"

    script:
    """
    montage pics/* -background black +polaroid -background '#ffbe76' png:- \
    | montage -label '$label' -geometry +0+0 -background "#f0932b" - collage.png
    """
}
```

After resizing, this `Collage` process takes groups of labeled images and creates a collage for each label. It uses the montage command from ImageMagick (a software suite for image manipulation). Recall, we were running two commands to achieve this earlier.

```groovy
process CombineImages {
    container 'robsyme/imagemagick:latest'
    publishDir params.outdir

    input:
    path "in.*.png"

    output:
    path "collage.png"

    script:
    """
    montage -geometry +10+10 -quality 05 -background "#ffbe76" -border 5 -bordercolor "#f0932b" in.*.png collage.png
    """
}
```

This final process gathers all the collages created by the earlier `Collage` process and combines them into one large image (collage.png). This demonstrates Nextflow's ability to aggregate outputs from previous steps and produce a consolidated result, a task that would be cumbersome and error-prone in bash, especially with varying numbers of intermediate files.

### Channel Creation

In Nextflow, channels are used to transport data and connect processes together. Think of them as pipes through which your data flows. In this workflow, we make a channel of picture files called `pics`. This channel is responsible for making the images available to the first process (`Classify`) in the workflow.

We can create this channel in Nextflow using some built-in tools which are designed to find a set of files and add them to the channel. This is called a channel factory and in this example, we will specify where to look for the files using the `params.input` variable.

```groovy
pics = Channel.fromPath(params.input)
```

Then we can pass that channel to a process, and get one or more channels in return;

```groovy
Classify(pics, params.prompts)
```

### Parameters

Parameters (`params`) allow for flexible, user-defined inputs into the workflow. They enable users to specify input directories (`params.input`), labels for classification (`params.prompts`), and output directories (params.outdir) at runtime. This flexibility is a stark contrast to our earlier Bash scripts, where such values would need to be hardcoded or passed in a less structured way.

### Step 3: Running the Workflow

Now that you understand how the Workflow is structured, you can now start running some Nextflow magic!

All of the data you will use as input for the workflow is provided in `activity/nextflow/data`. With Nextflow, initiating the workflow is as simple as running a command in your terminal, specifying your image folder and labels. Nextflow takes care of the rest, efficiently managing resources and ensuring the process is smooth.

In our example `main.nf`, we have temporarily disabled some sections of the workflow so that you can see how things change as we progressively add components. Right now the workflow section looks like:

```groovy
workflow {
    pics = Channel.fromPath(params.input)

    Classify(pics, params.prompts)
    | view
//    | Resize
//    | groupTuple
//    | Collage
//    | collect
//    | CombineImages
}
```

The `//` are 'comments', and will disable those lines for now. The `view` "operator" lets us view the contents of the channel Classify process in the meantime.

Run the following command on the command-line:

```bash
nextflow run main.nf --prompts 'cat,dog,cute dog'
```

Nextflow scans the system and then runs as many "Classify" tasks in parallel as will fit on the available resources. When each of the classification tasks are complete, the task outputs are emitted into a "channel", the contents of which we print to the command line using the `view` operator. 

The `Classify` process defined an output block that says that when the task completes, Nextflow should pass the `out.txt` file produced by the task and the `pic` image (recieved as input) down to the rest of the workflow:

```groovy
output:
tuple path("out.txt"), path(pic)
```

The output from our `nextflow run` command includes lines such as:

```
[dog
, <path>/chihuahua.png]
```

... which are the contents of the channel returned from the `Classify` process. The classification ("dog") and image file (chihuahua.png) pair correspond to the pieces in the `Classify` output block.

If we re-execute the same `nextflow run` command, Nextflow will re-calculate the classification step for each input image. Nextflow has an intelligent caching mechanism that we can turn on by adding the `-resume` flag. 

Re-run the workflow with this extra argument and you should see that the workflow completes much more quickly:

```bash
nextflow run main.nf --prompts 'cat,dog,cute dog' -resume
```

Now, edit the file, move the `view` operator down one line, uncomment the line of the `Resize` process (remove the //). The workflow block should look like:

```groovy
workflow {
    pics = Channel.fromPath(params.input)

    Classify(pics, params.prompts)
    | Resize
    | view
//    | groupTuple
//    | Collage
//    | collect
//    | CombineImages
}
```

Re-run the workflow (using `-resume) and look at the channel content and see if you can follow what's happening.

Progressively uncomment all of the workflow lines, running the command each time to see what the content of the channels is.

> [!TIP]
> At the next step, you should edit the `main.nf` to look like:
> ```groovy
> workflow {
>     pics = Channel.fromPath(params.input)
> 
>     Classify(pics, params.prompts)
>     | Resize
>     | groupTuple
>     | view
> //    | Collage
> //    | collect
> //    | CombineImages
> }
> ```

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

## Conclusions

By simplifying the complexity involved in task management, parallel processing, and environment consistency, you can now see how Nextflow provides a robust framework for executing data-intensive workflows. This allows not only bioinformaticians, but researchers, developers, and analysts across a variety of domains to focus more on the logic and outcomes of their projects, rather than the intricacies of the computational processes.

However, ask yourself the following questions:

- What if you wanted to share the results of your classification with your colleagues?
- What if a collaborator of yours wanted to also run classification with this workflow, using the same parameters? How would you share those with them?
- What if you wanted to run this workflow on data stored in the Cloud, but did not have knowledge of the cloud execution and storage?
- Machine learning can become costly if you are using large datasets, what if you wanted to better understand how costly running this classification workflow was in the Cloud?

## Next Steps

This is where Seqera Platform can add a layer of convenience, visualization, and management to your projects. To see how quickly we can get setup to run this workflow on Seqera Platform, proceed to [Part 4. Critter classification on Seqera Platform](part4-platform.md).
