## Comingle Server Configuration Settings

export Config =

  ## When creating a new meeting, create rooms with the specified
  ## title and (optional) tabs.
  newMeetingRooms: [
    title: 'Main Room'
    tabs: [
      type: 'jitsi'
    ]
  #,
  #  title: 'Empty Room'
  #,
  #  title: 'Drawing Room'
  #  tabs: [
  #    type: 'cocreate'
  #  ]
  #,
  #  title: 'Living Room'
  #  tabs: [
  #    type: 'jitsi'
  #  ,
  #    type: 'cocreate'
  #  ]
  ]

  ## Default servers for each of the (open-source) services.
  ## If you'd rather not use/rely on a publicly deployed server,
  ## consider running your own and changing the default here.
  defaultServers:
    cocreate: 'https://cocreate.csail.mit.edu'
    jitsi: 'https://meet.jit.si'

  ## Default sort key for all meetings
  defaultSort:
    gather: ''
    key: 'title'  # see client/RoomList.coffee for other options
    reverse: false

  ## Whether to show darkmode toggle
  showUI_dark: true

  ## Whether to change rooms on click (instead of needing shift-click) by default
  default_quickJoin: false
  showUI_quickJoin: true

  ## Whether to have a compact room list by default
  default_compact: false
  showUI_compact: true

  ## Whether to hide the room creation widget at the bottom of the room list by default
  default_hideCreate: false
  showUI_hideCreate: true

  ## Whether to hide the room search widget in the room list by default
  default_hideSearch: false
  showUI_hideSearch: true

  ## Whether to hide the starred rooms accordion in the room list by default
  default_hideStarred: false
  showUI_hideStarred: true

  ## Whether to hide the title / header at the top of the room list by default
  default_hideTitle: false
  showUI_hideTitle: true

  ## Whether to hide the title / button bar at the top of the room tabset by default
  default_hideRoombar: false
  showUI_hideRoombar: true
