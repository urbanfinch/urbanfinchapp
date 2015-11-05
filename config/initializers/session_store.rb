# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, :key => '_urbanfinchcms_session', domain: Rails.env.production? ? 'urbanfinch.com' : 'lvh.me'
