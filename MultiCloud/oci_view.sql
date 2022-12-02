create view oci_instances as

select
  display_name as Name,
  'na' as ip_address,
  (shape_config_ocpus::int *2) as VCPUs,
  shape_config_memory_in_gbs as MemoryGB,
  shape as shape,
  lower(lifecycle_state) as PowerState,
  'OCI' as Platform,
  availability_domain as location,
  region as region
from oci_core_instance
