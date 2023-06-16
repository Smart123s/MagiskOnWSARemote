#!/usr/bin/python3
#
# This file is part of MagiskOnWSALocal.
#
# MagiskOnWSALocal is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# MagiskOnWSALocal is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with MagiskOnWSALocal.  If not, see <https://www.gnu.org/licenses/>.
#
# Copyright (C) 2023 LSPosed Contributors
#

import html
import os
import re
import sys
import warnings
from pathlib import Path
from threading import Thread
from typing import OrderedDict
from xml.dom import minidom

from requests import Session


warnings.filterwarnings("ignore")

arch = sys.argv[1]

release_name_map = {"retail": "Retail", "RP": "Release Preview",
                    "WIS": "Insider Slow", "WIF": "Insider Fast"}
release_type = sys.argv[2] if sys.argv[2] != "" else "Retail"
release_name = release_name_map[release_type]
cat_id = '858014f3-3934-4abe-8078-4aa193e74ca8'
user = ''
session = Session()


with open(Path.cwd() / ("MagiskOnWSALocal/xml/GetCookie.xml"), "r") as f:
    cookie_content = f.read().format(user)

out = session.post(
    'https://fe3.delivery.mp.microsoft.com/ClientWebService/client.asmx',
    data=cookie_content,
    headers={'Content-Type': 'application/soap+xml; charset=utf-8'},
    verify=False
)
doc = minidom.parseString(out.text)
cookie = doc.getElementsByTagName('EncryptedData')[0].firstChild.nodeValue

with open(Path.cwd() / "MagiskOnWSALocal/xml/WUIDRequest.xml", "r") as f:
    cat_id_content = f.read().format(user, cookie, cat_id, release_type)

out = session.post(
    'https://fe3.delivery.mp.microsoft.com/ClientWebService/client.asmx',
    data=cat_id_content,
    headers={'Content-Type': 'application/soap+xml; charset=utf-8'},
    verify=False
)

doc = minidom.parseString(html.unescape(out.text))

filenames = {}
for node in doc.getElementsByTagName('Files'):
    filename = f"{node.firstChild.attributes['InstallerSpecificIdentifier'].value}_{node.firstChild.attributes['FileName'].value}"
    if re.match(f"MicrosoftCorporationII\.WindowsSubsystemForAndroid_.*\.msixbundle", filename):
        wsa_long_ver = re.search(u'\d{4}.\d{5}.\d{1,}.\d{1,}', filename).group()
        print(f'{wsa_long_ver}', flush=True)
        exit(0)
