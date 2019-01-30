#!/usr/bin/python
""" start http service with metrics for metrics sessionC """
import random
import os
import sys
import argparse
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
RAND = random.Random()
PROCESS_ID = os.getpid()
PROCESS_NAME = sys.argv[0]

def args_parser():
    """ validate arguments and return them """
    parser = argparse.ArgumentParser(add_help=True, description="my_dummy_exporter port")
    parser.add_argument("--exporter_port", "-p", help="port to listen",
                        default=65433,type=int)
    return parser.parse_args()

# setup global_variable
my_dict = {}
my_dict['DummyService_requests{caller = "APT",'] = 10008.0
my_dict['DummyService_errors{'] = 43.0
my_dict['DummyService_duration_summary{quantile="0.5",'] = 100.0
my_dict['DummyService_duration_summary{quantile="0.75",'] = 0.0
my_dict['DummyService_duration_summary{quantile="0.95",'] = 0.0
my_dict['DummyService_duration_summary{quantile="0.98",'] = 0.0
my_dict['DummyService_duration_summary{quantile="0.99",'] = 0.0
my_dict['DummyService_duration_summary{quantile="0.999",'] = 0.0
my_dict['DummyService_duration_summary_count{'] = 10008.0
my_dict['DummyService_duration_summary_sum{'] = 433354.0
my_dict['DummyService_duration_cumulative_bucket{le="10.0",'] = 5056.0
my_dict['DummyService_duration_cumulative_bucket{le="20.0",'] = 5702.0
my_dict['DummyService_duration_cumulative_bucket{le="30.0",'] = 6333.0
my_dict['DummyService_duration_cumulative_bucket{le="40.0",'] = 6963.0
my_dict['DummyService_duration_cumulative_bucket{le="50.0",'] = 7592.0
my_dict['DummyService_duration_cumulative_bucket{le="60.0",'] = 8005.0
my_dict['DummyService_duration_cumulative_bucket{le="70.0",'] = 8381.0
my_dict['DummyService_duration_cumulative_bucket{le="80.0",'] = 8774.0
my_dict['DummyService_duration_cumulative_bucket{le="90.0",'] = 9178.0
my_dict['DummyService_duration_cumulative_bucket{le="+Inf",'] = 10008.0
my_dict['DummyService_duration_non_cumulative_bucket{le="10.0",'] = 1056.0
my_dict['DummyService_duration_non_cumulative_bucket{le="20.0",'] = 646.0
my_dict['DummyService_duration_non_cumulative_bucket{le="30.0",'] = 631.0
my_dict['DummyService_duration_non_cumulative_bucket{le="40.0",'] = 630.0
my_dict['DummyService_duration_non_cumulative_bucket{le="50.0",'] = 629.0
my_dict['DummyService_duration_non_cumulative_bucket{le="60.0",'] = 413.0
my_dict['DummyService_duration_non_cumulative_bucket{le="70.0",'] = 377.0
my_dict['DummyService_duration_non_cumulative_bucket{le="80.0",'] = 392.0
my_dict['DummyService_duration_non_cumulative_bucket{le="90.0",'] = 404.0
my_dict['DummyService_duration_non_cumulative_bucket{le="+Inf",'] = 830.0



def update_dict():
  """ change dict data with random """
  my_dict['DummyService_requests{caller = "APT",'] += RAND.randint(0, 100)
  my_dict['DummyService_errors{'] += RAND.randint(0, 10)
  my_dict['DummyService_duration_summary_count{'] += RAND.randint(0, 100)
  my_dict['DummyService_duration_summary_sum{'] += RAND.randint(0, 1000)
  my_dict['DummyService_duration_summary{quantile="0.5",'] += (5-RAND.randint(0, 10))

  my_dict['DummyService_duration_summary{quantile="0.75",'] = (my_dict['DummyService_duration_summary{quantile="0.5",']+RAND.randint(0, 3))
  my_dict['DummyService_duration_summary{quantile="0.95",'] = (my_dict['DummyService_duration_summary{quantile="0.75",']+RAND.randint(0, 5))
  my_dict['DummyService_duration_summary{quantile="0.98",'] = (my_dict['DummyService_duration_summary{quantile="0.95",']+RAND.randint(0, 5))
  my_dict['DummyService_duration_summary{quantile="0.99",'] = (my_dict['DummyService_duration_summary{quantile="0.98",']+RAND.randint(0, 5))
  my_dict['DummyService_duration_summary{quantile="0.999",'] = (my_dict['DummyService_duration_summary{quantile="0.99",']+RAND.randint(0, 10))

  my_dict['DummyService_duration_non_cumulative_bucket{le="10.0",'] += (5-RAND.randint(0, 10))
  my_dict['DummyService_duration_non_cumulative_bucket{le="20.0",'] += (5-RAND.randint(0, 10))
  my_dict['DummyService_duration_non_cumulative_bucket{le="30.0",'] += (5-RAND.randint(0, 10))
  my_dict['DummyService_duration_non_cumulative_bucket{le="40.0",'] += (5-RAND.randint(0, 10))
  my_dict['DummyService_duration_non_cumulative_bucket{le="50.0",'] += (5-RAND.randint(0, 10))
  my_dict['DummyService_duration_non_cumulative_bucket{le="60.0",'] += (5-RAND.randint(0, 10))
  my_dict['DummyService_duration_non_cumulative_bucket{le="70.0",'] += (5-RAND.randint(0, 10))
  my_dict['DummyService_duration_non_cumulative_bucket{le="80.0",'] += (5-RAND.randint(0, 10))
  my_dict['DummyService_duration_non_cumulative_bucket{le="90.0",'] += (5-RAND.randint(0, 10))
  my_dict['DummyService_duration_non_cumulative_bucket{le="+Inf",'] += (5-RAND.randint(0, 10))

  my_dict['DummyService_duration_cumulative_bucket{le="10.0",'] += my_dict['DummyService_duration_non_cumulative_bucket{le="10.0",']
  my_dict['DummyService_duration_cumulative_bucket{le="20.0",'] += my_dict['DummyService_duration_non_cumulative_bucket{le="20.0",']
  my_dict['DummyService_duration_cumulative_bucket{le="30.0",'] += my_dict['DummyService_duration_non_cumulative_bucket{le="30.0",']
  my_dict['DummyService_duration_cumulative_bucket{le="40.0",'] += my_dict['DummyService_duration_non_cumulative_bucket{le="40.0",']
  my_dict['DummyService_duration_cumulative_bucket{le="50.0",'] += my_dict['DummyService_duration_non_cumulative_bucket{le="50.0",']
  my_dict['DummyService_duration_cumulative_bucket{le="60.0",'] += my_dict['DummyService_duration_non_cumulative_bucket{le="60.0",']
  my_dict['DummyService_duration_cumulative_bucket{le="70.0",'] += my_dict['DummyService_duration_non_cumulative_bucket{le="70.0",']
  my_dict['DummyService_duration_cumulative_bucket{le="80.0",'] += my_dict['DummyService_duration_non_cumulative_bucket{le="80.0",']
  my_dict['DummyService_duration_cumulative_bucket{le="90.0",'] += my_dict['DummyService_duration_non_cumulative_bucket{le="90.0",']
  my_dict['DummyService_duration_cumulative_bucket{le="+Inf",'] += my_dict['DummyService_duration_non_cumulative_bucket{le="+Inf",']



def create_data():
   update_dict()
   return_string = ''
   for key in my_dict:
     return_string += key+'process_id="'+str(PROCESS_ID)+'",process_name="'+PROCESS_NAME+'"} '+str(my_dict[key])+"\n"
   return return_string

#HOST = '0.0.0.0'  # Standard loopback interface address (localhost)
#PORT = 65433        # Port to listen on (non-privileged ports are > 1023)
#PORT_NUMBER = 65433
input_data=args_parser()
PORT_NUMBER = input_data.exporter_port

#This class will handles any incoming request from
#the browser
class MyHandler(BaseHTTPRequestHandler):
  """ http handler     """

  def do_GET(self):
    """ answer to get request"""

    return_data = create_data()
    self.send_response(200)
    self.send_header('Content-type', 'text/html')
    self.end_headers()

    # Send the html message
    self.wfile.write(return_data)

try:
  #Create a web server and define the handler to manage the incoming request
  SERVER = HTTPServer(('', PORT_NUMBER), MyHandler)
  print('Started httpserver on port ', PORT_NUMBER)

  #Wait forever for incoming htto requests
  SERVER.serve_forever()

except KeyboardInterrupt:
  print('^C received, shutting down the web server')
  SERVER.socket.close()
