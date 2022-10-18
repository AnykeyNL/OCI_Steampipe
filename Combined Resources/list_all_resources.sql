with allServices as (
select
  display_name,
  lifecycle_state as status,
  'DB' as Service,
  cpu_core_count as OCPUs,
  null as MemoryGB,
  tags['CreatedBy'] as owner,
  compartment_id,
  _ctx['connection_name'] as tenancy
from oci_database_db_system

union

select
 display_name,
 lifecycle_state as status,
 'Compute' as Service,
 shape_config_ocpus as OCPUs,
 shape_config_memory_in_gbs as MemoryGB,
 tags['CreatedBy'] as owner,
 compartment_id,
 _ctx['connection_name'] as tenancy
from oci_core_instance



)

select
  Service,
  status,
  display_name as name,
  OCPUs,
  MemoryGB,
  owner,
  coalesce(c.name, 'root') as compartment,
  tenancy

from allServices as a
left join oci_identity_compartment as c on c.id = a.compartment_id

