{ lib, python3 }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "WsgiDAV";
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mmazz39y4s6wz71843sw2pi3390mq2si1akwqw0db6s0gnqs6xv";
  };

  doCheck = false;
  propagatedBuildInputs = [ cheroot
                            defusedxml
                            lxml
                            jaraco_functools
                            jinja2
                            markupsafe
                            pyjson5
                            pyyaml
                          ];

  meta = with lib; {
    homepage = https://github.com/mar10/wsgidav;
    description = "A generic and extendable WebDAV server based on WSGI";
    license = licenses.mit;
    maintainers = with maintainers; [ kaiha ];
  };
}
