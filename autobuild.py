# -*- coding: UTF-8 -*-

import sublime
import sublime_plugin
import threading
import time

if int(sublime.version()) < 3000:
    from sublime_haskell_common import get_cabal_project_dir_and_name_of_view, get_setting, get_setting_async, \
        is_haskell_source
    from internals.locked_object import LockedObject
    from internals.settings import get_setting_async
else:
    from SublimeHaskell.sublime_haskell_common import get_cabal_project_dir_and_name_of_view, is_haskell_source
    from SublimeHaskell.internals.locked_object import LockedObject
    import SublimeHaskell.internals.settings as Settings


class SublimeHaskellAutobuild(sublime_plugin.EventListener):
    def __init__(self):
        super(SublimeHaskellAutobuild, self).__init__()
        self.fly_agent = FlyCheckLint()
        self.fly_agent.start()

    def on_post_save(self, view):
        auto_build_enabled = Settings.get_setting('enable_auto_build')
        auto_check_enabled = Settings.get_setting('enable_auto_check')
        auto_lint_enabled = Settings.get_setting('enable_auto_lint')
        cabal_project_dir, cabal_project_name = get_cabal_project_dir_and_name_of_view(view)

        # don't flycheck
        self.fly_agent.nofly()

        # auto build enabled and file within a cabal project
        if auto_build_enabled and cabal_project_dir is not None:
            view.window().run_command('sublime_haskell_build_auto')
        elif auto_check_enabled and auto_lint_enabled:
            view.window().run_command('sublime_haskell_check_and_lint')
            view.window().run_command('sublime_haskell_get_types')
        elif auto_check_enabled:
            view.window().run_command('sublime_haskell_check')
            view.window().run_command('sublime_haskell_get_types')
        elif auto_lint_enabled:
            view.window().run_command('sublime_haskell_lint')

    def on_modified(self, view):
        lint_check_fly = Settings.get_setting('lint_check_fly')

        if lint_check_fly and is_haskell_source(view) and view.file_name():
            self.fly_agent.fly(view)


class FlyCheckLint(threading.Thread):
    def __init__(self):
        super(FlyCheckLint, self).__init__()
        self.daemon = True
        self.view = LockedObject({'view':None, 'mtime':None})
        self.event = threading.Event()

    def fly(self, view):
        with self.view as v:
            v['view'] = view
            v['mtime'] = time.time()
        self.event.set()

    def nofly(self):
        with self.view as v:
            v['view'] = None
            v['mtime'] = None
        self.event.set()

    def run(self):
        while True:
            view_ = None
            mtime_ = None
            delay = Settings.get_setting_async('lint_check_fly_idle', 5)

            with self.view as v:
                view_ = v['view']
                mtime_ = v['mtime']

            if not view_:  # Wait for signal
                self.event.wait()
                self.event.clear()
                time.sleep(delay)
                continue

            if time.time() - mtime_ < delay:  # Was modified recently, sleep more
                time.sleep(delay)
                continue
            else:
                with self.view as v:
                    v['view'] = None
                    v['mtime'] = None

                fly_view = view_

                auto_check_enabled = Settings.get_setting_async('enable_auto_check')
                auto_lint_enabled = Settings.get_setting_async('enable_auto_lint')
                sublime.set_timeout(lambda: fly_view.window().run_command('sublime_haskell_scan_contents'), 0)
                if auto_check_enabled and auto_lint_enabled:
                    sublime.set_timeout(lambda: fly_view.window().run_command('sublime_haskell_check_and_lint', {'fly': True}), 0)
                elif auto_check_enabled:
                    sublime.set_timeout(lambda: fly_view.window().run_command('sublime_haskell_check', {'fly': True}), 0)
                elif auto_lint_enabled:
                    sublime.set_timeout(lambda: fly_view.window().run_command('sublime_haskell_lint', {'fly': True}), 0)
