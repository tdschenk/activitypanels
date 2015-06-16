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
