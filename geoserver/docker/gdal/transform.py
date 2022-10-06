from http.server import BaseHTTPRequestHandler, HTTPServer
from osgeo import ogr
from osgeo import osr
import logging
import json
import re
import signal

def handle_sigterm(*args):
    raise KeyboardInterrupt()

# Docker send a SIGTERM on shutdown, map this to KeyboardInterrupt as not to wait 10 sec. for SIGKILL.
signal.signal(signal.SIGTERM, handle_sigterm)

class RequestHandler(BaseHTTPRequestHandler):
    def _set_response(self, geometry):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(geometry.encode('utf-8'))

    def _set_error_response(self, exception):
        self.send_response(500)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(repr(exception).encode('utf-8'))


    def do_POST(self):
        try:
            content_length = int(self.headers['Content-Length'])
            post_data_raw = self.rfile.read(content_length).decode('utf-8')
            post_data = json.loads(post_data_raw)

            crs_from = int(re.search('([0-9]*)$', post_data['crs_from'], re.IGNORECASE).group(1))
            crs_to = int(re.search('([0-9]*)$', post_data['crs_to'], re.IGNORECASE).group(1))
            wkt = post_data['wkt']


            source = osr.SpatialReference()
            source.ImportFromEPSG(crs_from)
            
            target = osr.SpatialReference()

            target.SetAxisMappingStrategy(osr.OAMS_TRADITIONAL_GIS_ORDER)
            target.ImportFromEPSG(crs_to)
        
            transform = osr.CoordinateTransformation(source, target)

            geom = ogr.CreateGeometryFromWkt(wkt)
            geom.Transform(transform)

            transformed_geometry = geom.ExportToWkt()

            self._set_response(transformed_geometry)
            logging.debug(transformed_geometry)

        except Exception as ex:
            logging.warning(repr(ex))
            self._set_error_response(ex)

def run(server_class=HTTPServer, handler_class=RequestHandler, port=8090):
    logging.basicConfig(level=logging.INFO)
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    logging.info('Starting httpd...\n')
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
    logging.info('Stopping httpd...\n')

if __name__ == '__main__':
    run()
