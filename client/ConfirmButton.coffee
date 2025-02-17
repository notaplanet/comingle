import React, {useState, useRef} from 'react'
import {Button, ButtonGroup, Tooltip, Overlay} from 'react-bootstrap'
import {FontAwesomeIcon} from '@fortawesome/react-fontawesome'
import {faLock, faLockOpen, faSkullCrossbones, faTrash, faTrashRestore} from '@fortawesome/free-solid-svg-icons'

import {capitalize} from './lib/capitalize'

export ConfirmButton = React.memo ({className, action, prefix, suffix, icon, help, onClick}) ->
  buttonRef = useRef()
  [click, setClick] = useState false
  [hover, setHover] = useState false
  <div className={className}
   aria-label="#{action}#{suffix}"
   onClick={-> setClick not click}
   onMouseEnter={-> setHover true}
   onMouseLeave={-> setHover false}
   onMouseDown={(e) -> e.stopPropagation()}
   onTouchStart={(e) -> e.stopPropagation()}>
    <span ref={buttonRef}>{icon}</span>
    <Overlay target={buttonRef.current} placement="bottom"
     show={hover or click}>
      <Tooltip>
        {prefix}{action}{suffix}
        <div className="small">{help}</div>
        {if click
           <ButtonGroup className="mt-1">
             <Button variant="danger" size="sm"
              onClick={(e) -> onClick e; setClick false; setHover false}>
               {action}
             </Button>
             <Button variant="success" size="sm"
              onClick={-> setHover false; setClick false}>
               Cancel
             </Button>
           </ButtonGroup>
        }
      </Tooltip>
    </Overlay>
  </div>
ConfirmButton.displayName = 'ConfirmButton'

export ArchiveButton = React.memo ({noun, archived, ...props}) ->
  <ConfirmButton
   action="#{if archived then 'Restore' else 'Archive'} #{capitalize noun}"
   suffix=" for Everyone"
   icon={<FontAwesomeIcon icon={if archived then faTrashRestore else faTrash}/>}
   {...props}/>
ArchiveButton.displayName = 'ArchiveButton'

export DeleteButton = React.memo ({noun, ...props}) ->
  <ConfirmButton
   action="Delete #{capitalize noun}"
   prefix="Permanently "
   help="Careful! This operation cannot be undone. #{if noun == 'room' then 'All tabs in this room and their URLs will be permanently lost.' else 'This tab and its URL will be permanently lost.'}"
   icon={<FontAwesomeIcon icon={faSkullCrossbones}/>}
   {...props}/>
DeleteButton.displayName = 'DeleteButton'

export ProtectButton = React.memo ({protected: prot, ...props}) ->
  <ConfirmButton 
   action="#{if prot then 'Unprotect' else 'Protect'} Room"
   icon={<FontAwesomeIcon icon={if prot then faLock else faLockOpen}/>}
   help="Protected rooms cannot be renamed, (un)archived, or have tabs added/edited except by admins."
   {...props}/>
ProtectButton.displayName = 'ProtectButton'
