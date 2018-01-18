whenever sqlerror exit 1

drop table META_CONDITIONS;
drop table META_CONDITION_TYPES;
drop table META_CRITERIA;

alter session set nls_length_semantics='BYTE';

@META_CONDITION_TYPES.sql
@META_CRITERIA.sql
@META_CONDITIONS.sql