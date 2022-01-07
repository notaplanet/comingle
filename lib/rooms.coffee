import {Mongo} from 'meteor/mongo'
import {check, Match} from 'meteor/check'

import {validId, creatorPattern} from './id'
import {Presence} from '/lib/presence'
import {checkMeeting} from './meetings'
import {meteorCallPromise} from './meteorPromise'
import {Tabs, tabTypes, mangleTab} from './tabs'

export Rooms = new Mongo.Collection 'rooms'

export checkRoom = (room) ->
  if validId(room) and data = Rooms.findOne room
    data
  else
    throw new Error "Invalid room ID #{room}"

Meteor.methods
  roomNew: (room) ->
    check room,
      meeting: String
      title: String
      creator: creatorPattern
      tags: Match.Optional Object
    unless @isSimulation
      room.created = new Date
    checkMeeting room.meeting
    Rooms.insert room
  roomEdit: (diff) ->
    check diff,
      id: String
      title: Match.Optional String
      raised: Match.Optional Boolean
      archived: Match.Optional Boolean
      bgnames: Match.Optional [String]
      tags: Match.Optional Object
      updator: creatorPattern
    room = checkRoom diff.id
    set = {}
    for key, value of diff when key != 'id' and key != 'tags' and key != 'bgnames'
      set[key] = value unless room[key] == value
    for key, value of diff.tags ? {}
      set["tags."+key] = value
    if diff.bgnames?
      presences = Presence.find({'rooms.invisible': diff.id}).fetch()
      for p in presences
        if not p['rooms']['visible'].length
          Meteor.call 'presenceRemove', p['id']
        else
          presence =
            id: p['id']
            meeting: p['meeting']
            name: p['name']
            rooms:
              visible: p['rooms']['visible']
              invisible: []
          Meteor.call 'presenceUpdate', presence
      meetingId = Rooms.findOne(diff.id)['meeting']
      for n in diff.bgnames
        p = Presence.findOne name: n
        unless p?
          rndid = Math.random().toString(36).replace(/[01.OIUVl]+/g, '')
          rndid += Math.random().toString(36).replace(/[01.OIUVl]+/g, '')
          rndid += Math.random().toString(36).replace(/[01.OIUVl]+/g, '')
          rndid = rndid.substr(0, 17)
          presence =
            id: rndid
            meeting: meetingId
            name: n
            rooms:
              visible: []
              invisible: [diff.id]
          Meteor.call 'presenceUpdate', presence

    return unless (key for key of set).length  # nothing to update
    unless @isSimulation
      set.updated = new Date
      if set.archived
        set.archived = set.updated
        set.archiver = set.updator
      if set.raised
        set.raised = set.updated
        set.raiser = set.updator
    Rooms.update diff.id,
      $set: set
  roomWithTabs: (room) ->
    tabs = room.tabs ? {}
    delete room.tabs
    roomId = Meteor.call 'roomNew', room
    for index, tab of tabs when tab.title and tab.type
      tab.meeting = room.meeting
      tab.room = roomId
      tab.creator = room.creator
      if not tab.url
        url = tabTypes[tab.type].createNew()
        if url.then?
            tab.url = await url if url.then? 
        else 
            tab.url = url
      if not tab.protected?
        tab.protected = room.tags.protected
      await meteorCallPromise 'tabNew', mangleTab(tab, true)
    roomId

export roomWithTemplate = (room) ->
  template = room.template ? ''
  delete room.template
  roomId = await meteorCallPromise 'roomNew', room
  for type in template.split '+' when type
    url = tabTypes[type].createNew()
    url = await url if url.then?
    await meteorCallPromise 'tabNew', mangleTab(
      meeting: room.meeting
      room: roomId
      type: type
      title: ''
      url: url
      creator: room.creator
    , true)
  roomId

export roomTabs = (roomId, showArchived) ->
  roomId = roomId._id if roomId._id?
  query = room: roomId
  query.archived = $in: [null, false] unless showArchived
  Tabs.find(query).fetch()

export roomDuplicate = (room, creator) ->
  tabs = roomTabs room, false
  room = checkRoom room unless room._id?
  tags = room.tags
  delete tags?.protected
  ## Name room with existing title followed by an unused number like (2).
  i = 2
  base = room.title
  .replace /^([^]*) \(([0-9]+)\)$/, (match, prefix, number) ->
    number = parseInt number
    i = number + 1 unless isNaN number
    prefix
  while Rooms.findOne {title: title = "#{base} (#{i})"}
    i++
  ## Duplicate room
  newRoom = await meteorCallPromise 'roomNew',
    meeting: room.meeting
    title: title
    creator: creator
    tags: tags ? {}
  ## Duplicate tabs, calling createNew method if desired to avoid e.g.
  ## identical Cocreate boards or identical Jitsi meeting rooms.
  for tab in tabs
    if createNew = tabTypes[tab.type]?.createNew
      url = createNew()
      url = await url if url.then?
    else
      url = tab.url
    await meteorCallPromise 'tabNew',
      type: tab.type
      meeting: tab.meeting
      room: newRoom
      title: tab.title
      url: url
      creator: creator
  newRoom

export taggedRooms = (meetingId, tags) ->
  meeting = checkMeeting meetingId
  Rooms.find(meeting: meetingId).fetch().filter (room) ->
    match = true
    for key, value of tags ? []
      if value?
        match &= room.tags?[key] == value
      else
        match &= not room.tags?[key]?
    match
