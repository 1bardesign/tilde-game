#!/bin/bash

#initial setup
rm -rf dist
rm tilde.love
rm tilde-windows.zip

#raw love2d file
cd ..
zip -r pack/tilde.love *.lua src assets lib config
cd pack

#windows
mkdir dist
cat ./win/love.exe tilde.love > dist/tilde.exe
cp ./win/*.dll dist
cp ./win/license.txt dist/license_love2d.txt
cp ../readme-public.md dist/readme.md

mv dist tilde
zip -r tilde-windows.zip tilde
rm -rf tilde
