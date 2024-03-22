# Part 4. Critter classification on Seqera Platform

## Introduction to Running a Nextflow Workflow on Seqera Platform

Transitioning from crafting our classification steps into Nextflow and running locally, we're now stepping up to Seqera Platform, making our critter-classification project even more collaborative and accessible. This move isn't just about scaling up; it's about bringing collaborators into our fun classification journey, enabling anyone, anywhere, to classify their favorite critters using the same parameters. It's also about effortlessly handling data in the Cloud, without getting tangled in the technicalities, and keeping an eye on costs, ensuring our animal adventure stays budget-friendly. Nextflow Tower is here to make sharing, collaborating, and cloud computing a breeze for our critter-classifying escapades.

## Running the workflow on Seqera Platform

## Step 1: Log in to Seqera Platform

Head over to our beloved [Seqera Platform landing page](cloud.seqera.io) and log in with your Seqera GSuite account. Upon logging in, you will have access to Workspace called `nf-training` under the `seqeralabs` organization.

An AWS Batch Compute Environment with valid credentials has been already setup for you to use.

<!-- TODO: screenshot here maybe -->

## Step 2: Launch the workflow

If you go to the Launchpad in the `seqeralabs/nf-training` workspace, you'll see a pipeline pre-configured on the Launchpad called `nf-training`. You can click on the 'Launch' button to start configuring your run.

As you are brought to the 'Pipeline Parameters' page, you will have the option of specifying which images you can use for classification, based on the `params.input` parameter. In the previous steps, we were using the few images that were provided for you. Let's make this more interesting...

## Step 3: Use data on cloud storage as input

In a valiant effort akin to treasure hunting through the digital realms, we've meticulously combed through the delightful array of critter images found in Seqera's #social-pet-pics channel. These gems have now found a new home in an AWS S3 bucket, eagerly awaiting their moment of fame to be classified into 'cat' or 'dog' versus 'cute cat' and 'cute dog'.

Your goal will be to classify the images in this bucket, in the Cloud.

In the 'input' field on the Parameters page, you can specify the following path to the bucket:

```
s3://seqera-development-permanent-bucket/scidev/petpics
```

## Step 4: Specify your prompts for classification

Similar to what you had done before, specify a list of labels you want to use to classify the images. For example, 'dog,cat,cute dog,beautiful dog'.

## Step 5: Specify where you results will be saved

In our previous examples, we were saving our results of the classification into a local folder called `results/`. On the Cloud however, we want to save our results to a blob storage bucket, that we can then also share with our colleagues.

In the 'outdir' field on the Parameters page, you can specify the following path to an output bucket and prefix:

```
s3://scidev-eu-west-1/nf-training/<your_name>/results
```

## Step 6: Launch!

Now you have specified which images your workflow will attempt to classify, indicated which labels on which you will perform classification, and specified where your results will live!

You can go ahead and click 'Launch'.

## Step 7: Monitor the Run

The classification on the images in this bucket will take some time as there are over >200 images to comb through but you are now successfully running a machine learning workflow in the Cloud!

## Conclusions

You've now journeyed from the simplicity of command-line commands, through the structured approach of Bash scripting, and into the expansive realm of Nextflow, mastering a suite of powerful techniques for data analysis. Each step has brought its own set of advancements: from the manual specificity of the command line, we moved to the automated efficiency of Bash scripting, only to surpass it with Nextflow's scalability, parallelism, and reproducibility.

Nextflow has not only enabled you to create robust, adaptable workflows but also ensured that these workflows can be precisely replicated and shared, thanks to its focus on reproducibility and detailed reporting. The leap to running these workflows on Seqera Platform demonstrates the transformative power of cloud execution, enhancing your projects with unparalleled scalability and flexibility. You can now not only classify 200 images, but 500, or 1000 images!

By harnessing the Platform's management and monitoring capabilities, we've seen how tasks can transition seamlessly from local development to cloud-based execution, embodying the ultimate promise of Nextflow's portability, resumability and flexibility.

So, here's to you, the maestro of this critter classification concerto, for embracing the flow and charting a path through the digital wilderness with "Go with the Next(flow)"!
