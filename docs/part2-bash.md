# Part 2: Critter classification with Bash scripting

Hopefully, the previous exercise using the command-line wasn't too tricky, but it was a bit tedious running all of those commands wasn't it? Let's exercise our [3 virtues](https://thethreevirtues.com/) and try to make life easier for ourselves.

## Introduction to Bash and Bash Scripting

[Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)), or the Bourne Again SHell, is a powerful command-line language used widely across Unix-like operating systems. It enables users to execute commands, navigate file systems, and manipulate data. Bash's true potential is unlocked through scripting!

A Bash script is essentially a file containing a series of commands that are executed sequentially by the Bash shell. Writing a script involves encapsulating commands you might normally type on the command-line like you performed in the previous section. Scripting saves you time and reduces the potential for error when performing repetitive tasks. It also allows you to 'loop' through commands, for example, to repeat the same actions with different input files.

## Step 1: Find the critters

For this exercise, we have created a folder called [`activity/bash/data`](../activity/bash/data) that contains a copy of all of the original animal images in the top-level [`data/`](../data/) folder.

1. Let's change to the appropriate directory:

    ```console
    cd /workspace/nf-training-intro/activity/bash
    ```

2. List the contents of the `data` folder:

    ```console
    $ ls data

    aussie.png  chihuahua.png  dog.png  hiding.png  pug.png  rain-ready.png  reflective.png  yawn.png
    ```

Now that you are in the correct location relative to where the input images are stored, you will be able to run the classification with the images in `data/`.

## ## Step 2: Run the Bash script

We have precreated a bash script called [`make_collage.sh`](../activity/bash/make_collage.sh). Have a look at this script and check that you understand the rough picture of what's going on (the fine detail is unimportant here). We're essentially automating what you did [before](../docs/part1-cli.md), looping over all the input images, classifying them, making a collage for each class and combining those collages at the end.

Run the command below to execute the script, and check that it works:

```bash
./make_collage.sh
```

## Conclusions



<details>
<summary>Summary</summary>
While Bash scripts offer more efficiency and scalability over running individual CLI commands, there is still an important limitation with respect to reproducibility and scalability. For instance, executing the same script across different computers, or environments might yield varying results due to differences in software versions, operating systems, or configurations. Moreover, Bash scripts can become unwieldy as the complexity of the tasks increases, especially when dealing with large datasets or requiring parallel processing.
</details>

## Next steps

This is where Nextflow comes in to save the day. Nextflow is designed to address these limitations by enabling scalable and reproducible scientific workflows. It allows you to write pipelines that are portable across multiple execution environments to ensure consistent results. Nextflow also simplifies complex data-driven processes to automate and execute tasks in parallel.

Let's see how, proceed to the next part: [Part 3. Critter classification with Nextflow](part3-nextflow.md).

## Quiz

You should see that running the Bash script produces the composite collage file `collage_all.png` with a single command! 

Try to answer the following questions for yourself:

- Is this an improvement compared to the previous exercise?
- If this was a more time-consuming task where each image took 10 minutes to classify and there is a power failure at GitPod HQ, would we be able to resume the sequence of commands?
- How well will this scale to 1000s of images?
- What would happen if you copied this script to a different computer where the software hasn't already been installed?


- This is clearly a little more reproducible because we are removing some human involvement. But what if someone in the host environment changes what the `classify.py` command does?




- What if there were 1000 images? Would you be happy following the above steps for all of them?
- Even if you did, are you confident you would get the commands right if you had to type them out 100 times again?
- How annoyed would you be if you had lost your place half way through and had to start again?

## Summary

After classifying a few images one by one, you will notice a couple of things. First, it can be quite tedious to type out or copy-paste the command repeatedly for multiple images. Secondly, this method does not scale well if we have hundreds or thousands of images to classify. Imagine having to run each image through the command-line individually - it would be incredibly time-consuming and inefficient.

In the next section of the workshop: [Part 2: Critter classification with Bash scripting](part2-bash.md), we will instead encapsulate these commands into a Bash script. This will not only simplify the process of classifying multiple images but also sets the stage for understanding the power of automation and scalability — key features that Nextflow enhances in more complex workflows.
