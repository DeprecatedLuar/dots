import os
import shutil
import subprocess
from urllib.parse import quote

from ranger.api.commands import Command


def _find_nav_engine():
    candidates = [
        os.path.join(os.environ.get('SYSDIR', ''), 'shared', 'nav-engine.sh'),
        os.path.join(os.environ.get('BASHRC', ''), 'system', 'shared', 'nav-engine.sh'),
        os.path.expanduser('~/.config/lushrc/system/shared/nav-engine.sh'),
    ]
    for candidate in candidates:
        if candidate and os.path.isfile(candidate) and os.access(candidate, os.X_OK):
            return candidate

    return shutil.which('nav-engine.sh') or shutil.which('nav-engine')


class z(Command):
    """Navigate using nav-engine.sh. Usage: z <query>"""

    def execute(self):
        query = self.rest(1)
        if not query:
            self.fm.open_console('z ')
            return

        nav_script = _find_nav_engine()
        if not nav_script:
            self.fm.notify('nav-engine.sh not found', bad=True)
            return

        result = subprocess.run(
            [nav_script, query],
            capture_output=True, text=True
        )
        path = result.stdout.strip()
        if result.returncode == 0 and path:
            self.fm.cd(path)
        else:
            self.fm.notify(f"No match for '{query}'", bad=True)


class clipcopy(Command):
    """Copy selected file(s) as real file objects to the system clipboard
    (pasteable in GTK apps like Nautilus, via the gnome-copied-files mimetype)."""

    def execute(self):
        paths = [f.path for f in self.fm.thistab.get_selection()]
        if not paths:
            self.fm.notify('No files selected', bad=True)
            return

        uris = [f'file://{quote(p)}' for p in paths]
        payload = 'copy\n' + '\n'.join(uris)

        try:
            subprocess.run(
                ['wl-copy', '-t', 'x-special/gnome-copied-files'],
                input=payload.encode(),
                check=True,
            )
        except FileNotFoundError:
            self.fm.notify('wl-copy not found', bad=True)
            return
        except subprocess.CalledProcessError:
            self.fm.notify('wl-copy failed', bad=True)
            return

        self.fm.notify(f'Copied {len(paths)} file(s) to clipboard')
