#include <stdio.h>
#include <stdlib.h>

#include <xacml_client.h>
#include "xacml_io_example.h"
/* #include "xacml_attr_obl_profile.h" */


enum xacml_req_section_e {
    X_SUBJECT,
    X_ACTION,
    X_RESOURCE,
    X_ENVIRONMENT
};


xacml_result_t
request_set_explicit_subject_id(xacml_request_t request,
                                const char *subject_id) {
    fprintf(stderr, "XACML setting an explicit subject-id to \"%s\"\n", subject_id);
    return xacml_request_set_subject(request, subject_id);
}

xacml_result_t
request_add_attribute(xacml_request_t request,
                      enum xacml_req_section_e req_sec,
                      const char *xacml_attribute_id,
                      const char *xacml_attribute_datatype,
                      const char *xacml_attribute_issuer,
                      const char *xacml_attribute_value) {
    xacml_result_t res;
    xacml_resource_attribute_t ra;

    fprintf(stderr, "XACML add attribute: section: ");
    switch (req_sec) {
        case X_SUBJECT :
            fprintf(stderr, "\"Subject\" ");
            res = xacml_request_add_subject_attribute(request,
                      XACML_SUBJECT_CATEGORY_ACCESS_SUBJECT,
                      xacml_attribute_id,
                      xacml_attribute_datatype,
                      xacml_attribute_issuer,
                      xacml_attribute_value);
            break;
        case X_ACTION :
            fprintf(stderr, "\"Action\" ");
            res = xacml_request_add_action_attribute(request,
                      xacml_attribute_id,
                      xacml_attribute_datatype,
                      xacml_attribute_issuer,
                      xacml_attribute_value);
            break;
        case X_RESOURCE :
            fprintf(stderr, "\"Resource\" ");
            xacml_resource_attribute_init(&ra);
            xacml_resource_attribute_add(
                ra,
                xacml_attribute_id,
                xacml_attribute_datatype,
                xacml_attribute_issuer,
                xacml_attribute_value);
            xacml_request_add_resource_attribute(request, ra);
            xacml_resource_attribute_destroy(ra);
            break;
        case X_ENVIRONMENT :
            fprintf(stderr, "\"Environment\" ");
            res = xacml_request_add_environment_attribute(request,
                      xacml_attribute_id,
                      xacml_attribute_datatype,
                      xacml_attribute_issuer,
                      xacml_attribute_value);
            break;
        default :
            fprintf(stderr, "\nUnknown section specified. Please use X_SUBJECT, X_ACTION, X_RESOURCE or X_ENVIRONMENT.\n");
            return -1;
    }

    fprintf(stderr, "id: \"%s\", datatype: \"%s\", issuer: \"%s\", value \"%s\"\n",
            xacml_attribute_id,
            xacml_attribute_datatype,
            xacml_attribute_issuer,
            xacml_attribute_value);
    return 0;
}


int main(int argc, char *argv[]) {
    xacml_request_t request=NULL; /* NOTE: is pointer, make sure it's initialized */
    xacml_response_t response=NULL; /* NOTE: is pointer, make sure it's initialized */
    xacml_result_t rc_xacml_query;
    const char *endpoint = "http://centos5.local:6217";

    /* The new default is to enable the TCP/IP keep-alive feature explicitly */
    /* xacml_set_keepalive(XACML_KEEPALIVE_ENABLED); */

    /*** 1. Initialize ***/
    fprintf(stderr, "XACML Initializing...\n");
    xacml_init();
    xacml_request_init(&request);
    xacml_response_init(&response);

    xacml_request_set_io_descriptor(request, &xacml_io_example_descriptor);

#if 0
    /* SSL handler */
    xacml_request_set_io_descriptor(request, &xacml_io_ssl_descriptor);
#endif

    /*** 2. Construct request ***/
    fprintf(stderr, "XACML Request construction...\n");
    request_set_explicit_subject_id(request, "mister Foo Bar");

    request_add_attribute(request, X_SUBJECT,
                          "subject-id",
                          XACML_DATATYPE_STRING,
                          "",
                          "mister Foo Bar");

    request_add_attribute(request, X_ACTION,
                          "action-id",
                          XACML_DATATYPE_STRING,
                          "",
                          "challenge");

    request_add_attribute(request, X_RESOURCE,
                          "resource-id",
                          XACML_DATATYPE_STRING,
                          "",
                          "fight club");

    /*** 3. XACML Request Query ***/
    fprintf(stderr, "XACML Request Query...\n");
    rc_xacml_query = xacml_query(endpoint, request, response);
    switch (rc_xacml_query) {
        case XACML_RESULT_SUCCESS :
            fprintf(stderr, "XACML Query: Success\n");
            break;
        case XACML_RESULT_INVALID_PARAMETER :
            fprintf(stderr, "XACML Query: Invalid parameter\n");
            break;
        case XACML_RESULT_OBLIGATION_FAILED :
            fprintf(stderr, "XACML Query: Obligation failed\n");
            break;
        case XACML_RESULT_SOAP_ERROR :
            fprintf(stderr, "XACML Query: SOAP Error\n");
            break;
        case XACML_RESULT_INVALID_STATE :
            fprintf(stderr, "XACML Query: Invalid state\n");
            break;
        default :
            fprintf(stderr, "XACML Query: Unknown error\n");
            break;
    }

    /*** 4. XACML Response parsing ***/
    fprintf(stderr, "XACML Response evaluation...\n");


    /* Clean up */
    fprintf(stderr, "XACML clean up.\n");
    xacml_response_destroy(response); response=NULL;
    xacml_request_destroy(request); request=NULL;


    return 0;
}
