# Nextflow: Go with the Flow!

**Welcome to our introductory session on Nextflow - Go with the Next(flow)!**

Nextflow is a powerful workflow language designed to streamline complex computational workflows, often used in fields like bioinformatics. Our goal today is not to transform you into overnight coding experts or bioinformatics scientists. Instead, we aim to bridge the understanding between our team and the users who rely on Nextflow.

By the end of this session, you'll grasp the essentials: why Nextflow is a game-changer in managing large-scale data analysis and how it empowers our customers to achieve remarkable scientific breakthroughs with efficiency and flexibility. More specifically, this session will highlight key capabilities of Nextflow:

- Scalability
- Parallelism
- Reproducibility
- Resumability
- Reporting
- Flexibility

This knowledge will enhance your ability to connect with our customers, addressing their needs and inquiries with greater empathy and insight.

## Environment setup

For this workshop we're going to be using a tool called 'GitPod', which provides us with a ready-made software environment to play in. You will need a GitHub account, so if you don't have one, go to [GitHub](https://github.com/) and create on for yourself.

### Browser plugin

It will make things easier for you if you have a browser extension to provide easier access to GitPod. Go [here](https://www.gitpod.io/docs/configure/user-settings/browser-extension) and follow the link to install the extension for your preferred browser. Restart your browser if required.

### Start the GitPod environment

Now, from this repository, you should see a green button with a funny-shaped 'G', to the right of the 'code' button. Click that, follow any prompts, wait, and you should get a GitPod workspace with all the right things installed.

If you're not used to a command line environment, don't worry, you'll just be copying commands to follow along. But you can do things like:

```bash
cd data # Change directory
ls      # List all the image files
cd ..   # Go back up a directory
```

## Our test case

We've intentionally picked a test case quite different to the usual workloads, to make the transferability of the concepts clear, using the technology of the day.

Here's the scenario. You've been given a set of pictures of your colleagues' animals, and you want to be able to classify them, so you can make attractive collages of them for your company retreat. Unfortunately you've developed cat/ dog/ spider- blindness and can't 'classify the critters'. Fortunately this is 2024, so you can enlist the help of AI. 

In the different sections of this tutorial, we'll explore how to run an existing classification model using OpenAI's CLIP. CLIP (Contrastive Language–Image Pre-training) is a versatile tool that can understand and classify images based on natural language descriptions. 

We've provided you with a command called 'classify.py', which is a wrapper around CLIP, and there are a bunch of animal pictures in the 'data' folder. You're going to:

 - Use a popular classification tool to assign critters to classes based on a dictionary of labels you provide.
 - Make a collage of the critters for each class.
 - Combine the collages to create one glorious critter cornucopia.

We're going to do this in 3 different ways of decreasing manual intervention, showing you the power of Nextflow. Please work through the following:

 * [Critter classification with bare command line working](docs/cli.md)
 * [Critter classification with Bash scripting](docs/bash.md)
 * [Critter classification with Nextlfow](docs/nextflow.md)
