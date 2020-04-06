import os, sys
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/', methods=['GET'])
def root():
    page_title = os.environ['PAGE_TITLE']
    special_message = os.environ['SPECIAL_MESSAGE']
    header_message = os.environ['HEADER_MESSAGE']
    host_name = os.environ['HOST_NAME']
    internal_ip_address = os.environ['INTERNAL_IP_ADDRESS']
    external_ip_address = os.environ['EXTERNAL_IP_ADDRESS']
    host_operating_system = os.environ['HOST_OPERATING_SYSTEM']
    boot_time = os.environ['BOOT_TIME']
    return render_template('index.html', page_title=page_title, special_message=special_message, header_message=header_message, host_name=host_name, internal_ip_address=internal_ip_address, external_ip_address=external_ip_address, host_operating_system=host_operating_system, boot_time=boot_time)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
    