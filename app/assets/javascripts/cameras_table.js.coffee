format_time = null

initializeCamerasDataTable = ->
  camera_table = $('#cameras-log-table').DataTable({
    ajax: {
      url: $("#base-url").val(),
      dataSrc: 'cameras',
      error: (xhr, error, thrown) ->
        if xhr.responseJSON
          Notification.show(xhr.responseJSON.message)
        else
          Notification.show("Something went wrong, Please try again.")
    },
    columns: [
      {data: (row, type, set, meta ) ->
        if row.is_online
          return row.name
        else
          return "
          #{row.name} <i class='red main-sidebar fa fa-chain-broken'></i>"
      },
      {data: userCameraRights},
      {data: (row, type, set, meta ) ->
        if row.vendor_name
          return "#{row.vendor_name} (#{row.model_name})"
        else
          ""
      },
      {data: (row, type, set, meta ) ->
        if row.timezone
          return row.timezone
        else
          return ""
      },
      {data: (row, type, set, meta ) ->
        if row.is_public
          return "<span style='color: green'>Yes</span>"
        else
          return "<span style='color: red'>No</span>"
      },
      {data: (row, type, set, meta ) ->
        if row.cloud_recordings
          cr = row.cloud_recordings
          getCloudStatus(cr.status, cr.storage_duration)
        else
          return "<span style='color: red'>Off (No Recordings)</span>"
      },
    ],
    order: [[ 3, "desc" ]],
    bPaginate: false,
    bSort: true,
    bFilter: false,
    autoWidth: false,
  })

getCloudStatus = (status, duration) ->
  storage = "#{duration} Days"
  if duration is 1
    storage = "24 Hours"
  else if duration is -1
    storage = "Inifinity"
  switch status
    when "on"
      return "<span style='color: green'>#{storage} (Continuous)</span>"
    when "on-scheduled"
      return "<span style='color: green'>#{storage} (On Schedule)</span>"
    when "off"
      return "<span style='color: red'>Off (No Recordings)</span>"
    when "paused"
      return "<span style='color: black'>Paused (#{storage})</span>"

userCameraRights = (row) ->
  str = row.rights
  arr = str.split(",")
  if row.owned == true
    return "Owner"
  else if arr.indexOf("edit") != -1
    return "Full"
  else
    return "Read only"

window.initializeCamerasTable = ->
  format_time = new DateFormatter()
  initializeCamerasDataTable()
