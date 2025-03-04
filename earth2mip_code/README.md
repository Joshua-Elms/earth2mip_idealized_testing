# HENS

This codebase is a fork of the earth2mip repository, developed by NVIDIA.  It is used to run ensemble weather forecasts with SFNO in the following two papers:

"Huge Ensembles Part II: Properties of a Huge Ensemble of Hindcasts Generated with Spherical Fourier Neural Operators" (submitted to Geoscientific Model Development)

"Huge Ensembles Part I: Design of Ensemble Weather Forecasts using Spherical Fourier Neural Operators" (submitted to Geoscientific Model development)

The license and copyright for the code for these two projects are at:
license_lbl.txt
copyright_notice.txt

-


This codebase can be adpated to run the ensemble weather forecasts.  Particular files of interest are our implementation of bred vectors for initial condition perturbations:

'earth2mip-fork/earth2mip/ensemble_utils.py'

Additionally, ensemble inference is at 

'earth2mip-fork/earth2mip/inference_ensemble.py'

## Trained ML Models

The trained ML models are available at

https://portal.nersc.gov/cfs/m4416/ 
in the `earth2mip_prod_registry` folder.  Each model package includes the learned weights of the model and additional information necessary to run the model (e.g. the input to the model is normalized by the data in 'global_means.npy' and 'global_stds.npy').

As the data is hosted on the NERSC high-performance computing facility, it may occasionally be down for maintenance.  If the link above does not work, you can check https://www.nersc.gov/live-status/motd/ to see if the data portal is up.

These model packages can be run with earth2mip: NVIDIA's model inference repository.  A dependency for running these models with earth2mip is to have modulus-makani v0.1.0 installed.

## ERA5 data

For training and running the ensemble, we use a mirror of ERA5.  The data-packing code to create this mirror is available through a fork of modulus-makani: https://zenodo.org/records/13137296 in 'modulus-makani-fork/data_process/'.  We also aim to make our full exact mirror available of the entire training dataset (1979-2016): please stay tuned for more updates.  We are looking for a permanent place to store the data.  In the meantime, NVIDIA has made a similar dataset available, but we note that their dataset does not include 2m dewpoint.  However, their dataset can be used to train data-driven weather prediction models: https://docs.nvidia.com/deeplearning/modulus/modulus-core/examples/weather/dataset_download/readme.html.  We use the hdf5 training dataset, not the zarr dataset.

We do make our exact ERA5 dataset available for inference.  We perform inference on years that were not used for training: 2018, 2020, and summer 2023. The ERA5 data for these years is available here:

`https://portal.nersc.gov/cfs/m4416/` in the `ERA5_inference_data` folder.

This data can be used to obtain initial conditions to run the ensemble.

## Running the ensemble

The necessary requirements for running the ensemble are listed in this file: earth2mip-fork/set_74ch_vars.sh

This data is available at https://portal.nersc.gov/cfs/m4416/.  You'll have to download this data to your local machine and change the paths to point to this data.

The general documentation for earth2mip is included below.  For running ensembles, we recommend setting up earth2mip inference_ensemble to work on your local compute environment (ideally using the general earth2mip documentation).  Then, you can make modifications to the earth2mip config json to run ensembles with our trained model. In particular, earth2mip requires defining a config file which sets the parameters of the ensemble.  The config files used for generating huge ensemble forecasts are at 

'earth2mip-fork/summer23_configs/*'

You can adapt these configs to suit your local directory (e.g. change the save paths) and also to run ensembles that save different variable subsets and use different days as initial conditions.  See the earth2mip documentation for more information about specifying a config for ensemble inference.

The submit script for the huge ensemble is 

'earth2mip-fork/submit_HENS_summer23.sh' . This script creates a huge (7424 member ensemble) using inference_ensemble.py mentioned above


## Scoring the ensemble: overall diagnostics

`earth2mip-fork/earth2mip/time_collection.py` is the file used to score the ensemble against the ERA5 dataset.  We score the dataset using 2018, 2020, and 2023.  This file used `inference_ensemble.py` to generate an ensemble and then uses the earth2mip scoring utils to score the ensemble.

We have our scoring ensemble script here.

This is not the right codebase for scoring extreme diagnostics. We use a different codebase for validating on extremes.

# Earth-2 MIP (Beta)

<!-- markdownlint-disable -->
[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![GitHub](https://img.shields.io/github/license/NVIDIA/earth2mip)](https://github.com/NVIDIA/earth2mip/blob/master/LICENSE.txt)
[![Documentstion](https://img.shields.io/website?up_message=online&up_color=green&down_message=down&down_color=red&url=https%3A%2F%2Fnvidia.github.io%2Fearth2mip%2F&label=docs)](https://nvidia.github.io/earth2mip/)
[![codecov](https://codecov.io/gh/NickGeneva/earth2mip/graph/badge.svg?token=0PDBMHCH2C)](https://codecov.io/gh/NickGeneva/earth2mip/tree/main)
[![Python versionm: 3.10, 3.11, 3.12](https://img.shields.io/badge/python-3.10%20%7C%203.11%20%7C%203.12-blue
)](https://github.com/NVIDIA/earth2mip)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)
<!-- markdownlint-enable -->

Earth-2 Model Intercomparison Project (MIP) is a Python based AI framework that
enables climate researchers and scientists to explore and experiment with the use of AI
models for weather and climate.
It provides reference workflows for understanding how AI models capture the physics of
the Earth's atmosphere and how they can work with traditional numerical weather
forecasting models.
For instance, the repo provides a uniform interface for running inference using
pre-trained model checkpoints and scoring the skill of such models using certain
standard metrics.
This repository is meant to facilitate the weather and climate community to come up with
good reference baseline of events to test the models against and to use with a variety
of data sources.

## Installation

Earth-2 MIP will be installable on PyPi upon general release.
In the mean time, one can install from source:

```bash
git clone git@github.com:NVIDIA/earth2mip.git

cd earth2mip && pip install .
```

See [installation documentation](https://nvidia.github.io/earth2mip/userguide/install.html)
for more details and other options.

## Getting Started

Earth-2 MIP provides a set of examples which can be viewed on the [examples documentation](https://nvidia.github.io/earth2mip/examples/index.html)
page which can be used to get started with various workflows.
These examples can be downloaded both as Jupyer Notebooks and Python scripts.
The source Python scripts can be found in the [examples](./examples/) folders.

### Basic Inference

Earth-2 MIP provides high-level APIs for running inference with AI models.
For example, the following can be used to run Pangu weather using an initial state from
the climate data store (CDS):

```bash
python
>>> import datetime
>>> from earth2mip.networks import get_model
>>> from earth2mip.initial_conditions import cds
>>> from earth2mip.inference_ensemble import run_basic_inference
>>> time_loop  = get_model("e2mip://dlwp", device="cuda:0")
>>> data_source = cds.DataSource(time_loop.in_channel_names)
>>> ds = run_basic_inference(time_loop, n=10, data_source=data_source, time=datetime.datetime(2018, 1, 1))
>>> ds.chunk()
<xarray.DataArray (time: 11, history: 1, channel: 69, lat: 721, lon: 1440)>
dask.array<xarray-<this-array>, shape=(11, 1, 69, 721, 1440), dtype=float32, chunksize=(11, 1, 69, 721, 1440), chunktype=numpy.ndarray>
Coordinates:
  * lon      (lon) float32 0.0 0.25 0.5 0.75 1.0 ... 359.0 359.2 359.5 359.8
  * lat      (lat) float32 90.0 89.75 89.5 89.25 ... -89.25 -89.5 -89.75 -90.0
  * time     (time) datetime64[ns] 2018-01-01 ... 2018-01-03T12:00:00
  * channel  (channel) <U5 'z1000' 'z925' 'z850' 'z700' ... 'u10m' 'v10m' 't2m'
Dimensions without coordinates: history
```

And you can get ACC/RMSE like this:
```
>>> from earth2mip.inference_medium_range import score_deterministic
>>> import numpy as np
>>> scores = score_deterministic(time_loop,
    data_source=data_source,
    n=10,
    initial_times=[datetime.datetime(2018, 1, 1)],
    # fill in zeros for time-mean, will typically be grabbed from data.
    time_mean=np.zeros((7, 721, 1440))
)
>>> scores
<xarray.Dataset>
Dimensions:        (lead_time: 11, channel: 7, initial_time: 1)
Coordinates:
  * lead_time      (lead_time) timedelta64[ns] 0 days 00:00:00 ... 5 days 00:...
  * channel        (channel) <U5 't850' 'z1000' 'z700' ... 'z300' 'tcwv' 't2m'
Dimensions without coordinates: initial_time
Data variables:
    acc            (lead_time, channel) float64 1.0 1.0 1.0 ... 0.9686 0.9999
    rmse           (lead_time, channel) float64 0.0 2.469e-05 0.0 ... 7.07 2.998
    initial_times  (initial_time) datetime64[ns] 2018-01-01
>>> scores.rmse.sel(channel='z500')
<xarray.DataArray 'rmse' (lead_time: 11)>
array([  0.        , 150.83014446, 212.07880612, 304.98592282,
       381.36510987, 453.31516952, 506.01464974, 537.11092269,
       564.79603347, 557.22871627, 586.44691243])
Coordinates:
  * lead_time  (lead_time) timedelta64[ns] 0 days 00:00:00 ... 5 days 00:00:00
    channel    <U5 'z500'
```

### Supported Models

These notebooks illustrate how-to-use with a few models and this can serve as reference
to bring in your own checkpoint as long as it's compatible. There may be additional work
to make it compatible with Earth-2 MIP.
Earth-2 MIP leverages the model zoo in [Modulus](https://github.com/NVIDIA/modulus) to
provide a reference set of base-line models.
The goal is to enable to community to grow this collection of models as shown in the
table below.

<!-- markdownlint-disable -->
| ID | Model | Architecture | Type | Reference | Source | Size |
|:-----:|:-----:|:-------------------------------------------:|:--------------:|:---------:|:-------:|:---:|
| fcn | FourCastNet | Adaptive Fourier Neural Operator  | global weather | [Arxiv](https://arxiv.org/abs/2202.11214)   | [modulus](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/modulus/models/modulus_fcn) | 300Mb |
| dlwp |  Deep Learning Weather Prediction  |  Convolutional Encoder-Decoder | global weather |   [AGU](https://doi.org/10.1029/2020MS002109)   | [modulus](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/modulus/models/modulus_dlwp_cubesphere) |  50Mb |
| pangu | Pangu Weather (Hierarchical 6 + 24 hr)  |  Vision Transformer | global weather |  [Nature](https://doi.org/10.1038/s41586-023-06185-3) | onnx | 2Gb |
| pangu_6 | Pangu Weather 6hr Model  |  Vision Transformer | global weather |  [Nature](https://doi.org/10.1038/s41586-023-06185-3) | onnx | 1Gb |
| pangu_24 | Pangu Weather 24hr Model |  Vision Transformer | global weather |  [Nature](https://doi.org/10.1038/s41586-023-06185-3) | onnx | 1Gb |
| fcnv2_sm |  FourCastNet v2 | Spherical Harmonics Fourier Neural Operator | global weather |  [Arxiv](https://arxiv.org/abs/2306.03838)  | [modulus](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/modulus/models/modulus_fcnv2_sm) | 3.5Gb |
| graphcast |  Graphcast, 37 levels, 0.25 deg | Graph neural network | global weather |  [Science](https://www.science.org/doi/10.1126/science.adi2336)  | [github](https://github.com/google-deepmind/graphcast) | 145MB |
| graphcast_small |  Graphcast, 13 levels, 1 deg | Graph neural network | global weather |  [Science](https://www.science.org/doi/10.1126/science.adi2336)  | [github](https://github.com/google-deepmind/graphcast) | 144MB |
| graphcast_operational |  Graphcast, 13 levels, 0.25 deg| Graph neural network | global weather |  [Science](https://www.science.org/doi/10.1126/science.adi2336)  | [github](https://github.com/google-deepmind/graphcast) | 144MB |
| precipitation_afno | FourCastNet Precipitation | Adaptive Fourier Neural Operator  | diagnostic | [Arxiv](https://arxiv.org/abs/2202.11214)   | [modulus](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/modulus/models/modulus_diagnostics) | 300Mb |
| climatenet | ClimateNet Segmentation Model | Convolutional Neural Network | diagnostic | [GMD](https://doi.org/10.5194/gmd-14-107-2021)   | [modulus](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/modulus/models/modulus_diagnostics) | 2Mb |
<!-- markdownlint-enable -->

\* = coming soon

Some models require additional dependencies not installed by default.
Refer to the [installation instructions](https://nvidia.github.io/earth2mip/userguide/install.html)
for details.

*Note* : Each model checkpoint may have its own unique license. We encourage users to
familiarize themselves with each to understand implications for their particular use
case.

We want to integrate your model into the scoreboard to show the community!
The best way to do this is via [NVIDIA Modulus](https://github.com/NVIDIA/modulus).
You can contribute your model (both the training code as well as model checkpoint) and
we can ensure that it is maintained as part of the reference set.

## Contributing

Earth-2 MIP is an open source collaboration and its success is rooted in community
contribution to further the field.
Thank you for contributing to the project so others can build on your contribution.
For guidance on making a contribution to Earth-2 MIP, please refer to the
[contributing guidelines](./CONTRIBUTING.md).

## More About Earth-2 MIP

This work is inspired to facilitate similar engagements between teams here at
NVIDIA - the ML experts developing new models and the domain experts in Climate science
evaluating the skill of such models.
For instance, often necessary input data such as normalization constants and
hyperparameter values are not packaged alongside the model weights.
Every model typically implements a slightly different interface. Scoring routines are
specific to the model being scored and may not be consistent across groups.

Earth-2 MIP addresses  these challenges and bridges the gap between the domain experts
who most often are assessing ML models, and the ML experts producing them.
Compared to other projects in this space, Earth-2 MIP focuses on scoring models
on-the-fly.
It has python APIs suitable for rapid iteration in a jupyter book, CLIs for scoring
models distributed over many GPUs, and a flexible
plugin framework that allows anyone to use their own ML models.
More importantly Earth-2 MIP aspires to facilitate exploration and collaboration within
the climate research community to evaluate the potential of AI models in climate and
weather simulations.

Please see the [documentation page](https://nvidia.github.io/earth2mip/) for in depth
information about Earth-2 MIP, functionality, APIs, etc.

## Communication

- Github Discussions: Discuss new ideas, model integration, support etc.
- GitHub Issues: Bug reports, feature requests, install issues, etc.

## License

Earth-2 MIP is provided under the Apache License 2.0, please see
[LICENSE.txt](./LICENSE.txt) for full license text.

### Additional Resources

- [Earth-2 Website](https://www.nvidia.com/en-us/high-performance-computing/earth-2/)
- [NVIDIA Modulus](https://github.com/NVIDIA/modulus)
