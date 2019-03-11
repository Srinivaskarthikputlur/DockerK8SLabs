from ...core.types import Hunter, KubernetesCluster, InformationDisclosure
from ...core.events import handler
from ...core.events.types import Vulnerability, Event, Service

import ssl
import base64
import re

email_pattern = re.compile(r"([a-z0-9]+@[a-z0-9]+\.[a-z0-9]+)")

class CertificateEmail(Vulnerability, Event):
    """Certificate includes an email address"""
    def __init__(self, email):
        Vulnerability.__init__(self, KubernetesCluster, "Certificate Includes Email Address", category=InformationDisclosure)
        self.email = email
        self.evidence = "email: {}".format(self.email)

@handler.subscribe(Service)
class CertificateDiscovery(Hunter):
    """Certificate Email Hunting
    Checks for email addresses in kuberntes ssl certificates
    """
    def __init__(self, event):
        self.event = event

    def execute(self):
        try:
            addr = (str(self.event.host), self.event.port)
            cert = ssl.get_server_certificate(addr)
        except ssl.SSLError as e:
            # If the server doesn't offer SSL on this port we won't get a certificate
            return
        c = cert.strip(ssl.PEM_HEADER).strip(ssl.PEM_FOOTER)
        certdata = base64.decodestring(c)
        emails = re.findall(email_pattern, certdata)
        for email in emails:
            self.publish_event( CertificateEmail(email=email) )