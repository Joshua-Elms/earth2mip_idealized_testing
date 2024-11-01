export MODEL_REGISTRY=/global/cfs/cdirs/m1517/cascade/joshelms/fcn_model_registry/sfno_74ch
export ERA5_HDF5=/pscratch/sd/p/pharring/74var-6hourly/staging/ # HENS
export MASTER_ADDR=$(hostname) # HENS
export MASTER_PORT=29500 # HENS
export DETERMINISTIC_RMSE=/pscratch/sd/a/amahesh/hens/optimal_perturbation_targets/means/d2m_sfno_linear_74chq_sc2_layers8_edim620_wstgl2-epoch70_seed16.nc # ?
export HEAT_INDEX_LOOKUP_TABLE=/pscratch/sd/a/amahesh/hens/prod_heat_index_lookup.zarr
