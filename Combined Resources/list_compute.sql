# Need ctree and volumes views to be created first!

with vms as (
    select
      id,
      display_name,
      lifecycle_state,
      shape_config_ocpus as OCPUs,
      shape_config_memory_in_gbs as Memory,
      shape,
      defined_tags['Owner']['CreatedBy'] as owner,
      defined_tags['Owner']['CreatedDate'] as CreatedDate,
      _ctx['connection_name'] as Tenancy,
      '\' || coalesce(ctree.path , '') as compartment
    from oci_core_instance
    left join ctree on oci_core_instance.compartment_id = ctree.compartment_id

),
vols as (
 select instance_id, count(*) as Volume_count, sum(sizegb) as TotalVolumeSize from volumes group by instance_id
)

select
    vms.display_name,
    vms.lifecycle_state,
    vms.shape,
    vms.OCPUs,
    vms.Memory,
    vols.Volume_count,
    vols.TotalVolumeSize,
    vms.compartment,
    vms.Tenancy,
    vms.owner,
    vms.CreatedDate
from vms
left join vols on vols.instance_id = vms.id