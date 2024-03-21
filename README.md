# Nextflow: Go with the Flow!

Welcome to Go with the Flow, a workshop to introduce Nextflow to the completely uninitiated. We want to give you a flavour of what life was like for Bionformaticians before Nexflow and similar tools, and show you how Nextflow helps to solve the problems experienced by those early pioneers.

At its very core, Nextflow is about:

 - scalability - running a large number of processes
 - parallelism - running those processes at the same time
 - reproducibility - by removing the human element by running sequential commands, we make that sequence more reproducible
 - resumability - the ability to carry on with interrupted analysis without starting from scratch

We'll illustrate all of these things on our journey.

## Environment setup

For this workshop we're going to be using a tool called 'GitPod', which provides us with a ready-made software environment to play in. You will need a GitHub account, so if you don't have one, go to [GitHub](https://github.com/) and create on for yourself.

### Browser plugin

It will make things easier for you if you have a browser extension to provide easier access to GitPod. Go [here](https://www.gitpod.io/docs/configure/user-settings/browser-extension) and follow the link to install the extension for your preferred browser. Restart your browser if required.

### Start the GitPod environment

Now, from this repository, you should see a green button with a funny-shaped 'G', to the right of the 'code' button. Click that, follow any prompts, wait, and you should get a GitPod workspace with all the right things installed.

## Our test case

We've intentionally picked a test case quite different to the usual workloads, to make the transferability of the concepts clear. 

Here's the scenario. You've been given a set of pictures of your colleagues' animals, and you want to be able to classify them, so you can make attractive collages of them for your company retreat. Unfortunately you've developed cat/ dog/ spider- blindness and can't classify the critters. Oh no! Fortunately this is 2024, so you can enlist the help of AI. We've provided you with a command called 'classify', and there are a bunch of animal pictures in the 'data' folder. You're going to:

 - Use a popular classification tool to assign critters to classes based on a dictionary of labels you provide.
 - Make a collage of the critters for each class.
 - Combine the collages to create one glorious critter cornucopia.

We're going to do this in 3 different ways of decreasing manual intervention, showing you the power of Nextflow. 

The main command we'll be using looks like:

```
classify --image PICTURE --labels 'LABELS' > out.txt
```

Where 'PICTURE' is the image file, and LABELS is the set of classes to which you want to assign the images.

## Approach 1: in the beginning there was just the command line

### Label each image

All bioinformaticians (and other data scientists) start this way: running commands one-by-one on the command line, and it works. We'll walk through the process here.

Change to the 'cli' directory by typing the following into the terminal:

```
cd activity/cli
```

Now, try to assign an image to a class, for example: 

```
classify --image data/rain-ready.png --labels 'cat,dog,cute dog'
```

You don't have to use those labels. If you'd like to play try 'cat,dog,zebra,crocodile', or any other set of labels. Whatever the label, copy the image to a new folder named the same way. For example, if the above command returned 'dog', then do:

```bash
mkdir dog
cp data/rain-ready.png dog
```

Do the same for all the images under `data`, making sure to use the same set of labels each time. 

### Make a collage for each class

Now you should have directories labelled by critter. For example a 'dog' directory with all the images that were labelled as 'dog', a 'cat' directory with all the images labelled as 'cat' etc (or whatever labels you used).

Start by making a 'collages' directory:

```bash
mkdir collages
```

You can now make a collage for each collection of critters using commands like the below. For 'dog' you might do:

```
montage -geometry 80 -tile 4x dogs/* tmp.png
montage -label '$label' tmp.png -geometry +0+0 -background Gold collages/dog.png
rm tmp.png
```

### Combine the collages

You should now have a set of collages, one for each critter type, in the `collages` directory.

All you need to do now is combine them, which which you can do with the following command:

```bash
montage -geometry +0+0 -tile 1x collages/* collage_all.png
```

You can download that from the GitPod user interface. What do you think? Try to answer the following questions for yourself:

 * What if there were 1000 images? Would you be happy doing that for all of them?
 * Even if you did, are you confident you would get the commands right if you had to type them out 100 times again?
 * How annoyed would you be if you lost your place half way through and had to start again?

## Approach 2: 'typing all those commands is boring': let's write some Bash

Hopefully that first approach wasn't too tricky, but it was a bit boring wasn't it? Let's exercise our [3 virtues](https://thethreevirtues.com/) and try to make life easier for ourselves. 

Change to the 'bash' activity diretory:

```bash
cd ../bash
```

Bash allows you to do some scripting to automate this process, so let's try that. We've provided a script for you [here](activitiy/bash/make_collage.sh).

## Approach 3: can't we automate everything? Enter Nextflow
