# Part 3: Critter classification with Nextflow

Nextflow is a workflow tool that enables the orchestration of complex computational pipelines with ease. It provides an abstraction layer over the underlying execution environment, whether it's your local computer, a high-performance computing cluster, or cloud infrastructure. This means you can write your workflow once and run it anywhere, ensuring reproducibility across different environments.

Importantly, Nextflow solves a number of the problems you might have noticed using Bash scripting:

- Each command or task can be run in parallel, limited only by available compute resources - it takes some effort to implement that in Bash.
- Software is automatically made available specific to each process. You might not have appreciated that in the previous examples because we prepared your software environment for you in GitPod, but it's a very important consideration.
- Nextflow workflows are composed of modular processes (or scripts) that can be easily reused or modified. Bash scripts can be modular but tend to become more unwieldy as complexity increases.

## Step 1: Find the critters

For this exercise, we have created a folder called [`activity/nextflow/data`](../activity/nextflow/data) that contains a copy of all of the original animal images in the top-level [`data/`](../data/) folder.

1. Let's change to the appropriate directory:

    ```console
    cd /workspace/nf-training-intro/activity/nextflow
    ```

2. List the contents of the folder:

    ```console
    $ ls

    collages  data  main.nf
    ```

In this directory, you will see a [`main.nf`](../activity/nextflow/main.nf) script. This script will define our Nextflow pipeline, let's take a closer look in the next step.

## Step 2: Nextflow 101

The [`main.nf`](../activity/nextflow/main.nf) Nextflow script has several key components.

### Processes

[Processes](https://www.nextflow.io/docs/latest/process.html#processes) are the building blocks of Nextflow workflows. For example, here is a process called `Classify`. This process will execute the `classify.py` script that we were running in the first section of the workshop manually via the command-line. The process takes the path to a single image (`path pic`) as well as the labels (`path prompts`) in the `input` section. The `output` section passes the result of the classification printed to screen alongside the original image.

```groovy
process Classify {
    memory '8G'
    container 'robsyme/clip-cpu:1.0.0'

    input:
    path pic
    val prompts

    output:
    tuple stdout, path(pic)

    script:
    "classify.py --image $pic --labels '$prompts'"
}
```

You should also recognise the other processes. Immediately after classification, we resize the (potentially large) image to something that will fit in a 100x100 pixel box. The resized image is saved as a png file to the current directory (`.` is the directory in which the command is being run).

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

After resizing, the `Collage` process below takes groups of labelled images and creates a collage for each label. It uses the `montage` command from ImageMagick (a software suite for image manipulation). Recall, we were running two commands to achieve this earlier.

```groovy
process Collage {
    container 'robsyme/imagemagick:latest'

    input:
    tuple val(label), path("pics/*")

    output:
    path "collage.png"

    script:
    """
    montage pics/* -background black +polaroid -background '#ffbe76' collage_nolabel.png
    montage -label '$label' -geometry +0+0 -background "#f0932b" collage_nolabel.png collage.png
    """
}
```

The final `CombineImages` process gathers all of the collages created by the earlier `Collage` process and combines them into one large image called `collage_all.png`. This demonstrates Nextflow's ability to aggregate outputs from previous steps and produce a consolidated result, a task that would be cumbersome and error-prone in bash, especially with varying numbers of intermediate files.

```groovy
process CombineImages {
    container 'robsyme/imagemagick:latest'
    publishDir params.outdir

    input:
    path "in.*.png"

    output:
    path "collage_all.png"

    script:
    """
    montage -geometry +10+10 -quality 05 -background "#ffbe76" -border 5 -bordercolor "#f0932b" in.*.png collage_all.png
    """
}
```

### Parameters

[Parameters](https://www.nextflow.io/docs/latest/cli.html#pipeline-parameters) or `params` allow for flexible, user-defined inputs into the workflow. For example, they enable users to specify input directories containing images (`params.input`), labels for classification (`params.prompts`), and output directories (`params.outdir`) at runtime that can be passed to the workflow. This flexibility is a stark contrast to our earlier Bash scripts, where such values would need to be hardcoded or passed in a less structured way.

### Channels

In Nextflow, [channels](https://www.nextflow.io/docs/latest/channel.html#channels) are used to transport data and connect processes together. Think of them as pipes through which your data flows. In this workflow, we make a channel of picture files called `pics`. This channel is responsible for making the images available to the first process (`Classify`) in the workflow.

We can create this channel in Nextflow using some built-in tools which are designed to find a set of files and add them to the channel. This is called a channel factory and in this example, we will specify where to look for the files using the `params.input` variable.

```groovy
pics = Channel.fromPath(params.input)
```

Then we can pass that channel as input to a process, and get one or more channels in return.

```groovy
Classify(pics, params.prompts)
```

## Step 3: Running the Workflow

Now that you understand how the workflow is structured, you can start running some Nextflow magic!

Before we start, we need to make sure Nextflow is installed in your environment. This should already have been set up for you, so we can run the command below and the version of Nextflow will be printed to the console:

```bash
nextflow -version
```

With Nextflow, initiating the workflow is as simple as running a command in your terminal, specifying the image folder and labels as input. Nextflow takes care of the rest, efficiently managing resources and running the pipeline reproducibly. Run the following on the command-line:

```bash
nextflow run main.nf --input "data/*.png" --prompts 'cat,dog,cute_dog' --outdir results
```

Nextflow takes each input image and then runs as many `Classify` tasks in parallel as will fit on the available resources. When each of the classification tasks are complete, the task outputs are emitted into a "channel", the contents of which we print to the command line. The output of the `Classify` process is then passed as input to the `Resize` process, the output of the `Resize` process is then passed to the `Collage` process...and so on until the pipeline finishes.

Once the pipeline completes, you will see the final `collage_all.png` available in a new directory called `results` - just like that! You can view the contents of the folder with the command below:

```bash
ls results

collage_all.png
```

## Step 4: Resuming the workflow

If we execute the same `nextflow run` command again, Nextflow will rerun the entire pipeline from scratch which can be wasteful. However, Nextflow has an intelligent caching mechanism that we can turn on by adding the `-resume` flag. 

Re-run the workflow with this extra argument and you should see that the workflow completes much more quickly because it does not recompute the tasks that have already successfully completed.

```bash
nextflow run main.nf --input "data/*.png" --prompts 'cat,dog,cute_dog' --outdir results -resume
```

## What is Nextflow doing?

As the pipeline runs in the background, Nextflow will do the following:

- Environment initialization: Nextflow initializes the workflow based on your script, prepares the environment, and makes the required software available through containers.

- Data handling: Nextflow reads the input parameters and creates channels that facilitate the flow of data between processes. This automatic handling of data is more efficient and less error-prone than manual specification in Bash scripts.

- Parallel execution: As the workflow progresses, Nextflow automatically manages the distribution of running the tasks for each image, across the available computational resources. This parallel execution is managed internally by Nextflow and is transparent to the user, contrasting with the sequential execution nature of Bash scripts.

- Container management: For each process that has a `container` definition, Nextflow pulls the necessary container files and executes the commands within an isolated environment. This ensures consistency, reproducibility, and portability, addressing the common challenge of "it works on my machine but not on yours?!". Bash scripts, by themselves, do not provide such isolation, making it harder to reproduce results.

## Quiz

Try to answer the following questions for yourself:

- What if you wanted to share the results of your classification workflow with your colleagues?
- What if a collaborator of yours wanted to also run classification with this workflow, using the same parameters? How would you share those with them?
- What if you wanted to run this workflow on data stored in the Cloud, but did not have knowledge of the cloud execution and storage?
- Machine learning can become costly if you are using large datasets, what if you wanted to better understand how costly running this classification workflow was in the Cloud?

## Summary

By simplifying the complexity involved in task management, parallel processing, and environment consistency, you can now see how Nextflow provides a robust framework for executing data-intensive workflows. This allows bioinformaticians, researchers, developers, and analysts across a variety of domains to focus more on the logic and outcomes of their projects, rather than the intricacies of the computational processes and the underlying infrastructure.

In the next section of the workshop, [Part 4: Critter classification on Seqera Platform](part4-platform.md), we will show you how quickly we can transition to running the same workflow from a small GitPod environment to the Cloud by exploiting the power of the Seqera Platform!