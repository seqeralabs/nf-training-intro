# Nextflow: Go with the Flow!

Welcome to Go with the Flow, a workshop to introduce Nextflow to the completely uninitiated. We want to give you a flavour of what life was like for Bionformaticians before Nexflow and similar tools, and show you how Nextflow helps to solve the problems experienced by those early pioneers.

At its very core, Nextflow is about:

 - scalability - running a large number of processes
 - parallelism - running those processes at the same time
 - reproducibility - by removing the human element by running sequential commands, we make that sequence more reproducible
 - resumability - the ability to carry on with interrupted analysis without starting from scratch

We'll illustrate all of these things on our journey.

## Our test case

We've intentionally picked a test case quite different to the usual workloads, to make the transferability of the concepts clear. 

Here's the scenario. You've been given a set of pictures of your colleagues' animals, and you want to be able to classify them, so you can make attractive collages of them for your company retreat. Unfortunately you've developed cat/ dog/ spider- blindness and can't classify the critters. Oh no! Fortunately this is 2024, so you can enlist the help of AI. You're going to:

 - Use a popular classification tool to assign critters to classes based on a dictionary of labels you provide.
 - Make a collage of the critters for each class.
 - Combine the collages to create one glorious critter cornucopia.

We're going to do this in 3 different ways of decreasing manual intervention, showing you the power of Nextflow. 

## Step 0: environment setup

For this workshop we're going to be using a tool called 'GitPod', which provides us with a ready-made software environment to play in. You will need a GitHub account, so if you don't have one, go to [GitHub](https://github.com/) and create on for yourself.

### Browser plugin

It will make things easier for you if you have a browser extension to provide easier access to GitPod. Go [here](https://www.gitpod.io/docs/configure/user-settings/browser-extension) and follow the link to install the extension for your preferred browser. Restart your browser if required.

## Start the GitPod environment

Now, from this repository, you should see a green button with a funny-shaped 'G', to the right of the 'code' button. Click that, follow any prompts, wait, and you should get a GitPod workspace with all the right things installed.

## Step 1: in the beginning there was just the command line

All bioinformaticians (and other data scientists) start this way: running commands one-by-one on the command line, and it works. We'll walk through the process here:

## Step 2: 'typing all those commands is boring': let's write some Bash


## Step 3: can't we automate everything? Enter Nextflow
