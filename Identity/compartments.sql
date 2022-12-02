
create view ctree as WITH RECURSIVE compartments AS (
      SELECT
        name,
        id,
        compartment_id,
        tenant_id,
        name AS path,
        name as lastname,
        id as lastid
      FROM oci_identity_compartment
      WHERE lifecycle_state = 'ACTIVE'
   UNION ALL
      SELECT
        oci_identity_compartment.name,
        oci_identity_compartment.id,
        oci_identity_compartment.compartment_id,
        oci_identity_compartment.tenant_id,
        oci_identity_compartment.name || '\' || compartments.path,
        compartments.lastname,
        compartments.lastid
      FROM oci_identity_compartment
         JOIN compartments ON oci_identity_compartment.id = compartments.compartment_id
)

SELECT
  lastid as compartment_id,
  lastname as name,
  path
 from compartments
   where compartment_id = tenant_id
   order by path

