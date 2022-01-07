import React from 'react'
import {Card} from 'react-bootstrap'

import {Ctrl} from './lib/keys'
import {homepage, repository} from '/package.json'

export Welcome = ({html}) ->
    <Card>
      <Card.Body>
        <Card.Title as="h3">Welcome to Comingle!</Card.Title>
        <p>
          <b>Comingle</b> is an <a href={repository.url}>open-source</a> online
          meeting tool whose goal is to approximate the advantages of
          in-person meetings.
          It integrates web tools in an open multiroom environment.
        </p>
        <div dangerouslySetInnerHTML={{__html: html}} />
        <h5>Getting Started:</h5>
        <ul>
          <li>First, <b>enter your username</b> in the left panel.</li>
          <li>To <b>join a room</b>, click on a room (such as &ldquo;Main Room&rdquo;) in the room list on the left.</li>
          <li>Each room contains one or more <b>tabs</b>: video call, whiteboard, etc.
            <ul>
              <li> <b>Add tabs</b> for all users of the meeting by clicking on the <b>+</b> sign on the right side of the tabs. When inputting a URL, the site must start with <b>https</b>.</li>
              <li> <b>Rearrange tabs</b>: You can drag tabs to re-arrange them however you like! These changes will only show up for you.</li>
              <li> <b>Open in separate browser tab</b>: On each tab, click on the icon of a door with an arrow to open that tab in a new browser window.</li>
              <li>
                <b>Room Chat</b> is available in the top right of each room. <b>Meeting Chat</b> (one for the entire site) is available in top left.
              </li>
            </ul>
          </li>
          <li>You can change what is displayed:
            <ul>
              <li><b>Toggle the rooms sidebar</b> on the left by clicking on the <b>Meeting Rooms</b> button in the upper left.</li>
              <li><b>Show only non-empty rooms</b> by checking the box under Room Search.</li>
              <li><b>Sort rooms</b>: You can sort the room lists in each section by the room name, number of participants, and more by clicking on Room Search.</li>
            </ul>
          </li>
          <li><b>Room Search</b>: You can <b>search</b> for users or room titles.</li>
          <li><a href={homepage}>Read the documentation</a> for more information.</li>
        </ul>
      </Card.Body>
    </Card>
