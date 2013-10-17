# Be sure to restart your server when you modify this file.

Obsqure::Application.config.session_store :cookie_store,
  key: '_obsqure_session',
  expire_after: 10.minutes
