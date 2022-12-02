create view vmware_instances as

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
  'VMware' as Platform
  'vsphere' as Region
from vsphere_vm