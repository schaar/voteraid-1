# Request Process (WIP)

#### Initial request

1. Ask for location
2. User responds with location, record it, ask user about issue
  1. Problem with ID
    - respond with ID info
  2. name not on registration list
    - respond with wrong polling place info
  3. eligibility to vote was challenged
  4. can't check in at the poll
    - respond with info
  5. problem with voting machine
  6. line to vote is too long
  7. problem with provisional ballot
  8. other
3. User responds with issue number, record it, return information if needed
4. Ask user if they want to be connected to a responder
5. User respond if need responder.
   -If yes, contact responders "there is a requestor with issue...", return to user immediately "connecting now...";
   -if no, set value to resolved, close case, go to status 8
6. One responder reply, send "closed" to other responders, send requestor info to responder, send responder info to requestor.
7. After some hours, contact requestor "Let us know it has been resolved or not?"
8. Set to resolved
9. Set to not_resolved

### Routing Process
- Store request ID in session
- Check status of request when message comes in
- Route to handler for status of request
