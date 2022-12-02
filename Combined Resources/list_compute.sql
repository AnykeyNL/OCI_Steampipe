select
  display_name,
  lifecycle_state,
  shape_config_ocpus as OCPUs,
  shape_config_memory_in_gbs as Memory,
  shape,
  _ctx['connection_name'],
  '\' || coalesce(ctree.path , '') as compartment
from oci_all.oci_core_instance
left join ctree on oci_core_instance.compartment_id = ctree.compartment_id


select
  display_name,
  lifecycle_state,
  shape_config_ocpus as OCPUs,
  shape_config_memory_in_gbs as Memory,
  shape,
  _ctx['connection_name'],
  '\' || coalesce(ctree.path , '') as compartment
from oci_core_instance
left join ctree on oci_core_instance.compartment_id = ctree.compartment_id
left join volumes on oci_core_instance.id = volumes.instance_id
