options(pilr_server_default = "http://qa.pilrhealth.com")
options(pilr_project_default = "wvu_motion_tracker_1")
options(pilr_default_access_code = "8fd8dc7a-884e-4728-a55c-a3f7aac67814")
data <- list(activity = read_pilr(data_set = "pilrhealth:activity_monitoring_app:activity", schema = 2,
                             query_params = list(participant = "101")))

activity <- data$activity
activity$day <- substr(data$activity$local_time, 0, 10)
days <- unique(activity$day)
summary <- data.frame(day = character(), activity = character(), count = numeric())
for (i in 1:length(days)) {
  activity_sub <- activity[activity$day == days[i], ]
  stationary <- nrow(activity_sub[activity_sub$inferred_activity == "stationary",])
  walking <- nrow(activity_sub[activity_sub$inferred_activity == "walking",])
  running <- nrow(activity_sub[activity_sub$inferred_activity == "running",])
  summary <- rbind(summary, data.frame(day = days[i], activity = "stationary", count = stationary))
  summary <- rbind(summary, data.frame(day = days[i], activity = "walking", count = walking))
  summary <- rbind(summary, data.frame(day = days[i], activity = "running", count = running))
}
summary %>%
  ggvis(x = ~day, y = ~count, fill = ~activity) %>%
  layer_bars() %>%
  add_axis("x", title = "",
           properties = axis_props(labels = list(angle = 45, align = "left"))) %>%
  add_axis("y", title = "Polls") %>%
  add_axis("x", orient = "top", ticks = 0, title = paste0("Participant: ", paste(unique(data$activity$metadata$pt),collapse=",")),
           properties = axis_props(
             axis = list(stroke = "white"),
             labels = list(fontSize = 0)))