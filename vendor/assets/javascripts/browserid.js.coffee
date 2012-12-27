# BrowserID javascript functions

@browserid = browserid =

  # Public: Path used to verify browserID authentication assertions. Assertions
  # are POSTed to this path.
  loginPath: '/login'

  # Public: Path used to unset persisted authentication state when logging out.
  # This should clear the currently-logged-in user email.
  logoutPath: '/logout'

  # Public: This method is called when a user successfully authenticates. By
  # default, it reloads the current page.
  onLogin: (res, status, xhr) ->
    alert("Successful login - refresh the page")
    #window.location.reload()

  # Public: This method is called when a user fails to authenticate.
  onLoginError: (xhr, status, err) ->
    alert("Login failure " + res)

  # Public: This method is called when a user clears their authentication. By
  # default, it reloads the current page.
  onLogout: (res, status, xhr) ->
    alert("Successful logout - refresh the page")
    #window.location.reload()

  # Public: This method is called when a user fails to clear their
  # authentication.
  onLogoutError: (xhr, status, err) ->
    alert("Logout failure " + res)

  # Public: Watches the authentication state and takes action when the user
  # logs in or logs out. This method MUST be called on every page of the
  # application.
  watch: (currentUser = null) ->
    navigator.id.watch
      loggedInUser: currentUser
      onlogin: (assertion) ->
        $.ajax
          type: 'POST'
          url: @loginPath
          data: { assertion: assertion }
          success: @onLogin
          error: @onLoginError
      onlogout: ->
        $.ajax
          type: 'POST'
          url: @logoutPath
          success: @onLogout
          error: @onLogoutError



### Behavior Binding ###

jQuery ->
  $('.browserid_login').click ->
    navigator.id.request()
    false

jQuery ->
  $('.browserid_logout').click ->
    navigator.id.logout()
    false
