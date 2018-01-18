package perfSONAR_PS::PSConfig::MaDDash::Schema;


use strict;
use warnings;
use JSON;

use base 'Exporter';

our @EXPORT_OK = qw( psconfig_maddash_json_schema );

=item psconfig_maddash_json_schema()

Returns the JSON schema

=cut

sub psconfig_maddash_json_schema() {

    my $raw_json = <<'EOF';
{
    "id": "http://www.perfsonar.net/psconfig-maddash-agent-schema#",
    "$schema": "http://json-schema.org/draft-04/schema#",
    "title": "pSConfig MaDDash Agent Schema",
    "description": "Schema for pSConfig MaDDash agent configuration file. This is the file that tells the agent what pSConfig files to download and controls basic behaviors of agent script.",
    "type": "object",
    "additionalProperties": false,
    "required": [],
    "properties": {
    
        "remotes": {
            "type": "array",
            "items": { "$ref": "#/pSConfig/RemoteSpecification" },
            "description": "List of remote pSConfig JSON files to to read"
        }, 
                
        "include-directory": {
            "type": "string",
            "description": "Directory with local pSConfig files to be processed. Default is /etc/psconfig/maddash.d"
        },
        
        "archive-directory": {
            "type": "string",
            "description": "Directory with default archives to be added to all tasks. Default is /etc/psconfig/archives.d"
        },
        
        "transform-directory": {
            "type": "string",
            "description": "Directory with default transformations to apply to JSON processed by agent. Default is /etc/psconfig/transforms.d"
        },
        
        "requesting-agent-file": {
            "type": "string",
            "description": "Path to file defining JSON to be used as the requesting-agent data source in address classes. Default is /etc/psconfig/requesting-agent.json. If file does not exist, a default set of JSON will be generated based on local host interfaces."
        },
        
        "check-interval": {
            "$ref": "#/pSConfig/Duration",
            "description": "ISO8601 indicating how often to check for changes to the pSConfig files in remotes and includes. Default is 1 hour ('PT1H')."
        },
        
        "check-config-interval": {
            "$ref": "#/pSConfig/Duration",
            "description": "ISO8601 indicating how often to check for changes to the local configuration files. This includes this config file, the includes directory, the requesting-agent file and the archives directory. Default is 1 minute ('PT60S')."
        }

    },
    
    "pSConfig": {
        
        "AddressMap": {
            "type": "object",
            "patternProperties": { 
                "^[a-zA-Z0-9:._\\-]+$": { "$ref": "#/pSConfig/Host" }
            },
            "additionalProperties": false
        },
        
        "Cardinal": {
            "type": "integer",
            "minimum": 1
        },
    
        "Duration": {
            "type": "string",
            "pattern": "^P(?:\\d+(?:\\.\\d+)?W)?(?:\\d+(?:\\.\\d+)?D)?(?:T(?:\\d+(?:\\.\\d+)?H)?(?:\\d+(?:\\.\\d+)?M)?(?:\\d+(?:\\.\\d+)?S)?)?$",
            "x-invalid-message": "'%s' is not a valid ISO 8601 duration."
        },
        
        "Host": {
            "anyOf": [
                { "$ref": "#/pSConfig/HostName" },
                { "$ref": "#/pSConfig/IPAddress" }
            ]
        },
        
        "HostName": {
            "type": "string",
            "format": "hostname"
        },
        
        "HostNamePort": {
            "type": "string",
            "pattern": "^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9])(:[0-9]+)?$"
        },

        "IPAddress": {
            "oneOf": [
                { "type": "string", "format": "ipv4" },
                { "type": "string", "format": "ipv6" }
            ]
        },
        
        "IPv6RFC2732": {
            "type": "string",
            "pattern": "^\\[(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))\\](:[0-9]+)?$"
        },
        
        "JQTransformSpecification": {
            "type": "object",
            "properties": {
                "script":   {
                    "anyOf": [
                        { "type": "string" },
                        { "type": "array", "items": { "type": "string" } }
                    ]
                }
            },
            "additionalProperties": false,
            "required": [ "script" ]
        },
        
        "Probability": {
            "type": "number",
            "minimum": 0.0,
            "maximum": 1.0
        },
        
        "RemoteSpecification": {
            "type": "object",
            "properties": {
                "url": { 
                    "type": "string", 
                    "format": "uri",
                    "description": "URL of psconfig file to read"
                    
                },
                "configure-archives": { 
                    "type": "boolean",
                    "description": "If true will use archives specified in remote psconfig file. Default it false."
                },
                "transform": { 
                    "$ref": "#/pSConfig/JQTransformSpecification",
                    "description": "JQ script to transform downloaded pSConfig JSON"
                    
                },
                "bind-address": { 
                    "$ref": "#/pSConfig/Host",
                    "description": "Local address to use when downloading JSON. Default is to let local routing tables choose."
                },
                "ssl-validate-certificate": { 
                    "type": "boolean",
                    "description": "If true, validates SSL certificate common name matches hostname. Default is false." 
                },
                "ssl-ca-file": { 
                    "type": "string",
                    "description": "A typical certificate authority (CA) file found on BSD. Used to verify server SSL certificate when using https." 
                },
                "ssl-ca-path": { 
                    "type": "string",
                    "description": "A typical certificate authority (CA) path found on Linux. Used to verify server SSL certificate when using https." 
                }
            },
            "additionalProperties": false,
            "required": [ "url" ]
        },
        
        "URLHostPort": {
            "anyOf": [
                { "$ref": "#/pSConfig/HostNamePort" },
                { "$ref": "#/pSConfig/IPv6RFC2732" }
            ]
        }
    }
}
EOF

    return from_json($raw_json);
}