select
  name as Name,
  ip_address as ip_address,
  num_cpu as VCPUs,
  (memory::int / 1024) as MemoryGB,
  'VMwareVM' as shape,
  case
    when power = 'poweredOff' then 'stopped'
    when power = 'poweredOn' then 'running'
    else 'n/a'
  end as PowerState,
  'VMware' as Platform,
  'vsphere' as Region
from vsphere_vm

union

select
  display_name as Name,
  'na' as ip_address,
  (shape_config_ocpus::int *2) as VCPUs,
  shape_config_memory_in_gbs as MemoryGB,
  shape as shape,
  lower(lifecycle_state) as PowerState,
  'OCI' as Platform,
  region as region
from oci_core_instance

union

select
  name as Name,
  'na' as ip_address,
  0 as VCPUs,
  0 as MemoryGB,
  size as shape,
  lower(power_state) as Powerstate,
  'Azure' as Platform,
  region as region
from azure_compute_virtual_machine
