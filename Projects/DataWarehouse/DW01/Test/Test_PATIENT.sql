select /*+ parallel(16)*/ network, patient_id, count(1) cnt
from patient_care_provider;