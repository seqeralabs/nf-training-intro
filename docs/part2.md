# Running Classification - in a Bash script

## Introduction to Bash and Bash Scripting

Bash, or the Bourne Again SHell, is a powerful command line interface (CLI) used widely across Unix-like operating systems. It enables users to execute commands, navigate file systems, and manipulate data. Bash's true potential is unlocked through scripting!

A Bash script is essentially a file containing a series of commands that are executed sequentially by the Bash shell. Writing a script involves encapsulating commands you might normally type into the CLI, saving you time and reducing the potential for error when performing repetitive tasks.

Let's consider our example of classifying images from Part 1. Running this classification command for each image manually is tedious. However, by placing these commands in a Bash script, you can classify multiple images with a single command. This not only makes the process more manageable but also a bit more scalable.

Step 1: Basic structure of the script
Open up the `classify.sh` script in the ??? folder. You'll see the following contents:

```bash
#!/bin/bash

for image in images/*; do
  echo "Classifying $image..."
  python classify.py $image "cat,dog"
done
```

This script will run a loop on each image in the `images/` folder, running the classify script on them individually without the need for manual input for each one.

Step 2. Run the script
Execute the script by typing ./classify_images.sh and pressing Enter. The script will start processing each image in the images directory, classifying them as specified. This now saves you the effort of manually entering commands for each file!

## Limitations

While Bash scripts offer more efficiency and scalability over running individual CLI commands, their is still an important limitation with respect to reproducibility and scalability. For instance, executing the same script across different computers, or environments might yield varying results due to differences in software versions, operating systems, or configurations. Moreover, Bash scripts can become unwieldy as the complexity of the tasks increases, especially when dealing with large datasets or requiring parallel processing.

## A better way to go with the flow - Nextflow

This is where Nextflow comes in to save the day. Nextflow is designed to address these limitations by enabling scalable and reproducible scientific workflows. It allows you to write pipelines that are portable across multiple execution environments to ensure consistent results. Nextflow also simplifies complex data-driven processes to automate and execute tasks in parallel. Let's see how in Part 3!
