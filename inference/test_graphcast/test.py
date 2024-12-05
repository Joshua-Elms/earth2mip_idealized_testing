import datetime
import torch
import dotenv
from earth2mip.networks import get_model
from earth2mip.initial_conditions import cds, get_data_source
from earth2mip.inference_ensemble import run_basic_inference

dotenv.load_dotenv(".env")

time_loop  = get_model("e2mip://graphcast", device="cuda:0")
data_source = get_data_source(
    channel_names=[], 
    netcdf="/N/slate/jmelms/projects/graphcast_IC/source-era5_date-2022-01-01_res-0.25_levels-37_steps-12.nc",
)
# data_source = cds.DataSource(time_loop.in_channel_names)
ds = run_basic_inference(time_loop, n=10, data_source=data_source, time=datetime.datetime(2018, 1, 1))
ds.to_netcdf("/N/u/jmelms/BigRed200/projects/earth2mip_idealized_testing/inference/test.nc", engine="zarr")