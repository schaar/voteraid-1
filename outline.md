# Request Process (WIP)

#### Initial request

1. Ask for location
2. User responds with location
3. Ask user what issue is
4. User responds with issue
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
5. Ask if user needs a responder;
6. if yes, contact responders; if no, set value to resolved
7. If responder confirms, send info to user
8. Let us know it has been resolved or not?
9. Resolved

### Routing Process
- Store request ID in session
- Check status of request when message comes in
- Route to handler for status of request
