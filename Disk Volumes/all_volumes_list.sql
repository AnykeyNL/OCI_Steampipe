create view volumes as with vols_with_instances as (
  SELECT
    v.volume_id as volume_id,
    v.instance_id as instance_id
  from
    oci_core_volume_attachment as v
  union
  select
    b.boot_volume_id as volume_id,
    b.instance_id as instance_id
  from
    oci_core_boot_volume_attachment as b
),
-- Listing all volumes of type boot and block volumes
all_volumes as (
  select
    'Block Volume' as volume_type,
    lifecycle_state,
    id,
    compartment_id,
    availability_domain,
    display_name,
    size_in_gbs,
    vpus_per_gb,
    tags,
    _ctx as Tenancy
  from
    oci_core_volume
  union
  select
    'Boot Volume' as volume_type,
    lifecycle_state,
    id,
    compartment_id,
    availability_domain,
    display_name,
    size_in_gbs,
    vpus_per_gb,
    tags,
    _ctx as Tenancy
  from
    oci_core_boot_volume
)
-- Listing the volumes based on attachment
select
  a.display_name as Volume_name,
  a.tags['CreatedBy'] as Owner,
  a.size_in_gbs::int as SizeGB,
  a.vpus_per_gb as VPUs,
  a.volume_type,
  case
    when v.volume_id is null then 'Not Attached'
    else 'Attached'
  end as status,
  v.instance_id as instance_id,
  i.display_name as Attached_to,
  a.id as resource,
  coalesce(c.name, 'root') as compartment,
  a.availability_domain,
  Tenancy['connection_name']
from
  all_volumes as a
  left join vols_with_instances as v on v.volume_id = a.id
  left join oci_identity_compartment as c on c.id = a.compartment_id
  left join oci_core_instance as i on v.instance_id = i.id
where a.lifecycle_state='AVAILABLE'
order by SizeGB	desc