import React from 'react'
import {Card} from 'react-bootstrap'

import {Ctrl} from './lib/keys'
import {homepage, repository} from '/package.json'
import {FontAwesomeIcon} from '@fortawesome/react-fontawesome'
import {faTh, faDoorOpen, faUser, faHandSparkles, faComment, faSortAlphaDown} from '@fortawesome/free-solid-svg-icons'
import {faSlackHash} from '@fortawesome/free-brands-svg-icons'
import {faHandPaper as faHandPaperOutline} from '@fortawesome/free-regular-svg-icons'


export Welcome = ({html}) ->
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
        <div dangerouslySetInnerHTML={{__html: html}} />
        <h5>Getting Started with <a href={homepage}>Comingle</a>:</h5>
      <ul>
        <li>Enter your <b>username</b> in the upper left panel.</li>
        <li>To <b>join a room</b>, click on a room (such as &ldquo;Main Room&rdquo;) in the <FontAwesomeIcon icon={faTh}/> Rooms list on the left.</li>
        <li>Each room contains <b>tabs</b>: spreadsheet, video call, whiteboard, etc.</li>
        <ul>
          <li> <b>Rearrange tabs</b>: You can drag tabs to re-arrange them however you like! These changes will only show up for you.</li>
          <li> <b>Add tabs</b> (visible to everyone) by clicking <b>+</b> on the right side of the tabs. When inputting a URL, the site must start with <b>https</b>.</li>
          <li> <b>Open in separate browser tab</b>: On each tab, <FontAwesomeIcon icon={faDoorOpen}/> will open that tab in a new browser window.</li>
        </ul>
        <li>You can change what is displayed:
          <ul>
            <li><b>Hide the room list sidebar</b> by clicking on <FontAwesomeIcon icon={faTh}/> <b>Rooms</b>.</li>
            <li><b>Show only non-empty rooms</b> by checking the box under <b>Room Search</b>.</li>
            <li><b>Sort rooms</b>: You can sort the rooms by number of participants, raised hand time, etc. by clicking on <b>Sort by</b> and then <FontAwesomeIcon icon={faSortAlphaDown}/> under <b>Room Search</b>.</li>
          </ul>
        </li>
        </ul>

        <h5><u>New for 2022:</u></h5>
          <ul>
            <li> <FontAwesomeIcon icon={faComment}/> <b>Room Chat</b> in the top right of each room will go to the associated puzzle Slack channel if it exists.</li>
            <li> <FontAwesomeIcon icon={faSlackHash}/> <b>General Chat</b> (top left) will always display Slack #general. </li>
            <li> <FontAwesomeIcon icon={faHandSparkles}/> <b>Raise your hand</b> to alert the team that a puzzle desperately needs eyes by clicking <FontAwesomeIcon icon={faHandPaperOutline}/> on the right of the room name, under <FontAwesomeIcon icon={faUser}/>.</li>
            <li> In <b>Slack</b>, reacting with the 🚨 (alert-general emoji) in a channel will echo your message to #general.</li>
            <li> <b>Jitsi</b> status will persist. If you hang up on a call (<b>you must click the X in the upper right corner after the hang up button</b>), you will not auto-join your next call. Mute settings will transfer between active calls.</li>
            <li> <a href="https://github.com/edemaine/cocreate/">Cocreate</a> <b>whiteboards</b> in each room have been updated. See <a href="https://github.com/edemaine/cocreate/blob/main/doc/README.md">user guide</a>.</li>
          </ul>
              <p>
                <b>Comingle</b> is an <a href={repository.url}>open-source</a> online
                meeting tool whose goal is to approximate the advantages of
                in-person meetings.
                It integrates web tools in an open multiroom environment.
              </p>
      </Card.Body>
    </Card>
