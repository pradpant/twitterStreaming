%dw 2.0
output application/json
import * from dw::core::URL
import * from dw::core::Strings
import * from dw::util::Timer
import dw::Crypto
import toBase64 from dw::core::Binaries

var oauth_timestamp = floor( currentMilliseconds()/1000 ) as String
var oath_url = p('oauth.url') ++ "/create.json" as String
var secret_key= encodeURIComponent(p('secure::api.consumerSecret')) 
				++ "&" 
				++ encodeURIComponent(p('secure::api.accessTokenSecret'))

var parameter_string = (encodeURIComponent("id") ++ "=" ++ encodeURIComponent(attributes.queryParams.id as String) as String ++ "&"
		++ encodeURIComponent("oauth_consumer_key") ++ "=" ++ encodeURIComponent(p('secure::api.consumerKey')) as String ++ "&"
   	 	++ encodeURIComponent("oauth_nonce") ++ "=" ++ encodeURIComponent(p('oauth.oauth_nonce')) as String ++ "&"
    	++ encodeURIComponent("oauth_signature_method") ++ "=" ++ encodeURIComponent(p('oauth.oauth_signature_method')) as String ++ "&"
    	++ encodeURIComponent("oauth_timestamp") ++ "=" ++ encodeURIComponent(oauth_timestamp as String) as String ++ "&"
        ++ encodeURIComponent("oauth_token") ++ "=" ++ encodeURIComponent(p('secure::api.accessToken')) as String ++ "&"
    	++ encodeURIComponent("oauth_version") ++ "=" ++ encodeURIComponent(p('oauth.oauth_version')) as String ) replace /[!]/ with("%21")

var signature_base_string= p('oauth.method') ++ "&" 
		++ encodeURIComponent(p('oauth.url')) as String ++ "&"
    	++ encodeURIComponent(parameter_string)
   
var signature = encodeURIComponent(toBase64(Crypto::HMACBinary(secret_key as Binary,signature_base_string as Binary, "HmacSHA1")))
---
{
	"Authorization": "OAuth oauth_consumer_key=" ++ '"' ++ p('secure::api.consumerKey') ++ '",' as String
			++ "oauth_token=" ++ '"' ++ p('secure::api.accessToken') ++ '",' as String
			++ "oauth_signature_method=" ++ '"' ++ p('oauth.oauth_signature_method') ++ '",' as String
			++ "oauth_timestamp=" ++ '"' ++ oauth_timestamp ++ '",'  as String
			++ "oauth_nonce=" ++ '"' ++ p('oauth.oauth_nonce') ++ '",' as String
			++ "oauth_version=" ++ '"' ++ p('oauth.oauth_version') ++ '",' as String
			++ "oauth_signature=" ++ '"' ++ signature as String
			
}
//base
