# Tabular Transformers for Modeling Multivariate Time Series

This repository provides the pytorch source code, and data for tabular transformers (TabFormer). Details are described in the paper [Tabular Transformers for Modeling Multivariate Time Series](http://arxiv.org/abs/2011.01843 ), to be presented at ICASSP 2021.

#### Summary
* Modules for hierarchical transformers for tabular data
* A synthetic credit card transaction dataset
* Modified Adaptive Softmax for handling masking
* Modified _DataCollatorForLanguageModeling_ for tabular data
* The modules are built within transformers from HuggingFace 🤗. (HuggingFace is ❤️)
---
### Requirements
* Python (3.7)
* Pytorch (1.6.0)
* HuggingFace / Transformer (3.2.0)
* scikit-learn (0.23.2)
* Pandas (1.1.2)

(X) represents the versions which code is tested on.

These can be installed using yaml by running : 
```
pip3 install -r requirements.txt
```
---

### Credit Card Transaction Dataset

The synthetic credit card transaction dataset is provided in [./data/credit_card](/data/credit_card/). There are 24M records with 12 fields.
You would need git-lfs to access the data. If you are facing issue related to LFS bandwidth, you can use this [direct link](https://ibm.box.com/v/tabformer-data) to access the data. You can then ignore git-lfs files by prefixing `GIT_LFS_SKIP_SMUDGE=1` to the `git clone ..` command.

![figure](./misc/cc_trans_dataset.png)

---

### PRSA Dataset
For PRSA dataset, one have to download the PRSA dataset from [Kaggle](https://www.kaggle.com/sid321axn/beijing-multisite-airquality-data-set) and place them in [./data/card](/data/card/) directory.

---

### Tabular BERT
To train a tabular BERT model on credit card transaction or PRSA dataset run :
```
$ python main.py --do_train --mlm --field_ce --lm_type bert \
                 --field_hs 64 --data_type [prsa/card] \
                 --output_dir [output_dir]
```


### Tabular GPT2
To train a tabular GPT2 model on credit card transactions for a particular _user-id_ :
```

$ python main.py --do_train --lm_type gpt2 --field_ce --flatten --data_type card \
                 --data_root [path_to_data] --user_ids [user-id] \
                 --output_dir [output_dir]
    
```

Description of some options (more can be found in _`args.py`_):
* `--data_type` choices are `prsa` and `card` for Beijing PM2.5 dataset and credit-card transaction dataset respecitively. 
* `--mlm` for masked language model; option for transformer trainer for BERT
* `--field_hs` hidden size for field level transformer
* `--lm_type` choices from `bert` and `gpt2`
* `--user_ids` option to pick only transacations from particular user ids.
---

### Citation

```
@inproceedings{padhi2021tabular,
  title={Tabular transformers for modeling multivariate time series},
  author={Padhi, Inkit and Schiff, Yair and Melnyk, Igor and Rigotti, Mattia and Mroueh, Youssef and Dognin, Pierre and Ross, Jerret and Nair, Ravi and Altman, Erik},
  booktitle={ICASSP 2021-2021 IEEE International Conference on Acoustics, Speech and Signal Processing (ICASSP)},
  pages={3565--3569},
  year={2021},
  organization={IEEE},
  url={https://ieeexplore.ieee.org/document/9414142}
}
```

## Given three churn datasets, which will perform best?
### - ONE model on ONE dataset, OR
### - THREE models on THREE cuts of the data.


#### More generally:

Given `n` datasets of "similar"-problem-different-environment data, what is the
relationship of number of models and model performance.

TODO: Image of one dataset by itself, n datasets together, all in different colors.

Though, for this hack, I'm going to try to build a  [transformer][https://arxiv.org/abs/1706.03762]. 

Transformers have been getting a lot of hype because of [Chatgpt](https://openai.com/blog/chatgpt/)
and Tesla incorporating them.

And, I think maybe a random forest for the n models. And `n` will be 3. Just because
they are wicked easy.

The null hypothesis is that one model could not surpass the predictive power of three models
on three cuts of "similar"-problem-different-environment data.

Of course we could include things like; size of the data, "similarness", etc. But,
for the sake of simplicity, we will consider ANY size and degree of "similarness".

I will try for proof my contradiction. And thus, I will try to make one really dope
model (and try to make the other ones pretty good to).

This is in no way actual research! But maybe on the way to research!


#### The Approach

- Find three open source transaction datasets.
- Find [pre-trained model weights](https://pytorch.org/hub/) or my own from training TabFormer.
- White board the model architecture.
- Recreate data, model, evaluate loop from personal template.
- Model the code base.
- Code it up.


##### Thinking through the codebase some..

- [] requirements.txt
- [] setup.py
- [] bin directory for cli
- [] research
  - [] EDA notebooks
-   [] package directory
   - [] data cleaner script
  - [] model training for one
  - [] model training for three
  - [] optional model vizualization
  - [] register cli


###### CLI functionality notes:

- Just the models, potentially with/without vizualization. 
- [] Swith over to click.

``` bash
run_model neo --train_iters 1000 --a .04738 --no_viz
```

``` bash
run_model tts train_iters 1000 --a .04738 --viz
```

###### Bash scripts
- [] Bashscripts to move and delete checkpoints.
- [] Simple bash script to install the dependencies or docker image.


###### Model script functionality

- [] Learn transformer.
- [] Learn transfer learning.
- [] Print out state of model at some intervals in case there is an exception.
- [] Design models to be able to take that state and start again.
- [] Need a directory `/data` to read from.
- [] Need a directory `/output` to write to.
- [] Output directory should create folders based on time stamp and custom input.
  - v1, v2 naming convention is good.
  - should drop model params in a config.
- [] May do some parts in rust for speed bonus. We'll see.
- [] Makes sense to have separate training loops.
- [] Put a cli on the model scripts to accept arbitrary arguments.
- [] Random seed in each script.
- [] A way to stop the model.
- [X] Checkout some software tuning for the transformer.
  - https://www.microsoft.com/en-us/research/blog/%C2%B5transfer-a-technique-for-hyperparameter-tuning-of-enormous-neural-networks/
  - https://developer.nvidia.com/blog/fast-fine-tuning-of-ai-transformers-using-rapids-machine-learning/
- Since the models will be massively parallelized, they can be run efficeintly
  in a sequential manner. Ie; one after another.
  - Random forest I will use njobs parameter in sci-kit learn class to parallelize
    on cores.
  - Transformer will run in batches on GPU. 
- The three stooges will have to take separate arguments, so I'll args/kwargs.

###### Visuals.
- [] Optional training vizualizations of the transformer.
  - https://www.microsoft.com/en-us/research/blog/%C2%B5transfer-a-technique-for-hyperparameter-tuning-of-enormous-neural-networks/
  - https://github.com/3b1b/manim
  - https://github.com/vivek3141/dl-visualization
- [] Or could be the simple loss over time. Ref: Stanford ML Class.

###### Data


##### Interesting finds.
- https://medium.com/distributed-computing-with-ray/hyperparameter-optimization-for-transformers-a-guide-c4e32c6c989b
