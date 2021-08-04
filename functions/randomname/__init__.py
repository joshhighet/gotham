#!/usr/bin/env python3
"""namegenerator"""
import json
import coolname
import azure.functions as func

def main(req: func.HttpRequest) -> func.HttpResponse:
    """generate random2 name"""
    response = {}
    response['name'] = coolname.generate_slug(2)
    json_response = json.dumps(response)
    return func.HttpResponse(json_response,status_code=200)
