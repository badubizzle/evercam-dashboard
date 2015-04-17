#= require evercam.js.coffee
#= require cameras/single/info.js.coffee
#= require cameras/single/live.js.coffee
#= require cameras/single/sharing.js.coffee
#= require cameras/single/snapshots_navigator.js.coffee
#= require cameras/single/api_explorer.js.coffee
#= require cameras/single/logs.js.coffee
#= require cameras/single/webhooks.js.coffee
#= require cameras/single/local_storage.js.coffee
#= require cameras/single/settings.js.coffee
#= require cameras/single/testsnapshot.js.coffee
#= require saveimage.js

window.sendAJAXRequest = (settings) ->
  token = $('meta[name="csrf-token"]')
  if token.size() > 0
    headers =
      "X-CSRF-Token": token.attr("content")
    settings.headers = headers
  xhrRequestChangeMonth = $.ajax(settings)

initializeiCheck = ->
  $("input[type=radio], input[type=checkbox]").iCheck
    checkboxClass: "icheckbox_flat-blue"
    radioClass: "iradio_flat-blue"

initializeDropdowns = ->
  $("[data-toggle=\"tooltip\"]").tooltip()
  $(".dropdown-toggle").dropdown()

switchToTab = ->
  $(".nav-tab-#{Evercam.request.tabpath}").tab('show')

handleTabClick = ->
  $('.nav-tabs a').on 'click', ->
    clicked_path = $(this).attr('data-target').replace('#', '')
    if window.history and window.history.pushState
      window.history.pushState( {} , "#{clicked_path}", "#{window.Evercam.request.rootpath}/#{clicked_path}" );
  $(".nav-tabs").tabdrop "layout"

handleBackForwardButton = ->
  window.addEventListener 'popstate', (e) ->
    tab = document.location.pathname
      .replace(window.Evercam.request.rootpath, '')
      .split('/')[1]
    $(".nav-tab-#{tab}").tab('show')

handlePusherEventSingle = ->
  channel = Evercam.Pusher.subscribe(Evercam.Camera.id)
  channel.bind 'camera_changed', (data) ->
    updateCameraSinglePage()

updateCameraSinglePage = ->
  $.ajax(Evercam.request.rootpath).done (data) ->
    elements = [
      '#camera-single .camera-title'
      #'#details .info-preview'
      #'#camera-details-panel'
      #'#general-info-panel'
      #'#urls-panel'
      #'#settings-modal .modal-body'
    ]
    updateElement(data, elem) for elem in elements

updateElement = (page, elem)->
  $(elem).html $(page).find("#{elem} > *")

handleCameraModalSubmit = ->
  $('#settings-modal').on 'click', '#add-button', ->
    $('#settings-modal').modal('hide')

handlePageLoad = ->
  setTimeout (->
    updateCameraSinglePage()
    $('.sidebar-cameras-list').load '/v1/cameras/new .sidebar-cameras-list > *'
  ), 2000
    
initializeTabs = ->
  window.initializeInfoTab()
  window.initializeLiveTab()
  window.initializeRecordingsTab()
  window.initializeLogsTab()
  window.initializeSharingTab()
  window.initializeWebhookTab()
  window.initializeExplorerTab()
  window.initializeLocalStorageTab()
  window.initializeSettingsTab()

window.initializeCameraSingle = ->
  initializeTabs()
  handleTabClick()
  switchToTab()
  handleBackForwardButton()
  handlePusherEventSingle()
  # temporarily disabled
  #handleCameraModalSubmit()
  # temporarily added
  handlePageLoad()
  initializeiCheck()
  initializeDropdowns()
  Metronic.init()
  Layout.init()
  QuickSidebar.init()
  SaveImage.init()
