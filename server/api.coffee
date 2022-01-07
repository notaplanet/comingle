import bodyParser from 'body-parser';
import {Presence} from '/lib/presence'
import {Meetings} from '/lib/meetings'
import {Rooms, roomWithTemplate, roomWithTabs, taggedRooms} from '/lib/rooms'
import {Tabs} from '/lib/tabs'

apiMethods =

  '/clear': (options, req, res) ->
    try
      secret = req.body?.secret ? options.get 'secret'
      purge = req.body?.purge ? options.get 'purge'
      if secret != "YesIWantToDelet"
        throw ("Not allowed")
      meeting = req.body?.meeting ? options.get 'meeting'
      room = req.body?.room ? options.get 'room'
      if meeting
          coll = Meetings
          id = meeting
          Rooms.remove {'meeting': id}; Tabs.remove {'meeting': id}
      else if room
          coll = Rooms
          id = room
          Tabs.remove {'room': id}
      else
        throw ("Must specify meeting or room ID")
      if purge
        coll.remove id
      status: 200
      json:
        ok: true
        data: coll.find().fetch()
    catch e
      status: 500
      json:
        ok: false
        error: e

  '/dump': (options, req, res) ->
    try
      mtg = req.body?.mtg
      meeting = Meetings.findOne mtg
      rooms = Rooms.find(meeting: mtg).fetch()
      tabs = Tabs.find(meeting: mtg).fetch()
      status: 200
      json:
        ok: true
        meeting: meeting
        rooms: rooms
        tabs: tabs
    catch e
      status: 500
      json:
        ok: false
        error: "Error parsing slug: #{e}"

  '/mtg': (options, req, res) ->
    try
      slug = options.get 'mtg'
      data = Meetings.find({slug: slug}, {fields: {_id: 1}}).fetch().reverse()[0]
      if data?._id
        unless res.headersSent
          res.setHeader 'Location', Meteor.absoluteUrl "/m/#{data._id}"
        status: 302
        json:
          ok: true
          data: data
          location: Meteor.absoluteUrl "/m/#{data._id}"
      else
        status: 404
        json:
          ok: false
          data: "Error: slug not found"
    catch e
      status: 500
      json:
        ok: false
        error: "Error parsing slug: #{e}"

  '/list': (options, req) ->
    try
      meeting = req.body?.meeting ? options.get 'meeting'
      if not meeting
        throw ("Must specify meeting ID")
      colltype = req.body?.type ? options.get 'type'
      switch colltype
        when 'meeting' then coll = Meetings.find({'_id': meeting}).fetch()
        when 'tabs' then coll = Tabs.find({'meeting': meeting}).fetch()
        when 'presence' then coll = Presence.find({'meeting': meeting}).fetch()
        else coll = taggedRooms meeting, req.body?.tags
      status: 200
      json:
        ok: true
        data: coll
    catch e
      status: 500
      json:
        ok: false
        error: e

  '/editMeeting': (options, req) ->
    try
      meeting = req.body?.meeting ? options.get 'meeting'

      if (not meeting)
        throw ("Must specify meeting ID")

      title = req.body?.title ? options.get 'title'
      chat = req.body?.chat ? options.get 'chat'
      slug = req.body?.slug ? options.get 'slug'
      html = req.body?.html ? options.get 'html'

      diff =
        id: meeting
        updator: { name: "Web API", presenceId: "none" }
        defaultSort: req.body?.defaultSort ? {}

      if title?
        diff["title"] = title
      if chat?
        diff["chat"] = chat
      if slug?
        diff["slug"] = slug
      if html?
        diff["html"] = html

      Meteor.call 'meetingEdit', diff

      status: 200
      json:
        ok: true
        data: Meetings.find({'_id': meeting}).fetch()
    catch e
      status: 500
      json:
        ok: false
        error: e

  '/editRoom': (options, req) ->
    try
      room = req.body?.room ? options.get 'room'
      meeting = req.body?.meeting ? options.get 'meeting'
      tags = req.body?.tags

      if (meeting and tags)
        roomlist = taggedRooms meeting, tags
      else if room
        roomlist = Rooms.find({'_id': room}).fetch()
      else
        throw ("Must specify either room ID or meeting ID and tags to filter")
      idlist = (room._id for room in roomlist)

      checkflag = (optname, setname) ->
        getvar = options.get optname
        reqvar = req.body?[optname]
        if not getvar? and not reqvar?
          return null
        [setname] : reqvar or Boolean JSON.parse getvar

      title = req.body?.title ? options.get 'title'
      bgnames = req.body?.bgnames

      for id in idlist
        diff =
          id: id
          updator: { name: "Web API", presenceId: "none" }
          tags: req.body?.settags ? {}
        if title?
          diff["title"] = title
        if bgnames?
          diff["bgnames"] = bgnames
        diff = {...diff, ...checkflag('archive', 'archived'), ...checkflag('raise', 'raised')}
        Meteor.call 'roomEdit', diff

      status: 200
      json:
        ok: true
        data: idlist
    catch e
      status: 500
      json:
        ok: false
        error: e

  '/addRoom': (options, req) ->
    try
      room = req.body
      roomId = Meteor.call 'roomWithTabs', room
      status: 200
      json:
        ok: true
        roomId: roomId
    catch e
      status: 500
      json:
        ok: false
        error: "Error adding room with tabs: #{e}"

## Allow CORS for API calls
WebApp.connectHandlers.use '/api', (req, res, next) ->
  res.setHeader 'Access-Control-Allow-Origin', '*'
  next()

WebApp.connectHandlers.use '/api', bodyParser.json()

WebApp.connectHandlers.use '/api', (req, res, next) ->
  return unless req.method in ['GET', 'POST']
  url = new URL req.url, Meteor.absoluteUrl()
  if apiMethods.hasOwnProperty url.pathname
    result = apiMethods[url.pathname] url.searchParams, req, res, next
  else
    result =
      status: 404
      json:
        ok: false
        error: "Unknown API endpoint: #{url.pathname}"
  unless res.headersSent
    res.writeHead result.status, 'Content-type': 'application/json'
  unless res.writeableEnded
    res.end JSON.stringify result.json
