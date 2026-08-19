from ranger.api.commands import Command
import subprocess
import os
from urllib.parse import quote


class z(Command):
    """Navigate using nav-engine.sh (z wrapper). Usage: z <query>"""

    def execute(self):
        query = self.rest(1)
        if not query:
            self.fm.open_console('z ')
            return
        libdir = os.environ.get('LIBDIR')
        if not libdir:
            self.fm.notify('LIBDIR not set', bad=True)
            return
        result = subprocess.run(
            [os.path.join(libdir, 'shared', 'nav-engine.sh'), query],
            capture_output=True, text=True
        )
        path = result.stdout.strip()
        if path:
            self.fm.cd(path)


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
