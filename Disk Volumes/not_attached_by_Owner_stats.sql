with vols_with_instances as (
  select
    v.volume_id as volume_id
  from
    oci_core_volume_attachment as v
  union
  select
    b.boot_volume_id as volume_id
  from
    oci_core_boot_volume_attachment as b
),
-- Listing all volumes of type boot and block volumes
all_volumes as (
  select
    id,
    compartment_id,
    region,
    display_name,
    size_in_gbs,
    tags,
    lifecycle_state
  from
    oci_core_volume
  union
  select
    id,
    compartment_id,
    region,
    display_name,
    size_in_gbs,
    tags,
    lifecycle_state
  from
    oci_core_boot_volume
)
-- Listing the volumes based on attachment
select
  count(*) as Volumes,
  sum(a.size_in_gbs::int) as SizeGB,
  a.tags['CreatedBy']
from
  all_volumes as a
  left join vols_with_instances as v on v.volume_id = a.id
where
  v.volume_id is null and a.lifecycle_state != 'TERMINATED'
group by a.tags['CreatedBy']
order by SizeGB	desc