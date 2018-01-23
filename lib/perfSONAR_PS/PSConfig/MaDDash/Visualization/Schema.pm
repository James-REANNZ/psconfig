package perfSONAR_PS::PSConfig::MaDDash::Visualization::Schema;


use strict;
use warnings;
use JSON;

use base 'Exporter';

our @EXPORT_OK = qw( psconfig_maddash_viz_json_schema );

=item psconfig_maddash_viz_json_schema()

Returns the JSON schema

=cut

sub psconfig_maddash_viz_json_schema() {

    my $raw_json = <<'EOF';
{
    "id": "http://www.perfsonar.net/psconfig-maddash-agent-visualization-plugin-schema#",
    "$schema": "http://json-schema.org/draft-04/schema#",
    "title": "pSConfig MaDDash Visualization Plug-In Schema",
    "description": "Schema for pSConfig MaDDash Visualization Plug-ins. This allows people to define new types of visualization to be used in MaDDash",
    "type": "object",
    "additionalProperties": false,
    "required": [ "type", "requires", "defaults", "http-get-opts"],
    "properties": {
    
        "type": {
            "type": "string",
            "description": "Type of check. Used by other config files to reference this check."
        }, 
        
        "requires": {
            "$ref": "#/pSConfig/TaskSelector",
            "description": "Indicates minimum requirements a task must meet to use this task"
        },
        
        "defaults": {
            "$ref": "#/pSConfig/VizDefaults",
            "description": "Default parameters for plug-in"
        },
        
        "vars": {
            "$ref": "#/pSConfig/VizVars",
            "description": "Custom variables that can be used in command-opts, command-args and maddash-check-params in format {% var.VARNAME %}"
        },
        
        "http-get-opts": {
            "$ref": "#/pSConfig/HttpGetOpts",
            "description": "A list of command line options to be used with check. Keys must start with - the value is an object defining when and how to use check"
        }
    },
    
     "pSConfig": {
        
        "AnyJSON": {
            "anyOf": [
                { "type": "array" },
                { "type": "boolean" },
                { "type": "integer" },
                { "type": "null" },
                { "type": "number" },
                { "type": "object" },
                { "type": "string" }
            ]
        },
        
        "HttpGetOpt": {
            "type": "object",
            "properties": { 
                "condition": {
                    "type": "string",
                    "description": "String that must be non-empty string for this condition to evaluate true. Use variables here to make truly conditional."
                },
                "arg": {
                    "type": "string",
                    "description": "Argument to pass to option. Use variables here to set dynamic values."
                },
                "required": {
                    "type": "boolean",
                    "description": "Indicates whether option is required to run"
                } 
            },
            "required": [ "condition", "arg" ],
            "additionalProperties": false
        },
        
        "HttpGetOpts": {
            "type": "object",
            "patternProperties": { 
                "^[a-zA-Z0-9:._\\-]+$": { "$ref": "#/pSConfig/HttpGetOpt" }
            },
            "additionalProperties": false
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
        
        "TaskSelector": {
            "type": "object",
            "properties": {
                "test-type": {
                    "type": "array",
                    "items": { "type": "string" },
                    "description": "Match against any test-type in the list"
                },
                "task-name": {
                    "type": "array",
                    "items": { "type": "string" },
                    "description": "Match against any task name in the list"
                },
                "archive-type": {
                    "type": "array",
                    "items": { "type": "string" },
                    "description": "Match against any archiver with the given type"
                },
                "jq": { 
                    "$ref": "#/pSConfig/JQTransformSpecification",
                    "description": "JQ script to transform downloaded pSConfig JSON"
                    
                }
            },
            "additionalProperties": false
        },
        
        "VizDefaults": {
            "type": "object",
            "properties": {
                "base-url": {
                    "type": "string",
                    "description": "Threshold for warning level"
                },
                "params": {
                    "$ref": "#/pSConfig/AnyJSON",
                    "description": "Plug-in specific parameters. Can use with {% params.PARAMNAME %}"
                }
            },
            "additionalProperties": false,
            "required": [ "base-url" ]
        },
        
        "VizVars": {
            "type": "object",
            "patternProperties": { 
                "^[a-zA-Z0-9:._\\-]+$": { "$ref": "#/pSConfig/JQTransformSpecification" }
            },
            "additionalProperties": false
        }
    }
}
EOF

    return from_json($raw_json);
}