num_to_text = {
    0: 'صفر', 1: 'یک', 2: 'دو', 3: 'سه', 4: 'چهار', 5: 'پنج',
    6: 'شش', 7: 'هفت', 8: 'هشت', 9: 'نه', 10: 'ده',
    11: 'یازده', 12: 'دوازده', 13: 'سیزده', 14: 'چهارده', 15: 'پانزده',
    16: 'شانزده', 17: 'هفده', 18: 'هجده', 19: 'نوزده', 20: 'بیست',
    30: 'سی', 40: 'چهل', 50: 'پنجاه', 60: 'شصت', 70: 'هفتاد',
    80: 'هشتاد', 90: 'نود', 100: 'صد', 200: 'دویست', 300: 'سیصد',
    400: 'چهارصد', 500: 'پانصد', 600: 'ششصد', 700: 'هفتصد', 800: 'هشتصد', 900: 'نهصد',
    1000: 'هزار', 1000000: 'میلیون', 1000000000: 'میلیارد'
}

def convert_number_to_text(number):
    if number == 0:
        return num_to_text[0]
    if number < 21:
        return num_to_text[number]
    if number < 100:
        tens, below_ten = divmod(number, 10)
        return num_to_text[tens * 10] + ('' if below_ten == 0 else ' و ' + num_to_text[below_ten])
    if number < 1000:
        hundreds, below_hundred = divmod(number, 100)
        return num_to_text[hundreds * 100] + ('' if below_hundred == 0 else ' و ' + convert_number_to_text(below_hundred))
    if number < 1000000:
        thousands, below_thousand = divmod(number, 1000)
        return convert_number_to_text(thousands) + ' ' + num_to_text[1000] + ('' if below_thousand == 0 else ' و ' + convert_number_to_text(below_thousand))
    if number < 1000000000:
        millions, below_million = divmod(number, 1000000)
        return convert_number_to_text(millions) + ' ' + num_to_text[1000000] + ('' if below_million == 0 else ' و ' + convert_number_to_text(below_million))
    if number < 1000000000000:
        billions, below_billion = divmod(number, 1000000000)
        return convert_number_to_text(billions) + ' ' + num_to_text[1000000000] + ('' if below_billion == 0 else ' و ' + convert_number_to_text(below_billion))
    return None  # برای اعداد بزرگ‌تر از 999 میلیارد، مقدار None باز می‌گردد

def format_number_with_commas(number):
    return f"{number:,}"
