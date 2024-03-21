# Running Classification Locally

## Introduction to Image Classification with CLIP

In this section of our Nextflow tutorial, we'll explore how to run an existing classification model using OpenAI's CLIP directly from the command line. CLIP (Contrastive Language–Image Pre-training) is a versatile tool that can understand and classify images based on natural language descriptions. Our task? To distinguish between images of cats and dogs.

Step 1: Setting Up Your Environment
Before we dive in, you need to ensure you have all of the tools installed in your Gitpod instance. We can do this by copying and pasting the following command:

<!-- TODO -->

```console
pip install ???
```

Step 2: Running classification
To classify an image, we'll run the CLIP model from the command line. Copy and paste the following command to classify a single image:

```bash
python classify.py image1.png "cat" "dog
```

Step 3. Classify another image
We have several other images that we want to run the CLIP model on, because we are unsure of whether they are cat or dog images. We have to run the command a couple more times to see the results:

```bash
python classify.py image2.png "cat" "dog"
python classify.py image3.png "cat" "dog"
python classify.py image4.png "cat" "dog"
```

Step 4. Take a look at the results
???

After classifying a few images one by one, you might notice a couple of things. First, it can be quite tedious to type out or copy-paste the command repeatedly for multiple images. Secondly, this method does not scale well if we have hundreds or thousands of images to classify. Imagine having to run each image through the command line individually—it would be incredibly time-consuming and inefficient.

We can instead encapsulate these commands into a bash script. This will not only simplify the process of classifying multiple images but also set the stage for understanding the power of automation and scalability—key features that Nextflow enhances in more complex workflows. So, let's move forward and learn how to make our work more efficient with the use of a bash script - go to Part 2!
