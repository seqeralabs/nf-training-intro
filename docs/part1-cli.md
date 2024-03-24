# Part 1. Critter classification with bare command-line

## What is the command-line?

The command-line is like a magic wand for your computer, allowing you to perform tasks quickly and directly through text commands, much like having a chat with your machine. While it may seem daunting at first glance, its a simple, text-only interface, and incredibly powerful tool that offers a direct way to communicate with and control your computer.

In this section of our Nextflow tutorial, we'll explore how to run an existing classification model using OpenAI's CLIP directly from the command-line, to both classify our critters and build a collage of images.

We're assuming that you are successfully in an environment where the files in this repository have been installed and the necessary software made available. Please go back and look at the environment setup in the [README](../README.md#environment-setup) if that's not the case.

The main command we'll be using looks like this:

```bash
classify.py --image PICTURE --labels 'LABELS' > out.txt
```

Let's break this down:

1. `classify.py` is the command we will use to run the classification model
2. `--image PICTURE` specifies the image file we would like to classify as input
3. `--labels 'LABELS'` is the set of classifiers we want to assign to the images
4. `> out.txt` allows us to save the results or output of the classification into a file we can read later.

Now we can get started!

## Step 1: Label each image

First, let's take a look at the images available to us.

Run this command to see the directory structure:

```bash
ls
```

Change to the `/cli` directory by typing the following into the terminal:

```bash
cd activity/cli
```

You should see that the images are available to you here in the `data` subdirectory:

```bash
ls data
```

Now that you understand the directories with images, you can now run the classification with the images in `data/`.

Try to assign one of these images to a class, for example:

```
classify.py --image data/rain-ready.png --labels 'cat,dog,cute dog'
```

This should return a text output onto the command-line, telling you which of the input labels was most likely to apply to the picture we specified as input.

We are not limited to the labels above. If you'd like to, play with specifying `'cat,dog,zebra,crocodile'`, or any other set of labels. Whatever the label, copy the image to a new folder named the same way. For example, if the above command returned `'dog'`, then do:

```bash
mkdir dog               # Create a new folder
```

```bash
cp data/rain-ready.png dog  # Copy the image into the new folder
```

Do the same for all the images under `data`, making sure to use the same set of labels each time.

## Step 2: Make a collage for each class

Now you should have directories labelled by critter. For example a `dog/` directory with all the images that were labelled as 'dog', a `cat/` directory with all the images labelled as 'cat', etc (dependent on whatever labels you used).

Start by making a `collages` directory. By now you should know the command to create a new directory:

```bash
mkdir collages
```

You can now make a collage for each collection of critters using commands like the below. For 'dog' you might first run:

```bash
montage -geometry 80 -tile 4x dogs/* tmp.png
```

This will make sure our images in the collage are of uniform size, arranged in a 4x4 grid pattern, and that we want to use all images in the `dogs/` directory.

After that, you can run:

```bash
montage -label '$label' tmp.png -geometry +0+0 -background Gold collages/dog.png
rm tmp.png
```

This will add a label to the collage, adjust the size of the frame around the collage, specify a background colour, and clean up any intermediate images we don't want to keep.

## Step 3: Combine the collages

You should now have a set of collages, one for each critter type, in the `collages/` directory.

All you need to do now is combine them, which you can do with the following command:

```bash
montage -geometry +0+0 -tile 1x collages/* collage_all.png
```

You can download that final image from the GitPod user interface by right clicking on the `collage_all.png` and clicking 'Download'.

Take a look - what do you think?

## Conclusions

Try to answer the following questions for yourself:

- What if there were 1000 images? Would you be happy doing the above for all of them?
- Even if you did, are you confident you would get the commands right, if you had to type them out 100 times again?
- How annoyed would you be if you had lost your place half way through and had to start again?

<details>
<summary>Summary</summary>
After classifying a few images one by one, you might notice a couple of things. First, it can be quite tedious to type out or copy-paste the command repeatedly for multiple images. Secondly, this method does not scale well if we have hundreds or thousands of images to classify. Imagine having to run each image through the command-line individually—it would be incredibly time-consuming and inefficient.
</details>

## Next steps

We can instead encapsulate these commands into a script. This will not only simplify the process of classifying multiple images but also set the stage for understanding the power of automation and scalability—key features that Nextflow enhances in more complex workflows. Now proceed to the next part: [Part 2: Critter classification with Bash scripting](part2-bash.md).
