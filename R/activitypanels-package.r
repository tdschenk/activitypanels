#' Activity Dashboard Panels
#' 
#' PiLR dashboard panels for use with activity_ref_app data
#'
#' @name activitypanels
#' @docType package
#' @param data The dataset retrieved from PiLR
#' @param params A list of all arguments sent to pilr_dashboard_panel
#' @import plyr ggvis

## Bar chart of occurences of each activity (not including "still")
#' @export
activity.counts <- function(data, params, ...) {
  df <- count(data$activity, "activity")
  df <- df[df$activity != "still", ]
  df %>%
    ggvis(x = ~activity, y = ~freq, fill := "lightblue") %>%
    layer_bars() %>%
    add_axis("x", title = "Activity") %>%
    add_axis("y", title = "Number of Records")
}

## WVU Stacked bar chart of activity classifications
activity_class_bar <- function(data, params, ...) {
  pts <- unique(data$activity$metadata$pt)
  activity <- data$activity$data
  activity$day <- substr(data$activity$metadata$local_time, 0, 10)
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
    add_axis("x", orient = "top", ticks = 0, title = paste0("Participant: ", paste(pts),collapse=",")),
             properties = axis_props(
               axis = list(stroke = "white"),
               labels = list(fontSize = 0)))
}