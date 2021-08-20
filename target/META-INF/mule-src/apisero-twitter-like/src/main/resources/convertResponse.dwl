%dw 2.0
output application/json
---
{
	id: payload.id,
    username:payload.user.screen_name   
}