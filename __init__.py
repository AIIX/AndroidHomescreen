import sys
import os
import time
import datetime
import importlib.util
import json
from os import path
from mycroft.skills.core import MycroftSkill, resting_screen_handler
from mycroft.skills.skill_loader import load_skill_module
from mycroft.util.log import getLogger
from mycroft.skills.skill_manager import SkillManager

__author__ = 'aix'

LOGGER = getLogger(__name__)


class AndroidHomescreen(MycroftSkill):

    # The constructor of the skill, which calls MycroftSkill's constructor
    def __init__(self):
        super(AndroidHomescreen, self).__init__(name="AndroidHomescreen")
        self.allSkills = []
        self.enabledAndroidSkills = []
        self.androidSkillsList = []
        self.androidSkillObject = {}
        self.skill_manager = None

    def initialize(self):
        self.add_event("pixabay.gallery.set_wallpaper", self.set_wallpaper)
        now = datetime.datetime.now()
        callback_time = (datetime.datetime(now.year, now.month, now.day,
                                           now.hour, now.minute) +
                         datetime.timedelta(seconds=60))
        self.schedule_repeating_event(self.update_dt, callback_time, 10)
        self.skill_manager = SkillManager(self.bus)

        # Make Import For TimeData
        root_dir = self.root_dir.rsplit('/', 1)[0]
        try:
            time_date_path = str(
                root_dir) + "/mycroft-date-time.mycroftai/__init__.py"
            time_date_id = "datetimeskill"
            datetimeskill = load_skill_module(time_date_path, time_date_id)
            from datetimeskill import TimeSkill
            self.dt_skill = TimeSkill()
        except:
            print("Failed To Import DateTime Skill")

    @resting_screen_handler('AndroidHomescreen')
    def handle_idle(self, message):
        self.gui.clear()
        self.generate_homescreen_icons()
        self.log.debug('Activating Time/Date resting page')
        self.gui['time_string'] = self.dt_skill.get_display_current_time()
        self.gui['ampm_string'] = ''
        self.gui['date_string'] = self.dt_skill.get_display_date()
        self.gui['weekday_string'] = self.dt_skill.get_weekday()
        self.gui['month_string'] = self.dt_skill.get_month_date()
        self.gui['year_string'] = self.dt_skill.get_year()
        self.gui['skillLauncher'] = self.androidSkillObject
        self.gui.show_page('homescreen.qml')

    def handle_idle_update_time(self):
        self.gui['time_string'] = self.dt_skill.get_display_current_time()

    def generate_homescreen_icons(self):
        self.androidSkillsList.clear()
        skill_directories = self.skill_manager._get_skill_directories()
        print(skill_directories)
        for x in range(len(skill_directories)):
            if skill_directories[x] not in self.allSkills:
                self.allSkills.append(skill_directories[x])

        for x in range(len(self.allSkills)):
            skill_dir = self.allSkills[x]
            skill_android_file_resource = skill_dir + "/android.json"
            if path.exists(
                skill_android_file_resource) and path.isfile(
                    skill_android_file_resource):
                with open(skill_android_file_resource) as f:
                    print("I AM IN EXPAND ANDROID RESOURCE FILE")
                    expand_file = json.load(f)
                    icon_path = skill_dir + expand_file["android_icon"]
                    display_name = expand_file["android_name"]
                    invoke_handler = expand_file["android_handler"]
                    if not any(d.get('skillPath', None) == skill_dir
                               for d in self.androidSkillsList):
                        self.androidSkillsList.append({"skillPath": skill_dir,
                                                       "skillIconPath": icon_path,
                                                       "skillDisplayName": display_name,
                                                       "skillHandler": invoke_handler})
                        print(self.androidSkillsList)

                    try:
                        sort_on = "skillDisplayName"
                        decorated = [(dict_[sort_on], dict_)
                                     for dict_ in self.androidSkillsList]
                        decorated.sort()
                        result = [dict_ for (key, dict_) in decorated]
                        print(result)
                    except Exception:
                        print("Error Sorting Application List")

        try:
            self.androidSkillObject["skillList"] = result
        except Exception:
            print("Error Getting Application List")

    def update_dt(self):
        self.gui['time_string'] = self.dt_skill.get_display_current_time()
        self.gui['date_string'] = self.dt_skill.get_display_date()
        
    def set_wallpaper(self, message):
        self.gui['wallpaper_path'] = message.data["imagePath"]
    
    def set_default_wallpaper(self, message):
        self.gui['wallpaper_path'] = self.root_dir + "/ui/img/seaside.jpg"

    def stop(self):
        pass


def create_skill():
    return AndroidHomescreen()
