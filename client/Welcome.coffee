import React from 'react'
import {useParams} from 'react-router-dom'
import {Card, OverlayTrigger, Tooltip} from 'react-bootstrap'
import {FontAwesomeIcon} from '@fortawesome/react-fontawesome'
import {clipboardLink} from './icons/clipboardLink'

import {useMeetingSecret} from './MeetingSecret'
import {homepage, repository} from '/package.json'

export Welcome = ->
  {meetingId} = useParams()
  meetingUrl = Meteor.absoluteUrl "/m/#{meetingId}"
  meetingSecret = useMeetingSecret()

  <Card>
    <Card.Body>
      <Card.Title as="h4">Welcome to Comingle, <font size="+3">💫</font> I'm not a planet either teammate!</Card.Title>
      <p>
      <h6>Browser requirements:</h6>
      <ul>
        <li>Use Google Chrome</li>
        <li>Enable third party cookies! </li>
        <li>Message #notaplanet-help on Slack if you have any problems.</li>
      </ul>
      </p>
      <h5>Getting Started:</h5>
      <ul>
        <li>First, <b>enter your username</b> in the upper left panel.</li>
        <li>To <b>join a room</b>, click on a room (such as &ldquo;Main Room&rdquo;) in the Rooms list on the left.</li>
        <li>When you click a second room, you'll be offered to &ldquo;<b>Switch to Room</b>&rdquo; which leaves the current room and any video calls (shortcut: hold <kbd>Shift</kbd> while clicking).</li>
        <li>Each room contains one or more <b>tabs</b>: video call, whiteboard, etc.</li>
        <ul>
          <li> <b>Add tabs</b> (visible to everyone) by clicking on the <b>+</b> sign on the right side of the tabs. When inputting a URL, the site must start with <b>https</b>.</li>
          <li> <b>Rearrange tabs</b>: You can drag tabs to re-arrange them however you like! These changes will only show up for you.</li>
          <li> <b>Open in separate browser tab</b>: On each tab, click on the icon of a door with an arrow to open that tab in a new browser window.</li>
          <li><b>Star</b> rooms to (publicly) indicate your interest. To focus on just starred rooms, unfold the &ldquo;<b>Your Starred Rooms</b>&rdquo; section.</li>
        </ul>
        <li>You can change what is displayed:
          <ul>
            <li><b>Toggle the rooms sidebar</b> on the left by clicking on the <b>Rooms</b> button in the upper left.</li>
            <li><b>Show only non-empty rooms</b> by checking the box under Room Search.</li>
            <li><b>Sort rooms</b>: You can sort the room lists in each section by the room name, number of participants, and more by clicking on Room Search.</li>
          </ul>
        </li>
        <li>
          <u>New for 2022</u>:
          <ul>
            <li> <b>Room Chat</b> is available in the top right of each room. <b>General Chat</b> (one for the entire site) is available on the top left. These should link to the relevant Slack channels.</li>
            <li> <b>Raise your hand</b> by clicking on the icon on the right of the room name, to alert the team that a puzzle is stuck and needs eyes.</li>
          </ul>
        </li>


        <li><a href={homepage}>Read the documentation</a> for more information.</li>
      </ul>
      <p>
        <b>Comingle</b> is an <a href={repository.url}>open-source</a> online
        meeting tool whose goal is to approximate the advantages of
        in-person meetings.
        It integrates web tools in an open multiroom environment.
      </p>
      {if meetingSecret
      <>
        <h5>Administrative Access</h5>
        <p className="ml-4">
          You have administrative access to this meeting because you either created it or entered the <b>Meeting Secret</b> (under Settings). You should record the secret (for gaining access on other machines/browsers) and give it to anyone you want to
          have administrative access.
        </p>
      </>
      }
    </Card.Body>
  </Card>
