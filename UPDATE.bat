@ECHO OFF
SETLOCAL
SET BASEDIR=%~dp0

REM Pythonの有無をチェックする。
python -V > NUL 2>&1
IF NOT ERRORLEVEL 1 GOTO END_PYTHON_CHECK
ECHO Vimの自動更新を利用するにはPythonをインストールしてください。
GOTO END_FAILURE
:END_PYTHON_CHECK

REM ディレクトリ構成を調査する。
IF EXIST "%BASEDIR%"vim-online-update.py GOTO FOUND_CURR
IF EXIST "%BASEDIR%"online-update\vim-online-update.py GOTO FOUND_BOTTOM
ECHO 更新用スクリプトが見つかりません。
GOTO END_FAILURE
:FOUND_CURR
SET SCRIPT=%BASEDIR%vim-online-update.py
SET TARGET_DIR=%BASEDIR%var\vim73
GOTO END_DIR_CHECK
:FOUND_BOTTOM
SET SCRIPT=%BASEDIR%online-update\vim-online-update.py
SET TARGET_DIR=%BASEDIR%
SET PYTHONPATH=%BASEDIR%online-update
GOTO END_DIR_CHECK
:END_DIR_CHECK

ECHO Vimの更新中です。しばらくお待ちください。
python "%SCRIPT%" "%TARGET_DIR%"
IF ERRORLEVEL 3 GOTO END_FAILURE_EXTRACT
IF ERRORLEVEL 2 GOTO END_FAILURE_DOWNLOAD
IF ERRORLEVEL 1 GOTO END_SUCCESS
GOTO END_NOTUPDATED

:END_FAILURE_EXTRACT
ECHO Vimの更新に失敗しました。起動中のVimをすべて終了してください。
GOTO END
:END_FAILURE_DOWNLOAD
ECHO Vimの更新に失敗しました。インターネット接続を確認してください。
GOTO END
:END_NOTUPDATED
ECHO Vimの更新はありませんでした。
GOTO END
:END_SUCCESS
ECHO Vimの更新を完了しました。
GOTO END

:END
ECHO 約10秒後にこのウィンドウは自動的に閉じます。
PING localhost -n 10 > nul
