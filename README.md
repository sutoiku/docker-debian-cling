Cling as a shared library on the top of debian
==============================================
- Build CERN's root6
- Move Cling into /usr/local
- Destroy Root6
- Link cling's includes into `/usr/local/etc/root` to match the path of `brew install root6` on macos
