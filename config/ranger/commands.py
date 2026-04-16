from ranger.api.commands import Command
import subprocess
import os


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
