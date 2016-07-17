select table1.city_id, (table1.actual_eta-table1.predicted_eta) as "time_diff",
       table2.city_name
from trips as table1
join cities as table2
on table1.city_id=table2.city_name

where (date-table1.request_at)<30
and table1.status = 'completed'
and table2.city_name in ('Qarth','Meereen')

group by table2.city_name;
         
