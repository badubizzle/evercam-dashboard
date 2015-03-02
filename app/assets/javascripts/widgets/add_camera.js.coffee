#= require jquery
#= require jquery_ujs
#= require bootstrap

Evercam_API_URL = 'https://api.evercam.io/v1/'
#Evercam_API_URL = 'http://localhost:9292/v1/'

sortByKey = (array, key) ->
  array.sort (a, b) ->
    x = a[key]
    y = b[key]
    (if (x < y) then -1 else ((if (x > y) then 1 else 0)))

loadVendors = ->
  data = {}

  onError = (jqXHR, status, error) ->
    false

  onSuccess = (result, status, jqXHR) ->
    vendors = sortByKey(result.vendors, "name")
    for vendor in vendors
      $("#camera-vendor").append("<option value='#{vendor.id}'>#{vendor.name}</option>")

  settings =
    cache: false
    data: data
    dataType: 'json'
    error: onError
    success: onSuccess
    contentType: "application/json; charset=utf-8"
    type: 'GET'
    url: "#{Evercam_API_URL}vendors"

  jQuery.ajax(settings)
  true

loadVendorModels = (vendor_id) ->
  $("#camera-model option").remove()
  $("#camera-model").append('<option value="">Loading...</option>');
  if vendor_id is ""
    return

  data = {}
  data.vendor_id = vendor_id
  data.limit = 400

  onError = (jqXHR, status, error) ->
    false

  onSuccess = (result, status, jqXHR) ->
    $("#camera-model option").remove()
    if result.models.length == 0
      $("#camera-model").append('<option value="">No Model Found</option>');
      return

    models = sortByKey(result.models, "name")
    for model in models
      jpg_url = if model.defaults.snapshots then model.defaults.snapshots.jpg else ''
      if jpg_url is "unknown"
        jpg_url = ""
      $("#camera-model").append("<option jpg-val='#{jpg_url}' value='#{model.id}'>#{model.name}</option>")
    if $("#camera-model").find(":selected").attr("jpg-val") isnt 'Unknown'
      $("#camera-snapshot-url").val $("#camera-model").find(":selected").attr("jpg-val")
      $("#camera-snapshot-url").removeClass("invalid").addClass("valid")

  settings =
    cache: false
    data: data
    dataType: 'json'
    error: onError
    success: onSuccess
    contentType: "application/json; charset=utf-8"
    type: 'GET'
    url: "#{Evercam_API_URL}models.json"

  jQuery.ajax(settings)
  true

handleVendorModelEvents = ->
  $("#camera-vendor").on "change", ->
    loadVendorModels($(this).val())

  $("#camera-model").on "change", ->
    snapshot_url = $(this).find(":selected").attr("jpg-val")
    console.log snapshot_url
    if snapshot_url isnt 'Unknown'
      $("#camera-snapshot-url").val $(this).find(":selected").attr("jpg-val")

useAuthentication = ->
  $("#required-authentication").on 'click', ->
    if $(this).is(":checked")
      $("#authentication").removeClass("hide")
    else
      $("#authentication").addClass("hide")

handleInputEvents = ->
  $("#camera-url").on 'keyup', (e) ->
    if validate_hostname($(this).val())
      $(this).removeClass("invalid").addClass("valid")
    else
      $(this).removeClass("valid").addClass("invalid")
    validAllInformation()
  $("#camera-url").on 'focus', (e) ->
    $(".info-box .info-header").text("EXTERNAL IP / URL")
  $(".external-url").on 'click', ->
    $(".info-box .info-header").text("EXTERNAL IP / URL")

  $("#camera-port").on 'keyup', (e) ->
    if validateInt($(this).val())
      $(this).removeClass("invalid").addClass("valid")
    else
      $(this).removeClass("valid").addClass("invalid")
    validAllInformation()
  $("#camera-port").on 'focus', (e) ->
    $(".info-box .info-header").text("EXTERNAL PORT")
  $(".port").on 'click', ->
    $(".info-box .info-header").text("EXTERNAL PORT")
    $(".info-box .info-text").text("Default external port is 80.")

  $("#camera-snapshot-url").on 'keyup', (e) ->
    $(this).removeClass("invalid").addClass("valid")
    validAllInformation()
  $("#camera-snapshot-url").on 'focus', (e) ->
    $(".info-box .info-header").text("SNAPSHOT URL")
  $(".snapshot-url").on 'click', ->
    $(".info-box .info-header").text("SNAPSHOT URL")

  $("#camera-name").on 'keyup', (e) ->
    $(this).removeClass("invalid").addClass("valid")
  $("#camera-id").on 'keyup', (e) ->
    $(this).removeClass("invalid").addClass("valid")

  $("#user-email").on 'keyup', (e) ->
    if validateEmail($(this).val())
      $(this).removeClass("invalid").addClass("valid")
    else
      $(this).removeClass("valid").addClass("invalid")
  $("#user-password").on 'keyup', (e) ->
    $(this).removeClass("invalid").addClass("valid")
  $(".default-username").on 'click', ->
    $("#camera-username").val('root')
  $(".default-password").on 'click', ->
    $("#camera-password").val('pass')

validate_hostname = (str) ->
  ValidIpAddressRegex = /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/
  ValidHostnameRegex = /^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$/
  ValidIpAddressRegex.test(str) or ValidHostnameRegex.test(str)

validateInt = (value) ->
  reg = /^(0|[0-9][1-9]|[1-9][0-9]*)$/
  reg.test value

validateEmail = (email) ->
  reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/
  #remove all white space from value before validating
  emailtrimed = email.replace(RegExp(' ', 'gi'), '')
  reg.test emailtrimed

validAllInformation = ->
  if $("#camera-port") is ''
    if $("#camera-url").hasClass('valid') && $("#camera-snapshot-url").hasClass('valid')
      $(".test-image").removeClass('hide')
      $(".help-texts").addClass('hide')
    else
      $(".test-image").addClass('hide')
      $(".help-texts").removeClass('hide')
  else
    if $("#camera-url").hasClass('valid') && $("#camera-port").hasClass('valid') && $("#camera-snapshot-url").hasClass('valid')
      $(".test-image").removeClass('hide')
      $(".help-texts").addClass('hide')
    else
      $(".test-image").addClass('hide')
      $(".help-texts").removeClass('hide')

testSnapshot = ->
  $("#test-snapshot").on 'click', ->
    port = $("#camera-port").val() unless $("#camera-port").val() is ''
    data = {}
    data.external_url = "http://#{$('#camera-url').val()}:#{port}"
    data.jpg_url = $('#camera-snapshot-url').val()
    data.cam_username = $("#camera-username").val() unless $("#camera-username").val() is ''
    data.cam_password = $("#camera-password").val() unless $("#camera-password").val() is ''

    onError = (jqXHR, status, error) ->
      $(".snapshot-msg").html(jqXHR.responseJSON.message)
      #$(".snapshot-msg").removeClass('msg-success').addClass('msg-error')
      $(".snapshot-msg").show()

    onSuccess = (result, status, jqXHR) ->
      if result.status is 'ok'
        $("#testimg").attr('src', result.data)
        #$(".snapshot-msg").removeClass('msg-error').addClass('msg-success')
        $(".snapshot-msg").hide()
        $("#test-snapshot").hide()
        $("#continue-step2").show()

    settings =
      cache: false
      data: data
      dataType: 'json'
      error: onError
      success: onSuccess
      contentType: "application/json; charset=utf-8"
      type: 'GET'
      url: "#{Evercam_API_URL}cameras/test"

    jQuery.ajax(settings)

handleContinueBtn = ->
  $("#continue-step2").on 'click', ->
    $(".nav-steps li").removeClass('active')
    $("#camera-details").fadeOut(300, ->
      $("#camera-info").fadeIn(300)
    )
    $("#li-camera-info").addClass('active')

  $("#continue-step3").on 'click', ->
    if $("#camera-name").val() is ''
      $("#camera-name").removeClass("valid").addClass("invalid")
      return
    if $("#camera-id").val() is ''
      $("#camera-id").removeClass("valid").addClass("invalid")
      return
    $("#camera-name").removeClass("invalid").addClass("valid")
    $(".nav-steps li").removeClass('active')
    $("#camera-info").fadeOut(300, ->
      $("#user-create").fadeIn(300)
    )
    $("#li-user-create").addClass('active')

autoCreateCameraId = ->
  $("#camera-name").on 'keyup', ->
    $("#camera-id").val $(this).val().replace(RegExp(" ", "g"), "-").toLowerCase()

handleUserFormEvents = ->
  $("#create-account").on 'click', ->
    if $("#user-email").val() is '' || !validateEmail($("#user-email").val())
      $("#user-email").removeClass("valid").addClass("invalid")
      return
    if $("#user-password").val() is ''
      $("#user-password").removeClass("valid").addClass("invalid")
      return

    email = $("#user-email").val()
    username = email.substring(0,email.indexOf('@'))
    data = {}
    data.firstname = username
    data.lastname = username
    data.username = username
    data.country = 'IR'
    data.email = email
    data.password = $("#user-password").val()

    onError = (jqXHR, status, error) ->
      $("#message-user-create").text(jqXHR.responseJSON.message)
      $("#message-user-create").show()

    onSuccess = (result, status, jqXHR) ->
      getAPICredentials()

    settings =
      cache: false
      data: data
      dataType: 'json'
      error: onError
      success: onSuccess
      contentType: "application/x-www-form-urlencoded"
      type: 'POST'
      url: "#{Evercam_API_URL}users"

    jQuery.ajax(settings)

getAPICredentials = ->
  data = {}
  data.password = $("#user-password").val()

  onError = (jqXHR, status, error) ->
    #console.log(jqXHR.responseJSON.message)

  onSuccess = (result, status, jqXHR) ->
    createCamera(result.api_id, result.api_key)

  settings =
    cache: false
    data: data
    dataType: 'json'
    error: onError
    success: onSuccess
    contentType: "application/json; charset=utf-8"
    type: 'GET'
    url: "#{Evercam_API_URL}users/#{$("#user-email").val()}/credentials"

  jQuery.ajax(settings)

createCamera = (api_id, api_key) ->
  data = {}
  data.id = $("#camera-id").val()
  data.name = $("#camera-name").val()
  data.vendor = $("#camera-vendor").val()
  data.model = $('#camera-model').val()
  data.is_public = false
  data.cam_username = $("#camera-username").val() unless $("#camera-username").val() is ''
  data.cam_password = $("#camera-password").val() unless $("#camera-password").val() is ''
  data.external_host = $("#camera-url").val()
  data.external_http_port = $("#camera-port").val() unless $("#camera-port").val() is ''
  data.jpg_url = $("#camera-snapshot-url").val()

  onError = (jqXHR, status, error) ->
    $("#message-user-create").text(jqXHR.responseJSON.message)
    $("#message-user-create").show()

  onSuccess = (result, status, jqXHR) ->
    #console.log result
    clearForm()

  settings =
    cache: false
    data: data
    dataType: 'json'
    error: onError
    success: onSuccess
    contentType: "application/x-www-form-urlencoded"
    type: 'POST'
    url: "#{Evercam_API_URL}cameras?api_id=#{api_id}&api_key=#{api_key}"

  jQuery.ajax(settings)

clearForm = ->
  $("#camera-id").val('')
  $("#camera-name").val('')
  $("#user-email").val('')
  $("#user-password").val('')
  $("#camera-username").val('')
  $("#camera-password").val('')
  $("#camera-port").val('')
  $("#camera-url").val('')
  $("#camera-snapshot-url").val('')
  $("#camera-vendor").val('')
  $("#camera-model option").remove()
  $("#camera-model").append('<option value="">Unknown</option>');
  $(".nav-steps li").removeClass('active')
  $("#user-create").fadeOut(300, ->
    $("#camera-details").fadeIn(300)
  )
  $("#li-camera-details").addClass('active')
  $("#required-authentication").removeAttr("checked")
  $("#authentication").addClass("hide")
  $("#testimg").attr('src', '')
  $(".snapshot-msg").hide()
  $("#test-snapshot").show()
  $("#continue-step2").hide()

$ ->
  useAuthentication()
  loadVendors()
  handleVendorModelEvents()
  handleInputEvents()
  testSnapshot()
  handleContinueBtn()
  #autoCreateCameraId()
  handleUserFormEvents()