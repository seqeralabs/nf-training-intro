# Part 2. Critter classification with Bash scripting

Hopefully that first approach wasn't too tricky, but it was a bit tedious running all those commands wasn't it? Let's exercise our [3 virtues](https://thethreevirtues.com/) and try to make life easier for ourselves.

## Introduction to Bash and Bash Scripting

Bash, or the Bourne Again SHell, is a powerful command line interface (CLI) used widely across Unix-like operating systems. It enables users to execute commands, navigate file systems, and manipulate data. Bash's true potential is unlocked through scripting!

A Bash script is essentially a file containing a series of commands that are executed sequentially by the Bash shell. Writing a script involves encapsulating commands you might normally type into the CLI, saving you time and reducing the potential for error when performing repetitive tasks. It also allows you to 'loop', repeating the same actions repeatedly with different inputs.

## Implementing the critter classification

Change to the `/bash` activity directory. If you're currently still in the `cli` subdirectory you can do this on the command line with:

```bash
cd ../bash
```

We've provided a script for you [here](../activity/bash/make_collage.sh). Have a look at this script and check that you understand the rough picture of what's going on (the fine detail is unimportant here). We're essentially automating what you did [before](../docs/cli.md), looping over all the input images, classifying them, making a collage for each class and combining those collages at the end.

Run this command to execute the script, and check that it works:

```bash
./make_collage.sh
```

## Conclusions

You should see that the classification happens automatically using Bash scripting, producing `collage_all.png`, and hopefully see that this is an improvement. But ask yourself the following:

- This is clearly a little more reproducible because we're removing some human involvement. But what if someone in the host environment changes what the `classify` command does?
- If this was a more time-consuming task where each image took 10 minutes to classify and there is a power failure, would we be able to resume the sequence of commands?
- How well will this scale to 1000s of images?
- What would happen if you copied this script to a different computer where the software hasn't already been installed?

<details>
<summary>Summary</summary>
While Bash scripts offer more efficiency and scalability over running individual CLI commands, their is still an important limitation with respect to reproducibility and scalability. For instance, executing the same script across different computers, or environments might yield varying results due to differences in software versions, operating systems, or configurations. Moreover, Bash scripts can become unwieldy as the complexity of the tasks increases, especially when dealing with large datasets or requiring parallel processing.
</details>

## Next steps

This is where Nextflow comes in to save the day. Nextflow is designed to address these limitations by enabling scalable and reproducible scientific workflows. It allows you to write pipelines that are portable across multiple execution environments to ensure consistent results. Nextflow also simplifies complex data-driven processes to automate and execute tasks in parallel.

Let's see how, proceed to the next part: [Part 3. Critter classification with Nextflow](nextflow.md).
