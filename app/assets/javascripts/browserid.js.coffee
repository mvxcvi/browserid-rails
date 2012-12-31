# BrowserID javascript functions

@browserid = browserid =

  ### PROPERTIES ###

  # Public: Path used to verify browserID authentication assertions. Assertions
  # are POSTed to this path.
  loginPath: '/login'

  # Public: Path used to unset persisted authentication state when logging out.
  # This should clear the currently-logged-in user email.
  logoutPath: '/logout'

  # Internal: Debugging toggle - if true, the results of logins will be alert
  # dialogs instead of page refreshes. This is useful to set if the application
  # starts going into a refresh loop.
  debug: false



  ### HANDLERS ###

  # Public: This method is called when a user successfully authenticates. By
  # default, it reloads the current page.
  onLogin: (data, status, xhr) ->
    if @debug
      alert("Login: #{status}\n#{data}")
    else
      window.location.reload()

  # Public: This method is called when a user fails to authenticate.
  onLoginError: (xhr, status, err) ->
    alert("Login: #{status} #{err}\n#{xhr.responseText}")

  # Public: This method is called when a user clears their authentication. By
  # default, it reloads the current page.
  onLogout: (data, status, xhr) ->
    if @debug
      alert("Logout: #{status}\n#{data}")
    else
      window.location.reload()

  # Public: This method is called when a user fails to clear their
  # authentication.
  onLogoutError: (xhr, status, err) ->
    alert("Logout: #{status} #{err}\n#{xhr.responseText}")


  ### INITIALIZATION ###

  # Public: Watches the authentication state and takes action when the user
  # logs in or logs out. This method MUST be called on every page of the
  # application.
  setup: (currentUser = null) ->
    navigator.id.watch
      loggedInUser: currentUser
      onlogin: (assertion) =>
        $.ajax
          type: 'POST'
          url: @loginPath
          data: { assertion: assertion }
          success: (data, status, xhr) => @onLogin(data, status, xhr)
          error: (xhr, status, err) => @onLoginError(xhr, status, err)
      onlogout: =>
        $.ajax
          type: 'POST'
          url: @logoutPath
          success: (data, status, xhr) => @onLogout(data, status, xhr)
          error: (xhr, status, err) => @onLogoutError(xhr, status, err)



### Behavior Binding ###

jQuery ->
  $('.browserid_login').click ->
    navigator.id.request()
    false

jQuery ->
  $('.browserid_logout').click ->
    navigator.id.logout()
    false
