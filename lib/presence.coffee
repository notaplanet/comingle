import {Mongo} from 'meteor/mongo'
import {check, Match} from 'meteor/check'

import {validId, checkId} from './id'
import {checkMeeting, checkMeetingSecret} from './meetings'
import {checkRoom} from './rooms'
import {roomJoin, roomChange, roomLeave} from './rooms'

## Load code on server only
logPresence = logPresenceRemove = setConnection = null
if Meteor.isServer
  Meteor.defer -> # avoid import cycle
    {logPresence, logPresenceRemove} = require '/server/log.coffee'
    {setConnection} = require '/server/presence.coffee'

export Presence = new Mongo.Collection 'presence'
export PresenceStream = new Meteor.Streamer 'presence'

Meteor.methods
  presenceUpdate: (presence) ->
    check presence,
      id: Match.Where validId
      meeting: Match.Where validId
      secret: Match.Maybe String
      name: String
      pronouns: Match.Optional String
      rooms:
        joined: [Match.Where validId]
        starred: [Match.Where validId]
    unless @isSimulation
      meeting = checkMeeting presence.meeting
      presence.updated = new Date
      ## Convert 'secret' to boolean representing whether you know the secret
      presence.admin = (presence.secret == meeting.secret)  # for log
      setAdmin = admin: presence.admin
      ## Maintain connection -> presence mapping
      setConnection @connection.id, presence.id
      ## Log the changes
      {old, diff} = logPresence presence
      return unless diff  # no changes
      ## Update room joined lists
      newJoined = {}
      newJoined[roomId] = true for roomId in presence.rooms.joined
      for roomId in old?.rooms.joined ? []
        if roomId of newJoined  # common room in old and new
          delete newJoined[roomId]
          roomChange roomId, diff
        else
          roomLeave roomId, presence  # old room not in new rooms
      for own roomId of newJoined  # remaining rooms are newly joined
        roomJoin roomId, presence
    Presence.update
      id: presence.id
    ,
      $set: Object.assign (setAdmin ? {}),
        meeting: presence.meeting
        name: presence.name
        pronouns: presence.pronouns
        rooms: presence.rooms
      $setOnInsert:
        id: presence.id
    ,
      upsert: true
  presenceRemove: (presenceId) ->
    checkId presenceId
    return if @isSimulation
    {old} = logPresenceRemove presenceId
    for roomId in old?.rooms.joined ? []
      roomLeave roomId, (old ? id: presenceId)
    Presence.remove id: presenceId

presenceOp = (op) -> (presenceId, roomId, secret) ->
  check presenceId, Match.OneOf [Match.Where validId], Match.Where validId
  return if @isSimulation
  room = checkRoom roomId
  checkMeetingSecret room.meeting, secret
  presenceId = [presenceId] unless Array.isArray presenceId
  for id in presenceId
    PresenceStream.emit id,
      op: op
      room: roomId

Meteor.methods
  presenceKick: presenceOp 'kick'
  presenceMove: presenceOp 'move'
