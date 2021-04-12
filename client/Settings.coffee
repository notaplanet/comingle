import React from 'react'
import {useParams} from 'react-router-dom'
import {Card, Form, OverlayTrigger, Tooltip} from 'react-bootstrap'

import {LocalStorageVar, StorageDict} from './lib/useLocalStorage'
import {MeetingTitle} from './MeetingTitle'
import {MeetingSecret, useMeetingAdmin} from './MeetingSecret'
import {Config} from '/Config'

export Settings = React.memo ->
  admin = useMeetingAdmin()
  <>
    <Card>
      <Card.Body>
        <Card.Title as="h3">Settings</Card.Title>
        <Form>
          <UIToggles/>
        </Form>
      </Card.Body>
    </Card>
    <div className="sidebar">
      <MeetingTitle/>
      <MeetingSecret/>
    </div>
    {if admin
      <Card>
        <Card.Body>
          <Card.Title as="h3">Admin</Card.Title>
          <Form>
            <AdminVisit/>
          </Form>
        </Card.Body>
      </Card>
    }
  </>
Settings.displayName = 'Settings'

uiVars = {}
uiLabels = {}
export useUI = (name) -> uiVars[name].use()
export getUI = (name) -> uiVars[name].get()

addUIVar = (name, label, tooltip, init) ->
  unless init?
    init = ->
      Config["default_" + name]
  uiVars[name] = new LocalStorageVar name, init, sync: true
  uiLabels[name] =
    label: label
    tooltip: tooltip

addUIVar('quickJoin', 'Quick Join', 'Immediately change rooms on click (shift-click to open the room menu)')
addUIVar('dark', 'Dark Mode', 'Light text on dark background', -> window.matchMedia('(prefers-color-scheme: dark)').matches)
addUIVar('compact', 'Compact Mode', 'Condense the list in the "Meeting Rooms" sidebar')
addUIVar('hideCreate', 'Hide Create', 'Hide "Create Room" widget in the "Meeting Rooms" sidebar')
addUIVar('hideSearch', 'Hide Search', 'Hide "Room Search" widget in the "Meeting Rooms" sidebar')
addUIVar('hideStarred', 'Hide Starred', 'Hide "Your Starred Rooms" accordion in the "Meeting Rooms" sidebar')
addUIVar('hideTitle', 'Hide Title', 'Hide meeting title in the "Meeting Rooms" sidebar')
addUIVar('hideRoombar', 'Hide Menubar', 'Hide menubar in room tabset')

export UIToggles = React.memo ->
  for name, label of uiLabels
    if Config["showUI_" + name]
      <UIToggle name={name} key={name}/>
UIToggles.displayName = 'UIToggles'

export UIToggle = React.memo ({name}) ->
  value = useUI(name)
  label = uiLabels[name]?.label
  tooltip = uiLabels[name]?.tooltip
  <OverlayTrigger placement="right" overlay={(props) ->
    <Tooltip {...props}>{tooltip}</Tooltip>
  }>
    <div>
    <Form.Switch id={name} label={label} checked={value}
     onChange={(e) -> uiVars[name].set e.target.checked}/>
    </div>
  </OverlayTrigger>
UIToggle.displayName = 'UIToggle'

adminVisitVars = new StorageDict LocalStorageVar,
  'adminVisit', false, sync: true
export useAdminVisit = ->
  {meetingId} = useParams()
  adminVisitVars.get(meetingId)?.use()

export AdminVisit = React.memo ->
  {meetingId} = useParams()
  adminVisit = useAdminVisit()
  <Form.Switch id="adminVisit" label="Show timer since last admin visit" checked={adminVisit}
   onChange={(e) -> adminVisitVars.get(meetingId).set e.target.checked}/>
AdminVisit.displayName = 'AdminVisit'
