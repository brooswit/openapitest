#!/usr/bin/env bash

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !
# ! Note:
# !
# ! THIS SCRIPT HAS BEEN AUTOMATICALLY GENERATED USING
# ! swagger-codegen (https://github.com/swagger-api/swagger-codegen)
# ! FROM SWAGGER SPECIFICATION IN JSON.
# !
# ! Generated on: 2017-09-08T14:02:08.289-07:00
# !
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#
# This is a Bash client for LaunchDarkly REST API.
#
# LICENSE:
# http://www.apache.org/licenses/LICENSE-2.0.html
#
# CONTACT:
# support@launchdarkly.com
#
# MORE INFORMATION:
# 
#

###############################################################################
#
# Make sure Bash is at least in version 4.3
#
###############################################################################
if ! ( (("${BASH_VERSION:0:1}" == "4")) && (("${BASH_VERSION:2:1}" >= "3")) ) \
  && ! (("${BASH_VERSION:0:1}" >= "5")); then
    echo ""
    echo "Sorry - your Bash version is ${BASH_VERSION}"
    echo ""
    echo "You need at least Bash 4.3 to run this script."
    echo ""
    exit 1
fi

###############################################################################
#
# Global variables
#
###############################################################################

##
# The filename of this script for help messages
script_name=`basename "$0"`

##
# Map for headers passed after operation as KEY:VALUE
declare -A header_arguments


##
# Map for operation parameters passed after operation as PARAMETER=VALUE
# These will be mapped to appropriate path or query parameters
# The values in operation_parameters are arrays, so that multiple values
# can be provided for the same parameter if allowed by API specification
declare -A operation_parameters

##
# This array stores the minimum number of required occurences for parameter
# 0 - optional
# 1 - required
declare -A operation_parameters_minimum_occurences
operation_parameters_minimum_occurences["deleteWebhook:::webhookId"]=1
operation_parameters_minimum_occurences["getWebhook:::webhookId"]=1
operation_parameters_minimum_occurences["patchWebhook:::webhookId"]=1
operation_parameters_minimum_occurences["patchWebhook:::patchDelta"]=1
operation_parameters_minimum_occurences["postWebhook:::webhookPost"]=1

##
# This array stores the maximum number of allowed occurences for parameter
# 1 - single value
# 2 - 2 values
# N - N values
# 0 - unlimited
declare -A operation_parameters_maximum_occurences
operation_parameters_maximum_occurences["deleteWebhook:::webhookId"]=0
operation_parameters_maximum_occurences["getWebhook:::webhookId"]=0
operation_parameters_maximum_occurences["patchWebhook:::webhookId"]=0
operation_parameters_maximum_occurences["patchWebhook:::patchDelta"]=0
operation_parameters_maximum_occurences["postWebhook:::webhookPost"]=0

##
# The type of collection for specifying multiple values for parameter:
# - multi, csv, ssv, tsv
declare -A operation_parameters_collection_type
operation_parameters_collection_type["deleteWebhook:::webhookId"]=""
operation_parameters_collection_type["getWebhook:::webhookId"]=""
operation_parameters_collection_type["patchWebhook:::webhookId"]=""
operation_parameters_collection_type["patchWebhook:::patchDelta"]=
operation_parameters_collection_type["postWebhook:::webhookPost"]=""


##
# Map for body parameters passed after operation as
# PARAMETER==STRING_VALUE or PARAMETER:=NUMERIC_VALUE
# These will be mapped to top level json keys ( { "PARAMETER": "VALUE" })
declare -A body_parameters

##
# These arguments will be directly passed to cURL
curl_arguments=""

##
# The host for making the request
host=""

##
# The user credentials for basic authentication
basic_auth_credential=""

##
# The user API key
apikey_auth_credential=""

##
# If true, the script will only output the actual cURL command that would be
# used
print_curl=false

##
# The operation ID passed on the command line
operation=""

##
# The provided Accept header value
header_accept=""

##
# The provided Content-type header value
header_content_type=""

##
# If there is any body content on the stdin pass it to the body of the request
body_content_temp_file=""

##
# If this variable is set to true, the request will be performed even
# if parameters for required query, header or body values are not provided
# (path parameters are still required).
force=false

##
# Declare some mime types abbreviations for easier content-type and accepts
# headers specification
declare -A mime_type_abbreviations
# text/*
mime_type_abbreviations["text"]="text/plain"
mime_type_abbreviations["html"]="text/html"
mime_type_abbreviations["md"]="text/x-markdown"
mime_type_abbreviations["csv"]="text/csv"
mime_type_abbreviations["css"]="text/css"
mime_type_abbreviations["rtf"]="text/rtf"
# application/*
mime_type_abbreviations["json"]="application/json"
mime_type_abbreviations["xml"]="application/xml"
mime_type_abbreviations["yaml"]="application/yaml"
mime_type_abbreviations["js"]="application/javascript"
mime_type_abbreviations["bin"]="application/octet-stream"
mime_type_abbreviations["rdf"]="application/rdf+xml"
# image/*
mime_type_abbreviations["jpg"]="image/jpeg"
mime_type_abbreviations["png"]="image/png"
mime_type_abbreviations["gif"]="image/gif"
mime_type_abbreviations["bmp"]="image/bmp"
mime_type_abbreviations["tiff"]="image/tiff"


##############################################################################
#
# Escape special URL characters
# Based on table at http://www.w3schools.com/tags/ref_urlencode.asp
#
##############################################################################
url_escape() {
    local raw_url="$1"

    value=$(sed -e 's/ /%20/g' \
       -e 's/!/%21/g' \
       -e 's/"/%22/g' \
       -e 's/#/%23/g' \
       -e 's/\&/%26/g' \
       -e 's/'\''/%28/g' \
       -e 's/(/%28/g' \
       -e 's/)/%29/g' \
       -e 's/:/%3A/g' \
       -e 's/?/%3F/g' <<<$raw_url);

    echo $value
}

##############################################################################
#
# Lookup the mime type abbreviation in the mime_type_abbreviations array.
# If not present assume the user provided a valid mime type
#
##############################################################################
lookup_mime_type() {
    local mime_type=$1

    if [[ ${mime_type_abbreviations[$mime_type]} ]]; then
        echo ${mime_type_abbreviations[$mime_type]}
    else
        echo $1
    fi
}

##############################################################################
#
# Converts an associative array into a list of cURL header
# arguments (-H "KEY: VALUE")
#
##############################################################################
header_arguments_to_curl() {
    local headers_curl=""
    local api_key_header=""
    local api_key_header_in_cli=""
    api_key_header="Authorization"

    for key in "${!header_arguments[@]}"; do
        headers_curl+="-H \"${key}: ${header_arguments[${key}]}\" "
        if [[ "${key}XX" == "${api_key_header}XX" ]]; then
            api_key_header_in_cli="YES"
        fi
    done
    #
    # If the api_key was not provided in the header, try one from the
    # environment variable
    #
    if [[ -z $api_key_header_in_cli && -n $apikey_auth_credential ]]; then
        headers_curl+="-H \"${api_key_header}: ${apikey_auth_credential}\""
    fi
    headers_curl+=" "

    echo "${headers_curl}"
}

##############################################################################
#
# Converts an associative array into a simple JSON with keys as top
# level object attributes
#
# \todo Add convertion of more complex attributes using paths
#
##############################################################################
body_parameters_to_json() {
    local body_json="-d '{"
    local body_parameter_count=${#body_parameters[@]}
    local count=0
    for key in "${!body_parameters[@]}"; do
        body_json+="\"${key}\": ${body_parameters[${key}]}"
        if [[ $count -lt $body_parameter_count-1 ]]; then
            body_json+=", "
        fi
        ((count+=1))
    done
    body_json+="}'"

    if [[ "${#body_parameters[@]}" -eq 0 ]]; then
        echo ""
    else
        echo "${body_json}"
    fi
}

##############################################################################
#
# Check if provided parameters match specification requirements
#
##############################################################################
validate_request_parameters() {
    local path_template=$1
    local -n path_params=$2
    local -n query_params=$3

    # First replace all path parameters in the path
    for pparam in "${path_params[@]}"; do
        regexp="(.*)(\{$pparam\})(.*)"
        if [[ $path_template =~ $regexp ]]; then
            path_template=${BASH_REMATCH[1]}${operation_parameters[$pparam]}${BASH_REMATCH[3]}
        fi
    done

    # Now append query parameters - if any
    if [[ ${#query_params[@]} -gt 0 ]]; then
        path_template+="?"
    fi

    local query_parameter_count=${#query_params[@]}
    local count=0
    for qparam in "${query_params[@]}"; do
        # Get the array of parameter values
        local parameter_values=($(echo "${operation_parameters[$qparam]}" | sed -e 's/'":::"'/\n/g' | while read line; do echo $line | sed 's/[\t ]/'":::"'/g'; done))

        #
        # Check if the number of provided values is not less than minimum
        # required
        #
        if [[ "$force" = false ]]; then
            if [[ ${#parameter_values[@]} -lt ${operation_parameters_minimum_occurences["${operation}:::${qparam}"]} ]]; then
                echo "Error: Too few values provided for '${qparam}' parameter"
                exit 1
            fi

            #
            # Check if the number of provided values is not more than maximum
            #
            if [[ ${operation_parameters_maximum_occurences["${operation}:::${qparam}"]} -gt 0 \
                  && ${#parameter_values[@]} -gt ${operation_parameters_maximum_occurences["${operation}:::${qparam}"]} ]]; then
                if [[ "$force" = false ]]; then
                    echo "Error: Too many values provided for '${qparam}' parameter"
                    exit 1
                fi
            fi
        fi

        if [[ "${operation_parameters_collection_type[${operation}:::${qparam}]}" == "" ]]; then
            local vcount=0
            for qvalue in "${parameter_values[@]}"; do
                path_template+="${qparam}=${qvalue}"

                if [[ $vcount -lt ${#parameter_values[@]}-1 ]]; then
                    path_template+="&"
                fi
                ((vcount+=1))
            done
        elif [[ "${operation_parameters_collection_type["${operation}:::${qparam}"]}" == "multi" ]]; then
            local vcount=0
            for qvalue in "${parameter_values[@]}"; do
                path_template+="${qparam}=${qvalue}"

                if [[ $vcount -lt ${#parameter_values[@]}-1 ]]; then
                    path_template+="&"
                fi
                ((vcount+=1))
            done
        elif [[ "${operation_parameters_collection_type["${operation}:::${qparam}"]}" == "csv" ]]; then
            path_template+="${qparam}="
            local vcount=0
            for qvalue in "${parameter_values[@]}"; do
                path_template+="${qvalue}"

                if [[ $vcount -lt ${#parameter_values[@]}-1 ]]; then
                    path_template+=","
                fi
                ((vcount+=1))
            done
        elif [[ "${operation_parameters_collection_type["${operation}:::${qparam}"]}" == "ssv" ]]; then
            path_template+="${qparam}="
            for qvalue in "${parameter_values[@]}"; do
                path_template+="${qvalue}"

                if [[ $vcount -lt ${#parameter_values[@]}-1 ]]; then
                    path_template+=" "
                fi
                ((vcount+=1))
            done
        elif [[ "${operation_parameters_collection_type["${operation}:::${qparam}"]}" == "tsv" ]]; then
            path_template+="${qparam}="
            for qvalue in "${parameter_values[@]}"; do
                path_template+="${qvalue}"

                if [[ $vcount -lt ${#parameter_values[@]}-1 ]]; then
                    path_template+="\t"
                fi
                ((vcount+=1))
            done
        else
            echo -e ""
            echo -e "Error: Unsupported collection format "
            echo -e ""
            exit 1
        fi


        if [[ $count -lt $query_parameter_count-1 ]]; then
            path_template+="&"
        fi
        ((count+=1))
    done

}



##############################################################################
#
# Build request path including query parameters
#
##############################################################################
build_request_path() {
    local path_template=$1
    local -n path_params=$2
    local -n query_params=$3


    # First replace all path parameters in the path
    for pparam in "${path_params[@]}"; do
        regexp="(.*)(\{$pparam\})(.*)"
        if [[ $path_template =~ $regexp ]]; then
            path_template=${BASH_REMATCH[1]}${operation_parameters[$pparam]}${BASH_REMATCH[3]}
        fi
    done

    local query_request_part=""

    local query_parameter_count=${#query_params[@]}
    local count=0
    for qparam in "${query_params[@]}"; do
        # Get the array of parameter values
        local parameter_values=($(echo "${operation_parameters[$qparam]}" | sed -e 's/'":::"'/\n/g' | while read line; do echo $line | sed 's/[\t ]/'":::"'/g'; done))
        local parameter_value=""

        #
        # Check if the number of provided values is not less than minimum
        # required
        #
        if [[ "$force" = false ]]; then
            if [[ ${#parameter_values[@]} -lt ${operation_parameters_minimum_occurences["${operation}:::${qparam}"]} ]]; then
                echo "Error: Too few values provided for '${qparam}' parameter"
                exit 1
            fi

            #
            # Check if the number of provided values is not more than maximum
            #
            if [[ ${operation_parameters_maximum_occurences["${operation}:::${qparam}"]} -gt 0 \
                  && ${#parameter_values[@]} -gt ${operation_parameters_maximum_occurences["${operation}:::${qparam}"]} ]]; then
                if [[ "$force" = false ]]; then
                    echo "Error: Too many values provided for '${qparam}' parameter"
                    exit 1
                fi
            fi
        fi

        #
        # Append parameters without specific cardinality
        #
        if [[ "${operation_parameters_collection_type["${operation}:::${qparam}"]}" == "" ]]; then
            local vcount=0
            for qvalue in "${parameter_values[@]}"; do
                parameter_value+="${qparam}=${qvalue}"

                if [[ $vcount -lt ${#parameter_values[@]}-1 ]]; then
                    parameter_value+="&"
                fi
                ((vcount+=1))
            done
        #
        # Append parameters specified as 'mutli' collections i.e. param=value1&param=value2&...
        #
        elif [[ "${operation_parameters_collection_type["${operation}:::${qparam}"]}" == "multi" ]]; then
            local vcount=0
            for qvalue in "${parameter_values[@]}"; do
                parameter_value+="${qparam}=${qvalue}"

                if [[ $vcount -lt ${#parameter_values[@]}-1 ]]; then
                    parameter_value+="&"
                fi
                ((vcount+=1))
            done
        #
        # Append parameters specified as 'csv' collections i.e. param=value1,value2,...
        #
        elif [[ "${operation_parameters_collection_type["${operation}:::${qparam}"]}" == "csv" ]]; then
            parameter_value+="${qparam}="
            local vcount=0
            for qvalue in "${parameter_values[@]}"; do
                parameter_value+="${qvalue}"

                if [[ $vcount -lt ${#parameter_values[@]}-1 ]]; then
                    parameter_value+=","
                fi
                ((vcount+=1))
            done
        #
        # Append parameters specified as 'ssv' collections i.e. param="value1 value2 ..."
        #
        elif [[ "${operation_parameters_collection_type["${operation}:::${qparam}"]}" == "ssv" ]]; then
            parameter_value+="${qparam}="
            local vcount=0
            for qvalue in "${parameter_values[@]}"; do
                parameter_value+="${qvalue}"

                if [[ $vcount -lt ${#parameter_values[@]}-1 ]]; then
                    parameter_value+=" "
                fi
                ((vcount+=1))
            done
        #
        # Append parameters specified as 'tsv' collections i.e. param="value1\tvalue2\t..."
        #
        elif [[ "${operation_parameters_collection_type["${operation}:::${qparam}"]}" == "tsv" ]]; then
            parameter_value+="${qparam}="
            local vcount=0
            for qvalue in "${parameter_values[@]}"; do
                parameter_value+="${qvalue}"

                if [[ $vcount -lt ${#parameter_values[@]}-1 ]]; then
                    parameter_value+="\t"
                fi
                ((vcount+=1))
            done
        fi

        if [[ -n "${parameter_value}" ]]; then
            query_request_part+="${parameter_value}"
        fi

        if [[ $count -lt $query_parameter_count-1 && -n "${parameter_value}" ]]; then
            query_request_part+="&"
        fi

        ((count+=1))
    done


    # Now append query parameters - if any
    if [[ -n "${query_request_part}" ]]; then
        path_template+="?$(echo ${query_request_part} | sed s'/&$//')"
    fi

    echo $path_template
}



###############################################################################
#
# Print main help message
#
###############################################################################
print_help() {
cat <<EOF

$(tput bold)$(tput setaf 7)LaunchDarkly REST API command line client (API version 2.0.0)$(tput sgr0)

$(tput bold)$(tput setaf 7)Usage$(tput sgr0)

  $(tput setaf 2)${script_name}$(tput sgr0) [-h|--help] [-V|--version] [--about] [$(tput setaf 1)<curl-options>$(tput sgr0)]
           [-ac|--accept $(tput setaf 2)<mime-type>$(tput sgr0)] [-ct,--content-type $(tput setaf 2)<mime-type>$(tput sgr0)]
           [--host $(tput setaf 6)<url>$(tput sgr0)] [--dry-run] $(tput setaf 3)<operation>$(tput sgr0) [-h|--help] [$(tput setaf 4)<headers>$(tput sgr0)]
           [$(tput setaf 5)<parameters>$(tput sgr0)] [$(tput setaf 5)<body-parameters>$(tput sgr0)]

  - $(tput setaf 6)<url>$(tput sgr0) - endpoint of the REST service without basepath

  - $(tput setaf 1)<curl-options>$(tput sgr0) - any valid cURL options can be passed before $(tput setaf 3)<operation>$(tput sgr0)
  - $(tput setaf 2)<mime-type>$(tput sgr0) - either full mime-type or one of supported abbreviations:
                   (text, html, md, csv, css, rtf, json, xml, yaml, js, bin,
                    rdf, jpg, png, gif, bmp, tiff)
  - $(tput setaf 4)<headers>$(tput sgr0) - HTTP headers can be passed in the form $(tput setaf 3)HEADER$(tput sgr0):$(tput setaf 4)VALUE$(tput sgr0)
  - $(tput setaf 5)<parameters>$(tput sgr0) - REST operation parameters can be passed in the following
                   forms:
                   * $(tput setaf 3)KEY$(tput sgr0)=$(tput setaf 4)VALUE$(tput sgr0) - path or query parameters
  - $(tput setaf 5)<body-parameters>$(tput sgr0) - simple JSON body content (first level only) can be build
                        using the following arguments:
                        * $(tput setaf 3)KEY$(tput sgr0)==$(tput setaf 4)VALUE$(tput sgr0) - body parameters which will be added to body
                                      JSON as '{ ..., "$(tput setaf 3)KEY$(tput sgr0)": "$(tput setaf 4)VALUE$(tput sgr0)", ... }'
                        * $(tput setaf 3)KEY$(tput sgr0):=$(tput setaf 4)VALUE$(tput sgr0) - body parameters which will be added to body
                                      JSON as '{ ..., "$(tput setaf 3)KEY$(tput sgr0)": $(tput setaf 4)VALUE$(tput sgr0), ... }'

EOF
    echo -e "$(tput bold)$(tput setaf 7)Authentication methods$(tput sgr0)"
    echo -e ""
    echo -e "  - $(tput setaf 4)Api-key$(tput sgr0) - add '$(tput setaf 1)Authorization:<api-key>$(tput sgr0)' after $(tput setaf 3)<operation>$(tput sgr0)"
    
    echo ""
    echo -e "$(tput bold)$(tput setaf 7)Operations (grouped by tags)$(tput sgr0)"
    echo ""
    echo -e "$(tput bold)$(tput setaf 7)[root]$(tput sgr0)"
read -d '' ops <<EOF
  $(tput setaf 6)getRoot$(tput sgr0);Get the root resource
EOF
echo "  $ops" | column -t -s ';'
    echo ""
    echo -e "$(tput bold)$(tput setaf 7)[webhooks]$(tput sgr0)"
read -d '' ops <<EOF
  $(tput setaf 6)deleteWebhook$(tput sgr0);Delete a webhook by ID
  $(tput setaf 6)getWebhook$(tput sgr0);Get a webhook by ID
  $(tput setaf 6)getWebhooks$(tput sgr0);Fetch a list of all webhooks
  $(tput setaf 6)patchWebhook$(tput sgr0);Modify a webhook by ID
  $(tput setaf 6)postWebhook$(tput sgr0);Create a webhook
EOF
echo "  $ops" | column -t -s ';'
    echo ""
    echo -e "$(tput bold)$(tput setaf 7)Options$(tput sgr0)"
    echo -e "  -h,--help\t\t\t\tPrint this help"
    echo -e "  -V,--version\t\t\t\tPrint API version"
    echo -e "  --about\t\t\t\tPrint the information about service"
    echo -e "  --host $(tput setaf 6)<url>$(tput sgr0)\t\t\t\tSpecify the host URL "
echo -e "              \t\t\t\t(e.g. 'https://app.launchdarkly.com')"

    echo -e "  --force\t\t\t\tForce command invocation in spite of missing"
    echo -e "         \t\t\t\trequired parameters or wrong content type"
    echo -e "  --dry-run\t\t\t\tPrint out the cURL command without"
    echo -e "           \t\t\t\texecuting it"
    echo -e "  -ac,--accept $(tput setaf 3)<mime-type>$(tput sgr0)\t\tSet the 'Accept' header in the request"
    echo -e "  -ct,--content-type $(tput setaf 3)<mime-type>$(tput sgr0)\tSet the 'Content-type' header in "
    echo -e "                                \tthe request"
    echo ""
}


##############################################################################
#
# Print REST service description
#
##############################################################################
print_about() {
    echo ""
    echo -e "$(tput bold)$(tput setaf 7)LaunchDarkly REST API command line client (API version 2.0.0)$(tput sgr0)"
    echo ""
    echo -e "License: Apache 2.0"
    echo -e "Contact: support@launchdarkly.com"
    echo ""
read -d '' appdescription <<EOF

Build custom integrations with the LaunchDarkly REST API
EOF
echo "$appdescription" | fold -sw 80
}


##############################################################################
#
# Print REST api version
#
##############################################################################
print_version() {
    echo ""
    echo -e "$(tput bold)LaunchDarkly REST API command line client (API version 2.0.0)$(tput sgr0)"
    echo ""
}

##############################################################################
#
# Print help for getRoot operation
#
##############################################################################
print_getRoot_help() {
    echo ""
    echo -e "$(tput bold)$(tput setaf 7)getRoot - Get the root resource$(tput sgr0)"
    echo -e ""
    echo ""
    echo -e "$(tput bold)$(tput setaf 7)Responses$(tput sgr0)"
    case 200 in
        1*)
        echo -e "$(tput setaf 7)  200;A list of links to available resources in the API$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        2*)
        echo -e "$(tput setaf 2)  200;A list of links to available resources in the API$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        3*)
        echo -e "$(tput setaf 3)  200;A list of links to available resources in the API$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        4*)
        echo -e "$(tput setaf 1)  200;A list of links to available resources in the API$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        5*)
        echo -e "$(tput setaf 5)  200;A list of links to available resources in the API$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        *)
        echo -e "$(tput setaf 7)  200;A list of links to available resources in the API$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
    esac
    case 401 in
        1*)
        echo -e "$(tput setaf 7)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        2*)
        echo -e "$(tput setaf 2)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        3*)
        echo -e "$(tput setaf 3)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        4*)
        echo -e "$(tput setaf 1)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        5*)
        echo -e "$(tput setaf 5)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        *)
        echo -e "$(tput setaf 7)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
    esac
}
##############################################################################
#
# Print help for deleteWebhook operation
#
##############################################################################
print_deleteWebhook_help() {
    echo ""
    echo -e "$(tput bold)$(tput setaf 7)deleteWebhook - Delete a webhook by ID$(tput sgr0)"
    echo -e ""
    echo -e "$(tput bold)$(tput setaf 7)Parameters$(tput sgr0)"
    echo -e "  * $(tput setaf 2)webhookId$(tput sgr0) $(tput setaf 4)[String]$(tput sgr0) $(tput setaf 1)(required)$(tput sgr0)$(tput sgr0) - The webhook ID $(tput setaf 3)Specify as: webhookId=value$(tput sgr0)" | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "$(tput bold)$(tput setaf 7)Responses$(tput sgr0)"
    case 204 in
        1*)
        echo -e "$(tput setaf 7)  204;Action completed successfully$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        2*)
        echo -e "$(tput setaf 2)  204;Action completed successfully$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        3*)
        echo -e "$(tput setaf 3)  204;Action completed successfully$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        4*)
        echo -e "$(tput setaf 1)  204;Action completed successfully$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        5*)
        echo -e "$(tput setaf 5)  204;Action completed successfully$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        *)
        echo -e "$(tput setaf 7)  204;Action completed successfully$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
    esac
    case 401 in
        1*)
        echo -e "$(tput setaf 7)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        2*)
        echo -e "$(tput setaf 2)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        3*)
        echo -e "$(tput setaf 3)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        4*)
        echo -e "$(tput setaf 1)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        5*)
        echo -e "$(tput setaf 5)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        *)
        echo -e "$(tput setaf 7)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
    esac
    case 404 in
        1*)
        echo -e "$(tput setaf 7)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        2*)
        echo -e "$(tput setaf 2)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        3*)
        echo -e "$(tput setaf 3)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        4*)
        echo -e "$(tput setaf 1)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        5*)
        echo -e "$(tput setaf 5)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        *)
        echo -e "$(tput setaf 7)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
    esac
}
##############################################################################
#
# Print help for getWebhook operation
#
##############################################################################
print_getWebhook_help() {
    echo ""
    echo -e "$(tput bold)$(tput setaf 7)getWebhook - Get a webhook by ID$(tput sgr0)"
    echo -e ""
    echo -e "$(tput bold)$(tput setaf 7)Parameters$(tput sgr0)"
    echo -e "  * $(tput setaf 2)webhookId$(tput sgr0) $(tput setaf 4)[String]$(tput sgr0) $(tput setaf 1)(required)$(tput sgr0)$(tput sgr0) - The webhook ID $(tput setaf 3)Specify as: webhookId=value$(tput sgr0)" | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "$(tput bold)$(tput setaf 7)Responses$(tput sgr0)"
    case 200 in
        1*)
        echo -e "$(tput setaf 7)  200;Webhook response$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        2*)
        echo -e "$(tput setaf 2)  200;Webhook response$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        3*)
        echo -e "$(tput setaf 3)  200;Webhook response$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        4*)
        echo -e "$(tput setaf 1)  200;Webhook response$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        5*)
        echo -e "$(tput setaf 5)  200;Webhook response$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        *)
        echo -e "$(tput setaf 7)  200;Webhook response$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
    esac
    case 401 in
        1*)
        echo -e "$(tput setaf 7)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        2*)
        echo -e "$(tput setaf 2)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        3*)
        echo -e "$(tput setaf 3)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        4*)
        echo -e "$(tput setaf 1)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        5*)
        echo -e "$(tput setaf 5)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        *)
        echo -e "$(tput setaf 7)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
    esac
    case 404 in
        1*)
        echo -e "$(tput setaf 7)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        2*)
        echo -e "$(tput setaf 2)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        3*)
        echo -e "$(tput setaf 3)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        4*)
        echo -e "$(tput setaf 1)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        5*)
        echo -e "$(tput setaf 5)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        *)
        echo -e "$(tput setaf 7)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
    esac
}
##############################################################################
#
# Print help for getWebhooks operation
#
##############################################################################
print_getWebhooks_help() {
    echo ""
    echo -e "$(tput bold)$(tput setaf 7)getWebhooks - Fetch a list of all webhooks$(tput sgr0)"
    echo -e ""
    echo ""
    echo -e "$(tput bold)$(tput setaf 7)Responses$(tput sgr0)"
    case 200 in
        1*)
        echo -e "$(tput setaf 7)  200;Webhooks response$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        2*)
        echo -e "$(tput setaf 2)  200;Webhooks response$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        3*)
        echo -e "$(tput setaf 3)  200;Webhooks response$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        4*)
        echo -e "$(tput setaf 1)  200;Webhooks response$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        5*)
        echo -e "$(tput setaf 5)  200;Webhooks response$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        *)
        echo -e "$(tput setaf 7)  200;Webhooks response$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
    esac
    case 401 in
        1*)
        echo -e "$(tput setaf 7)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        2*)
        echo -e "$(tput setaf 2)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        3*)
        echo -e "$(tput setaf 3)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        4*)
        echo -e "$(tput setaf 1)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        5*)
        echo -e "$(tput setaf 5)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        *)
        echo -e "$(tput setaf 7)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
    esac
}
##############################################################################
#
# Print help for patchWebhook operation
#
##############################################################################
print_patchWebhook_help() {
    echo ""
    echo -e "$(tput bold)$(tput setaf 7)patchWebhook - Modify a webhook by ID$(tput sgr0)"
    echo -e ""
    echo -e "$(tput bold)$(tput setaf 7)Parameters$(tput sgr0)"
    echo -e "  * $(tput setaf 2)webhookId$(tput sgr0) $(tput setaf 4)[String]$(tput sgr0) $(tput setaf 1)(required)$(tput sgr0)$(tput sgr0) - The webhook ID $(tput setaf 3)Specify as: webhookId=value$(tput sgr0)" | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * $(tput setaf 2)body$(tput sgr0) $(tput setaf 4)[application/json]$(tput sgr0) $(tput setaf 1)(required)$(tput sgr0)$(tput sgr0) - http://jsonpatch.com/" | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo ""
    echo -e "$(tput bold)$(tput setaf 7)Responses$(tput sgr0)"
    case 400 in
        1*)
        echo -e "$(tput setaf 7)  400;Invalid request body$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        2*)
        echo -e "$(tput setaf 2)  400;Invalid request body$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        3*)
        echo -e "$(tput setaf 3)  400;Invalid request body$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        4*)
        echo -e "$(tput setaf 1)  400;Invalid request body$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        5*)
        echo -e "$(tput setaf 5)  400;Invalid request body$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        *)
        echo -e "$(tput setaf 7)  400;Invalid request body$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
    esac
    case 401 in
        1*)
        echo -e "$(tput setaf 7)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        2*)
        echo -e "$(tput setaf 2)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        3*)
        echo -e "$(tput setaf 3)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        4*)
        echo -e "$(tput setaf 1)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        5*)
        echo -e "$(tput setaf 5)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        *)
        echo -e "$(tput setaf 7)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
    esac
    case 404 in
        1*)
        echo -e "$(tput setaf 7)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        2*)
        echo -e "$(tput setaf 2)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        3*)
        echo -e "$(tput setaf 3)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        4*)
        echo -e "$(tput setaf 1)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        5*)
        echo -e "$(tput setaf 5)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        *)
        echo -e "$(tput setaf 7)  404;Invalid resource specifier$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
    esac
    case 409 in
        1*)
        echo -e "$(tput setaf 7)  409;Status conflict$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        2*)
        echo -e "$(tput setaf 2)  409;Status conflict$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        3*)
        echo -e "$(tput setaf 3)  409;Status conflict$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        4*)
        echo -e "$(tput setaf 1)  409;Status conflict$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        5*)
        echo -e "$(tput setaf 5)  409;Status conflict$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        *)
        echo -e "$(tput setaf 7)  409;Status conflict$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
    esac
}
##############################################################################
#
# Print help for postWebhook operation
#
##############################################################################
print_postWebhook_help() {
    echo ""
    echo -e "$(tput bold)$(tput setaf 7)postWebhook - Create a webhook$(tput sgr0)"
    echo -e ""
    echo -e "$(tput bold)$(tput setaf 7)Parameters$(tput sgr0)"
    echo -e "  * $(tput setaf 2)body$(tput sgr0) $(tput setaf 4)[application/json]$(tput sgr0) $(tput setaf 1)(required)$(tput sgr0)$(tput sgr0) - New webhook" | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo ""
    echo -e "$(tput bold)$(tput setaf 7)Responses$(tput sgr0)"
    case 201 in
        1*)
        echo -e "$(tput setaf 7)  201;Resource created$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        2*)
        echo -e "$(tput setaf 2)  201;Resource created$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        3*)
        echo -e "$(tput setaf 3)  201;Resource created$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        4*)
        echo -e "$(tput setaf 1)  201;Resource created$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        5*)
        echo -e "$(tput setaf 5)  201;Resource created$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        *)
        echo -e "$(tput setaf 7)  201;Resource created$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
    esac
    case 400 in
        1*)
        echo -e "$(tput setaf 7)  400;Invalid request body$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        2*)
        echo -e "$(tput setaf 2)  400;Invalid request body$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        3*)
        echo -e "$(tput setaf 3)  400;Invalid request body$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        4*)
        echo -e "$(tput setaf 1)  400;Invalid request body$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        5*)
        echo -e "$(tput setaf 5)  400;Invalid request body$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        *)
        echo -e "$(tput setaf 7)  400;Invalid request body$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
    esac
    case 401 in
        1*)
        echo -e "$(tput setaf 7)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        2*)
        echo -e "$(tput setaf 2)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        3*)
        echo -e "$(tput setaf 3)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        4*)
        echo -e "$(tput setaf 1)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        5*)
        echo -e "$(tput setaf 5)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
        *)
        echo -e "$(tput setaf 7)  401;Invalid access token$(tput sgr0)" | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
        ;;
    esac
}


##############################################################################
#
# Call getRoot operation
#
##############################################################################
call_getRoot() {
    local path_parameter_names=()
    local query_parameter_names=()

    if [[ $force = false ]]; then
        validate_request_parameters "/api/v2/" path_parameter_names query_parameter_names
    fi

    local path=$(build_request_path "/api/v2/" path_parameter_names query_parameter_names)
    local method="GET"
    local headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call deleteWebhook operation
#
##############################################################################
call_deleteWebhook() {
    local path_parameter_names=(webhookId)
    local query_parameter_names=()

    if [[ $force = false ]]; then
        validate_request_parameters "/api/v2/webhooks/{webhookId}" path_parameter_names query_parameter_names
    fi

    local path=$(build_request_path "/api/v2/webhooks/{webhookId}" path_parameter_names query_parameter_names)
    local method="DELETE"
    local headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call getWebhook operation
#
##############################################################################
call_getWebhook() {
    local path_parameter_names=(webhookId)
    local query_parameter_names=()

    if [[ $force = false ]]; then
        validate_request_parameters "/api/v2/webhooks/{webhookId}" path_parameter_names query_parameter_names
    fi

    local path=$(build_request_path "/api/v2/webhooks/{webhookId}" path_parameter_names query_parameter_names)
    local method="GET"
    local headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call getWebhooks operation
#
##############################################################################
call_getWebhooks() {
    local path_parameter_names=()
    local query_parameter_names=()

    if [[ $force = false ]]; then
        validate_request_parameters "/api/v2/webhooks" path_parameter_names query_parameter_names
    fi

    local path=$(build_request_path "/api/v2/webhooks" path_parameter_names query_parameter_names)
    local method="GET"
    local headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call patchWebhook operation
#
##############################################################################
call_patchWebhook() {
    local path_parameter_names=(webhookId)
    local query_parameter_names=()

    if [[ $force = false ]]; then
        validate_request_parameters "/api/v2/webhooks/{webhookId}" path_parameter_names query_parameter_names
    fi

    local path=$(build_request_path "/api/v2/webhooks/{webhookId}" path_parameter_names query_parameter_names)
    local method="PATCH"
    local headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    local body_json_curl=""

    #
    # Check if the user provided 'Content-type' headers in the
    # command line. If not try to set them based on the Swagger specification
    # if values produces and consumes are defined unambigously
    #
    if [[ -z $header_content_type ]]; then
        header_content_type="application/json"
    fi


    if [[ -z $header_content_type && "$force" = false ]]; then
        :
        echo "Error: Request's content-type not specified!!!"
        echo "This operation expects content-type in one of the following formats:"
        echo -e "\t- application/json"
        echo ""
        echo "Use '--content-type' to set proper content type"
        exit 1
    else
        headers_curl="${headers_curl} -H 'Content-type: ${header_content_type}'"
    fi


    #
    # If we have received some body content over pipe, pass it from the
    # temporary file to cURL
    #
    if [[ -n $body_content_temp_file ]]; then
        if [[ "$print_curl" = true ]]; then
            echo "cat ${body_content_temp_file} | curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\" -d @-"
        else
            eval "cat ${body_content_temp_file} | curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\" -d @-"
        fi
        rm "${body_content_temp_file}"
    #
    # If not, try to build the content body from arguments KEY==VALUE and KEY:=VALUE
    #
    else
        body_json_curl=$(body_parameters_to_json)
        if [[ "$print_curl" = true ]]; then
            echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} ${body_json_curl} \"${host}${path}\""
        else
            eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} ${body_json_curl} \"${host}${path}\""
        fi
    fi
}

##############################################################################
#
# Call postWebhook operation
#
##############################################################################
call_postWebhook() {
    local path_parameter_names=()
    local query_parameter_names=()

    if [[ $force = false ]]; then
        validate_request_parameters "/api/v2/webhooks" path_parameter_names query_parameter_names
    fi

    local path=$(build_request_path "/api/v2/webhooks" path_parameter_names query_parameter_names)
    local method="POST"
    local headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    local body_json_curl=""

    #
    # Check if the user provided 'Content-type' headers in the
    # command line. If not try to set them based on the Swagger specification
    # if values produces and consumes are defined unambigously
    #
    if [[ -z $header_content_type ]]; then
        header_content_type="application/json"
    fi


    if [[ -z $header_content_type && "$force" = false ]]; then
        :
        echo "Error: Request's content-type not specified!!!"
        echo "This operation expects content-type in one of the following formats:"
        echo -e "\t- application/json"
        echo ""
        echo "Use '--content-type' to set proper content type"
        exit 1
    else
        headers_curl="${headers_curl} -H 'Content-type: ${header_content_type}'"
    fi


    #
    # If we have received some body content over pipe, pass it from the
    # temporary file to cURL
    #
    if [[ -n $body_content_temp_file ]]; then
        if [[ "$print_curl" = true ]]; then
            echo "cat ${body_content_temp_file} | curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\" -d @-"
        else
            eval "cat ${body_content_temp_file} | curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\" -d @-"
        fi
        rm "${body_content_temp_file}"
    #
    # If not, try to build the content body from arguments KEY==VALUE and KEY:=VALUE
    #
    else
        body_json_curl=$(body_parameters_to_json)
        if [[ "$print_curl" = true ]]; then
            echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} ${body_json_curl} \"${host}${path}\""
        else
            eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} ${body_json_curl} \"${host}${path}\""
        fi
    fi
}



##############################################################################
#
# Main
#
##############################################################################


# Check dependencies
type curl >/dev/null 2>&1 || { echo >&2 "Error: You do not have 'cURL' installed."; exit 1; }
type sed >/dev/null 2>&1 || { echo >&2 "Error: You do not have 'sed' installed."; exit 1; }
type column >/dev/null 2>&1 || { echo >&2 "Error: You do not have 'bsdmainutils' installed."; exit 1; }

#
# Process command line
#
# Pass all arguemnts before 'operation' to cURL except the ones we override
#
take_user=false
take_host=false
take_accept_header=false
take_contenttype_header=false

for key in "$@"; do
# Take the value of -u|--user argument
if [[ "$take_user" = true ]]; then
    basic_auth_credential="$key"
    take_user=false
    continue
fi
# Take the value of --host argument
if [[ "$take_host" = true ]]; then
    host="$key"
    take_host=false
    continue
fi
# Take the value of --accept argument
if [[ "$take_accept_header" = true ]]; then
    header_accept=$(lookup_mime_type "$key")
    take_accept_header=false
    continue
fi
# Take the value of --content-type argument
if [[ "$take_contenttype_header" = true ]]; then
    header_content_type=$(lookup_mime_type "$key")
    take_contenttype_header=false
    continue
fi
case $key in
    -h|--help)
    if [[ "x$operation" == "x" ]]; then
        print_help
        exit 0
    else
        eval "print_${operation}_help"
        exit 0
    fi
    ;;
    -V|--version)
    print_version
    exit 0
    ;;
    --about)
    print_about
    exit 0
    ;;
    -u|--user)
    take_user=true
    ;;
    --host)
    take_host=true
    ;;
    --force)
    force=true
    ;;
    -ac|--accept)
    take_accept_header=true
    ;;
    -ct|--content-type)
    take_contenttype_header=true
    ;;
    --dry-run)
    print_curl=true
    ;;
    getRoot)
    operation="getRoot"
    ;;
    deleteWebhook)
    operation="deleteWebhook"
    ;;
    getWebhook)
    operation="getWebhook"
    ;;
    getWebhooks)
    operation="getWebhooks"
    ;;
    patchWebhook)
    operation="patchWebhook"
    ;;
    postWebhook)
    operation="postWebhook"
    ;;
    *==*)
    # Parse body arguments and convert them into top level
    # JSON properties passed in the body content as strings
    if [[ "$operation" ]]; then
        IFS='==' read body_key sep body_value <<< "$key"
        body_parameters[${body_key}]="\"${body_value}\""
    fi
    ;;
    *:=*)
    # Parse body arguments and convert them into top level
    # JSON properties passed in the body content without qoutes
    if [[ "$operation" ]]; then
        IFS=':=' read body_key sep body_value <<< "$key"
        body_parameters[${body_key}]=${body_value}
    fi
    ;;
    *:*)
    # Parse header arguments and convert them into curl
    # only after the operation argument
    if [[ "$operation" ]]; then
        IFS=':' read header_name header_value <<< "$key"
        #
        # If the header key is the same as the api_key expected by API in the
        # header, override the ${apikey_auth_credential} variable
        #
        if [[ $header_name == "Authorization" ]]; then
            apikey_auth_credential=$header_value
        fi
        header_arguments[$header_name]=$header_value
    else
        curl_arguments+=" $key"
    fi
    ;;
    -)
    body_content_temp_file=$(mktemp)
    cat - > $body_content_temp_file
    ;;
    *=*)
    # Parse operation arguments and convert them into curl
    # only after the operation argument
    if [[ "$operation" ]]; then
        IFS='=' read parameter_name parameter_value <<< "$key"
        if [[ -z "${operation_parameters[$parameter_name]+foo}" ]]; then
            operation_parameters[$parameter_name]=$(url_escape "${parameter_value}")
        else
            operation_parameters[$parameter_name]+=":::"$(url_escape "${parameter_value}")
        fi
    else
        curl_arguments+=" $key"
    fi
    ;;
    *)
    # If we are before the operation, treat the arguments as cURL arguments
    if [[ "x$operation" == "x" ]]; then
        # Maintain quotes around cURL arguments if necessary
        space_regexp="[[:space:]]"
        if [[ $key =~ $space_regexp ]]; then
            curl_arguments+=" \"$key\""
        else
            curl_arguments+=" $key"
        fi
    fi
    ;;
esac
done


# Check if user provided host name
if [[ -z "$host" ]]; then
    echo "Error: No hostname provided!!!"
    echo "Check usage: '${script_name} --help'"
    exit 1
fi

# Check if user specified operation ID
if [[ -z "$operation" ]]; then
    echo "Error: No operation specified!"
    echo "Check available operations: '${script_name} --help'"
    exit 1
fi


# Run cURL command based on the operation ID
case $operation in
    getRoot)
    call_getRoot
    ;;
    deleteWebhook)
    call_deleteWebhook
    ;;
    getWebhook)
    call_getWebhook
    ;;
    getWebhooks)
    call_getWebhooks
    ;;
    patchWebhook)
    call_patchWebhook
    ;;
    postWebhook)
    call_postWebhook
    ;;
    *)
    echo "Error: Unknown operation: $operation"
    echo ""
    print_help
    exit 1
esac
