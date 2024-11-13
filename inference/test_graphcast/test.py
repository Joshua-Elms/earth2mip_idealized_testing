import datetime
import torch
from earth2mip.networks import get_model
from earth2mip.initial_conditions import cds
from earth2mip.inference_ensemble import run_basic_inference
time_loop  = get_model("e2mip://graphcast", device="cuda:0")
data_source = cds.DataSource(time_loop.in_channel_names)
ds = run_basic_inference(time_loop, n=10, data_source=data_source, time=datetime.datetime(2018, 1, 1))
