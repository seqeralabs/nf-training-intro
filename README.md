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
