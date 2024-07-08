from kivy.lang import Builder
from kivy.uix.screenmanager import Screen, ScreenManager
from kivy.core.window import Window
from kivy.metrics import dp
from kivymd.app import MDApp
from kivymd.uix.dialog import MDDialog
from kivymd.uix.button import MDFlatButton, MDFloatingActionButton
from kivymd.uix.label import MDLabel
from kivy.core.text import LabelBase
import webbrowser

import arabic_reshaper
from bidi.algorithm import get_display
from number_to_text import convert_number_to_text, format_number_with_commas

# Register the custom font
LabelBase.register(name='Vazir', fn_regular='Fonts/Vazir.ttf')

class MainScreen(Screen):
    def update_input_label(self, text, currency_type):
        max_limit = 999999999999  # حداکثر مقدار برای تبدیل به متن
        if text.isdigit():
            number_value = int(text)
            if number_value > max_limit:
                label_text = "عدد خیلی بزرگ است!"
            else:
                label_text = convert_number_to_text(number_value)
            if currency_type == 'rial':
                if number_value > max_limit:
                    self.ids.input_rial_label.text = MDApp.get_running_app().reshape_text("عدد خیلی بزرگ است!")
                else:
                    self.ids.input_rial_label.text = MDApp.get_running_app().reshape_text(f"{label_text} ریال")
            elif currency_type == 'toman':
                if number_value > max_limit:
                    self.ids.input_toman_label.text = MDApp.get_running_app().reshape_text("عدد خیلی بزرگ است!")
                else:
                    self.ids.input_toman_label.text = MDApp.get_running_app().reshape_text(f"{label_text} تومان")
        else:
            if currency_type == 'rial':
                self.ids.input_rial_label.text = ""
            elif currency_type == 'toman':
                self.ids.input_toman_label.text = ""

    def convert_to_toman(self):
        rial = self.ids.input_rial.text
        if rial.isdigit():
            toman = int(rial) // 10  # تبدیل تومان به عدد صحیح
            toman_text = convert_number_to_text(toman)
            formatted_toman = format_number_with_commas(toman)
            if toman_text:
                self.ids.output.text = MDApp.get_running_app().reshape_text(f"{formatted_toman} تومان\n{toman_text} تومان")
            else:
                self.ids.output.text = MDApp.get_running_app().reshape_text(f"{formatted_toman} تومان")
        else:
            self.ids.output.text = MDApp.get_running_app().reshape_text("لطفاً عدد معتبر وارد کنید")

    def convert_to_rial(self):
        toman = self.ids.input_toman.text
        if toman.isdigit():
            rial = int(toman) * 10  # تبدیل ریال به عدد صحیح
            rial_text = convert_number_to_text(rial)
            formatted_rial = format_number_with_commas(rial)
            if rial_text:
                self.ids.output.text = MDApp.get_running_app().reshape_text(f"{formatted_rial} ریال\n{rial_text} ریال")
            else:
                self.ids.output.text = MDApp.get_running_app().reshape_text(f"{formatted_rial} ریال")
        else:
            self.ids.output.text = MDApp.get_running_app().reshape_text("لطفاً عدد معتبر وارد کنید")

class ConverterApp(MDApp):
    def reshape_text(self, text):
        reshaped_text = arabic_reshaper.reshape(text)
        bidi_text = get_display(reshaped_text)
        return bidi_text

    def build(self):
        self.theme_cls.theme_style = "Light"
        self.theme_cls.primary_palette = "Blue"
        return Builder.load_file('design.kv')

    def open_github(self):
        webbrowser.open('https://github.com/Amirabbasjadidi')

if __name__ == '__main__':
    ConverterApp().run()
