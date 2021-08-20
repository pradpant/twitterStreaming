%dw 2.0
output application/json
---
{
	"text": "https://twitter.com/" ++ payload.username as String ++ "/status/" ++ payload.id
}