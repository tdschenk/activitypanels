options(pilr_server_default = "http://qa.pilrhealth.com")
options(pilr_project_default = "wvu_motion_tracker_1")
options(pilr_default_access_code = "8fd8dc7a-884e-4728-a55c-a3f7aac67814")
data <- list(activity = read_pilr(data_set = "pilrhealth:activity_monitoring_app:activity", schema = 2,
                             query_params = list(participant = "101")))