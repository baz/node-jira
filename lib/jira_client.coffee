rest = require 'restler'
querystring = require 'querystring'
url = require 'url'

class JiraRPC
	constructor: (@username, @password, @location) ->
		@apiPath = url.resolve @location, 'rpc/json-rpc/jirasoapservice-v2'

	call: (methodName, params = [], callback) ->
		# We are authenticating via basic auth, so the token is not needed
		# But a placeholder value is required
		# The only method which does not require a token parameter is the login method
		if methodName != 'login' then params.unshift 'token123'

		body =
			jsonrpc: '2.0'
			method: methodName
			params: params
			id: null
		bodyData = JSON.stringify(body)
		options =
			data: bodyData
			username: @username
			password: @password
			headers:
				'Content-Type': 'application/json'
				'Content-Length': bodyData.length

		request = rest.post @apiPath, options
		request.on 'success', (data) ->
			if data.error
				return callback data.error.message, null
			else
				return callback null, data.result
		request.on 'error', (data, response) =>
			error = 'Error with HTTP status code: ' + response.statusCode + '\n'
			error += 'Your credentials or location (' + @apiPath + ') may be incorrect, please try again.'
			return callback error, null


class JiraREST
	constructor: (@username, @password, @location) ->
		@apiPath = url.resolve @location, 'rest/api/2.0.alpha1/'

	get: (methodName, params = {}, callback) ->
		query = querystring.stringify params
		options =
			username: @username
			password: @password

		path = url.resolve @apiPath, methodName + "?#{ query }"
		request = rest.get path, options
		request.on 'success', (data) ->
			return callback null, data
		request.on 'error', (data, response) =>
			error = 'Error with HTTP status code: ' + response.statusCode + '\n'
			error += 'Your credentials or location (' + @apiPath + ') may be incorrect, please try again.'
			return callback error, null

module.exports.JiraRPC = JiraRPC
module.exports.JiraREST = JiraREST
