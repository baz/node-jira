url = require 'url'
JiraRPC = require('./jira_client').JiraRPC
JiraREST = require('./jira_client').JiraREST

class JiraAPI
	constructor: ->
		@jiraRPC = new JiraRPC username, password, location
		@jiraREST = new JiraREST username, password, location

	authenticate: (callback) ->
		@jiraRPC.call 'login', [@jiraRPC.username, @jiraRPC.password], (error, response) ->
			if error then callback error, false else callback null, true

	allProjects: (callback) ->
		@jiraRPC.call 'getProjectsNoSchemes', null, callback

	allVersions: (projectKey, callback) ->
		@jiraRPC.call 'getVersions', [projectKey], callback

	allComponents: (projectKey, callback) ->
		@jiraRPC.call 'getComponents', [projectKey], callback

	issueTypes: (projectID, callback) ->
		@jiraRPC.call 'getIssueTypesForProject', [projectID], callback

	subTaskIssueTypes: (projectID, callback) ->
		@jiraRPC.call 'getSubTaskIssueTypesForProject', [projectID], callback

	priorities: (callback) ->
		@jiraRPC.call 'getPriorities', null, callback

	statuses: (callback) ->
		@jiraRPC.call 'getStatuses', null, callback

	resolutions: (callback) ->
		@jiraRPC.call 'getResolutions', null, callback

	items: (projectKey, limit, callback) ->
		query = "project = #{ projectKey } ORDER BY updated DESC, key DESC"
		@jiraRPC.call 'getIssuesFromJqlSearch', [query, limit], callback

	availableActions: (issueKey, callback) ->
		@jiraRPC.call 'getAvailableActions', [issueKey], callback

	worklogs: (issueKey, callback) ->
		@jiraRPC.call 'getWorklogs', [issueKey], callback

module.exports = new JiraAPI()
