Delayed::Worker.backend = :active_record
Delayed::Job.attr_accessible :priority, :payload_object, :run_at
