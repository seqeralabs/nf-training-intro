# Critter classification with bare command line working 

In this section of our Nextflow tutorial, we'll explore how to run an existing classification model using OpenAI's CLIP directly from the command line, to both classify our critters and build a collage of images.

We're assuming that you are successfully in an environment where the files in this repository have been installed and the necessary software made available. Please go back and look at the environment setup in the README if that's not the case. 

The main command we'll be using looks like:

```
classify.py --image PICTURE --labels 'LABELS' > out.txt
```

Where 'PICTURE' is the image file, and LABELS is the set of classes to which you want to assign the images.

## Step 1: Label each image

Change to the 'cli' directory by typing the following into the terminal:

```
cd activity/cli
```

You should see that the images are available to you here in the `data` subdirectory:

```
ls data
```

Try to assign one of thes images to a class, for example: 

```
classify.py --image data/rain-ready.png --labels 'cat,dog,cute dog'
```

This should return a text string, telling you which of the input labels was most likely to apply.

You don't have to use those labels. If you'd like to play try 'cat,dog,zebra,crocodile', or any other set of labels. Whatever the label, copy the image to a new folder named the same way. For example, if the above command returned 'dog', then do:

```bash
mkdir dog
cp data/rain-ready.png dog
```

Do the same for all the images under `data`, making sure to use the same set of labels each time. 

## Step 2: make a collage for each class

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

## Step 3 combine the collages

You should now have a set of collages, one for each critter type, in the `collages` directory.

All you need to do now is combine them, which which you can do with the following command:

```bash
montage -geometry +0+0 -tile 1x collages/* collage_all.png
```

## Conclusions

You can download that from the GitPod user interface. What do you think? Try to answer the following questions for yourself:

 * What if there were 1000 images? Would you be happy doing that for all of them?
 * Even if you did, are you confident you would get the commands right if you had to type them out 100 times again?
 * How annoyed would you be if you lost your place half way through and had to start again?

<details>
<summary>Summary</summary>
After classifying a few images one by one, you might notice a couple of things. First, it can be quite tedious to type out or copy-paste the command repeatedly for multiple images. Secondly, this method does not scale well if we have hundreds or thousands of images to classify. Imagine having to run each image through the command line individually—it would be incredibly time-consuming and inefficient.
</details>

## Next steps

Now proceed to the next part: [Critter classification with Bash scripting](bash.md).
