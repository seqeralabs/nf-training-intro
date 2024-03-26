# Part 4: Critter classification on Seqera Platform

In this exercise, we will transition from running Nextflow locally to AWS Batch via the Seqera Platform which will make our critter classification project even more collaborative and accessible. This move is not just about scaling up; it is about bringing collaborators into our fun classification journey, enabling anyone, anywhere, to classify their favorite critters using the same parameters. It is also about effortlessly handling data in the Cloud, without getting tangled in the technicalitie. Seqera Platform is here to make sharing, collaborating, and cloud computing a breeze for our critter-classifying escapades.

## Step 1: Log in to Seqera Platform

Log in to the [Seqera Platform](https://seqera.io/platform/) with your preferred credentials. After logging in, you should have access to a Workspace called `nf-training` under the `seqeralabs` organization ([link](https://cloud.seqera.io/orgs/seqeralabs/workspaces/nf-training)). An AWS Batch Compute Environment has already been set up for you to use to run the classification workflow so you don't need to worry about the minutiae.

## Step 2: Find the critters

In a valiant effort akin to treasure hunting through the digital realms, we have meticulously combed through the delightful array of critter images found in Seqera's #social-pet-pics Slack channel. These gems have now found a new home in an AWS S3 bucket, eagerly awaiting their moment of fame to be classified into 'cat' or 'dog' versus 'cute_cat' or 'cute_dog'.

Your mission, should you choose to accept will be to classify the images in this Cloud bucket.

In previous steps, you were able to view the image files being used as input directly in your GitPod environment, because they were stored locally, on the same machine. In this case, these files are stored in the Cloud which means our current machine cannot access them directly. However, you can use the Data Explorer feature in the Platform to look at the files directly in Cloud storage without having to log into the AWS Console or use a command-line tool:

- Click on the 'Data Explorer' tab
- Click on the AWS bucket named `s3://seqera-development-permanent-bucket`
- Click on the `scidev/` folder
- Click on the `petpics/` folder
- Click on any one of the jpeg files to preview the images

## Step 3: Pipeline set-up

If you go to the Launchpad in the `seqeralabs/nf-training` workspace, you will see a pipeline called `nf-training` that has been pre-configured to run on AWS Batch via the Seqera Platform. It was created with the following settings:

![Launchpad configuration](assets/pipeline-launchpad-config.png)

We just have to specify the AWS Batch Compute Environment where the pipeline will be run by default, the URL for the GitHub repository for the pipeline and the version or revision we want to run.

## Step 4: Running the pipeline

In the previous sections of the workshop, we only used 8 images in the GitPod environment. Let's make this more interesting by running the pipeline on over 200 critter images located in the Cloud!!

Now that we know where the input data is located we can run the pipeline. Click on the 'Launch' button for the pipeline in the Launchpad which will bring you to the 'Pipeline Parameters' page. You will have the option of specifying the same parameters used on the command-line with Nextflow but now via an interactive user interface in the Seqera Platform.

### Input

In the 'input' field on the Parameters page, you can click on the 'Browse' button and use the Data Explorer to choose the `s3://seqera-development-permanent-bucket/scidev/petpics` folder, and include the `*` wildcard character at the end of the path. This will tell Nextflow to use all of the images in this folder.

```
s3://seqera-development-permanent-bucket/scidev/petpics/*
```

### Labels

Similar to what you had done before, specify a list of labels in the 'prompts' field that you want to use to classify the images. For example, 'cat,dog,cute_dog'. Make sure to separate each label with a comma.

### Output

In our previous examples, we saved the results of the classification in a local folder called `results/` in our GitPod environment. However, now that we are running the pipeline on AWS, we want to save our results to a remote storage bucket so that we can also share the results with our colleagues.

In the 'outdir' field of the Parameters page, you can specify the path below by replacing the `<YOUR_NAME>` field with your actual name (please refrain from impersonating others :shakefist:):

```
s3://scidev-eu-west-1/nf-training/<YOUR_NAME>/results
```

## Step 5: Launch!

Now that you have specified which images to use as input to your workflow, indicated which labels to use to perform the classification, and specified where your results will live, click on the big 'Launch' button! The classification of the images in this bucket will take some time as there are over >200 images to comb through but you are now successfully running a machine learning workflow in the Cloud!

## Step 6: Inspect the Results

- Click on the Run
- Navigate to the 'Reports' tab
- Click on the final composite image,

You will be able download the image directly from the Platform - all while still storing it in the Cloud and not having to worry about using up storage locally. You will notice that the 'Path' for the collage file will point to the bucket path that you had specified in Step 4 as your output directory in the `outdir` box.

## Step 7: Inspect the Run details

At the top of the page for your Run, in the 'Parameters' and 'Configuration' tabs, you will be able to see the exact pipeline parameters and Nextflow configuration that was used, respectively. More specifically, in the 'Parameters' tab, you will be able to see which prompts or labels were used for classification, which inputs were specified, and where the results are saved. This helps reproduce results from a previous run, or from a colleague's run.

![alt text](assets/run-parameters.png)

In earlier sections of this workshop, we were familiarized with the specific commands executed for each step of the workflow, along with the containers that were used to provide the necessary software. Wondering how to access this information on the Platform?

Navigate to the bottom of the Run page until you reach the 'Tasks' table.

![alt text](assets/task-table.png)

Select any task listed here to open the 'Task Details' window. Here is what you will find:

![alt text](assets/task-details.png)

- 'Command': This shows the precise command that was executed for the task, reminiscent of the manual command-line executions you performed in Part 1.
- 'Container': Identifies the container image that executed the command. This harks back to Part 3, where we assigned container images to our Nextflow workflow processes using the `container` declaration.

Additionally, you will discover specifics about the 'machineType' or virtual machine utilized for the task, alongside the resources consumed, such as memory, CPUs, and disk space. Having access to such comprehensive details while running pipelines in the Cloud is crucial. It helps us gauge our Cloud resource utilization, aiming for cost-efficiency without compromising on the limitless compute and storage capabilities that the Cloud offers.

## Summary

You have now completed your journey from using the command-line to running Nextflow workflows on the Seqera Platform. Each step has brought it's own set of advancements: from manually specifying commands on the command-line, the automation efficiency of Bash scripting, and then culminating in using Nextflow's scalability, parallelism, and reproducibility.

More specifically, Nextflow allows us to achieve the following:

- **Scalability**: Nextflow allows workflows to automatically scale across multiple computing environments, from a single GitPod environment to high-performance computing clusters and Cloud environments with minimal manual configuration.
- **Parallelism**: By decomposing a workflow into smaller, independent tasks, Nextflow can execute these tasks in parallel, significantly speeding up the overall process.
- **Reproducibility**: Nextflow ensures reproducibility by encapsulating each task in containers, like Docker, which packages all necessary software and dependencies. This means that workflows can be rerun under the same conditions, even on different systems and produce the same results e.g. GitPod, AWS, Microsoft Azure.
- **Resumability**: Workflows in Nextflow can be paused and resumed at any point without rerunning completed tasks.
- **Reporting**: Nextflow provides detailed reports and logs for each workflow execution, including metrics on resource utilization, task execution times, and success/failure statuses. Seqera Platform additionally allows us to view the results of our pipeline quickly and provides insight into the workflow's performance and aids in troubleshooting and optimization.
- **Flexibility**: Nextflow supports flexibility in execution platforms (local, cloud, HPC), as well as programming languages (Python scripts like `classify.py`, R scripts, Bash) making it highly adaptable to different computing needs.

Nextflow has not only enabled you to create robust, adaptable workflows but also ensured that these workflows can be precisely replicated and shared, thanks to its focus on reproducibility and detailed reporting. The leap to running these workflows on Seqera Platform demonstrates the transformative power of Cloud execution, enhancing your projects with unparalleled scalability and flexibility. You can now not only classify 200 images, but 500, or 10000000 images!

By harnessing the Platform's management and monitoring capabilities, we have seen how tasks can transition seamlessly from local development to Cloud-based execution, embodying the ultimate promise of Nextflow's portability, resumability, and flexibility.

So, here's to you, the maestro of this critter classification concerto, for embracing the flow and charting a path through the digital wilderness with "Go with the (Next)flow"!
