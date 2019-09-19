@echo off
pyformat --remove-all-unused-imports -a %1 | dos2unix | patch -o c:%HOMEPATH%\AppData\Local\Temp\pyformat.py %1 > nul
for %%F in (c:%HOMEPATH%\AppData\Local\pyformat.py) do (
    if %%~zF==0 (
        isort -d c:%HOMEPATH%\AppData\Local\Temp\pyformat.py
    ) else (
        isort -d %1
    )
)
