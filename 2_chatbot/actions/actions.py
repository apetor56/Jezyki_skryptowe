import json
import os
from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
from rasa_sdk.types import DomainDict
from rasa_sdk.events import SlotSet

class ActionCheckOpeningHours(Action):

    def name(self) -> Text:
        return "action_check_opening_hours"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict) -> List[Dict[Text, Any]]:

        day = tracker.get_slot("day")
        
        if not day:
            dispatcher.utter_message(text="Please specify the day you are interested in.")
            return []

        try:
            opening_hours_path = os.path.join(os.path.dirname(__file__), '..', 'data', 'opening_hours.json')
            with open(opening_hours_path) as f:
                opening_hours = json.load(f)["items"]
        except Exception as e:
            dispatcher.utter_message(text=f"Sorry, I couldn't access the opening hours. Error: {str(e)}")
            return []

        day_capitalized = day.capitalize()
        if day_capitalized in opening_hours:
            hours = opening_hours[day_capitalized]
            if hours["open"] == 0 and hours["close"] == 0:
                dispatcher.utter_message(text=f"The restaurant is closed on {day}.")
            else:
                dispatcher.utter_message(text=f"The restaurant is open on {day} from {hours['open']} to {hours['close']}.")
        else:
            dispatcher.utter_message(text="Sorry, I didn't understand the day. Can you please specify again?")
        return []

class ActionListMenu(Action):

    def name(self) -> Text:
        return "action_list_menu"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict) -> List[Dict[Text, Any]]:

        with open('data/menu.json') as f:
            menu_items = json.load(f)["items"]
        
        menu_text = "Here's our menu:\n"
        for item in menu_items:
            menu_text += f"{item['name']} - ${item['price']}\n"
        
        dispatcher.utter_message(text=menu_text)
        return []

class ActionPlaceOrder(Action):

    def name(self) -> Text:
        return "action_place_order"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict) -> List[Dict[Text, Any]]:

        item = tracker.get_slot("item")
        if not item:
            dispatcher.utter_message(text="What would you like to order?")
            return []

        with open('data/menu.json') as f:
            menu_items = json.load(f)["items"]

        menu_item_names = [menu_item['name'].lower() for menu_item in menu_items]

        if item.lower() in menu_item_names:
            dispatcher.utter_message(text=f"You've ordered {item}. Would you like to add any modifications?")
        else:
            dispatcher.utter_message(text=f"{item} is not on the menu. Would you like to order something else?")
            
        return []
    
class ActionModifyOrder(Action):

    def name(self) -> Text:
        return "action_modify_order"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict) -> List[Dict[Text, Any]]:

        item = tracker.get_slot("item")
        modification = tracker.latest_message.get('text')
        
        if not item:
            dispatcher.utter_message(text="Please specify the item you want to modify.")
            return []

        orders = tracker.get_slot("orders")
        if not orders:
            orders = []

        modified_order = f"{item} {modification}"
        orders.append(modified_order)

        dispatcher.utter_message(text=f"Your order has been modified: {modified_order}")

        return [SlotSet("orders", orders)]

class ActionConfirmOrder(Action):

    def name(self) -> Text:
        return "action_confirm_order"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict) -> List[Dict[Text, Any]]:

        item = tracker.get_slot("item")
        modifications = tracker.latest_message['text']
        dispatcher.utter_message(text=f"Your order for {item} with the following modifications: {modifications}, has been placed.")
        return []
