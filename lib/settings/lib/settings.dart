const String DB_FILE = 'assets/test.db';
const String APP_TITLE = 'Your training companion';
const String ABOUT_TEXT = """
Die KieserApp führt dich durch dein Training:
* Einstellparameter pro Station
* Erklärungen zur aktuellen Station deines Trainingsplans
* Erfassung deiner
  - Gewichtseinstellung (in lbs.),
  - Geplantes Gewicht (in lbs.) für das nächste Training
  - Dauer der Übung (Standardwert: !defaultDuration!s)
  pro Station

Viel Spass beim Training!
""";
const String TEMP_STORE = 'temp';
const List<Map<String, dynamic>> CUSTOMER_DATASET = [
  {"customerID": 19703, "name": "Lieschen Müller"},
  {"customerID": 19711, "name": "Robert Neher"},
  {"customerID": 19712, "name": "Max Mustermann"}
];

const List<Map<String, dynamic>> MACHINE_DATASET = [
  {
    "id": "A 3",
    "title": "Spreizung im Hüftgelenk",
    "parameters": ["Lehne", "Beine", "Loch"],
    "affectedBodyParts": "<Bild>",
    "description":
        "Die Maschine zur Spreizung im Hüftgelenk trainiert den kleinen und mittleren Gesäßmuskel. Bei der Übung drücken Sie die Oberschenkel so weit wie möglich zur Seite.",
    "tutorialVideoURL":
        "https://www.facebook.com/KieserTrainingFrankfurtInnenstadt/videos/a3-spreizung-im-h%C3%BCftgelenk/1029688607470499/"
  },
  {
    "id": "B 1",
    "title": "Streckung im Kniegelenk",
    "parameters": ["Lehne", "Beine"],
    "affectedBodyParts": "<Bild>",
    "description":
        "Bei der Streckung im Kniegelenk trainieren Sie den vierköpfigen Schenkelmuskel. In der Ausführung strecken Sie die Beine, bis sie vollständig gestreckt sind.",
    "tutorialVideoURL":
        "https://www.facebook.com/KieserTrainingFrankfurtInnenstadt/videos/b1-streckung-im-kniegelenk/268653854475799/"
  },
  {
    "id": "B 6",
    "title": "Beinpresse",
    "parameters": ["Sitz", "Lehne", "Schultern"],
    "affectedBodyParts": "<Bild>",
    "description":
        "Beim Beinpressen trainieren Sie den zwei- und vierköpfigen Schenkelmuskel sowie den Halb- und Plattsehnenmuskel und den großen Gesäßmuskel. Bei der Übung drücken Sie mit beiden Beinen das Fußbrett nach vorne.",
    "tutorialVideoURL": "http://kieser.de"
  },
  {
    "id": "B 7",
    "title": "Beugung im Kniegelenk sitzend",
    "parameters": ["Lehne", "Beine"],
    "affectedBodyParts": "<Bild>",
    "description":
        "Mit der Beugung im Kniegelenk sitzend trainieren Sie dieselben Muskeln wie bei der B5 in einer anderen Position. Der zweiköpfige Schenkelbeuger sowie die Halb- und Plattsehnenmuskeln werden trainiert. In sitzender Position beugen Sie die Beine im Kniegelenk, indem Sie versuchen, mit den Fersen so weit wie möglich Richtung Gesäß zu kommen.",
    "tutorialVideoURL": ""
  },
  {
    "id": "F 1.1",
    "title": "Rumpfdrehung",
    "parameters": ["Fuss", "Beine", "Kurbel", "Start", "Loch"],
    "affectedBodyParts": "<Bild>",
    "description":
        "Bei der Rumpfdrehung trainieren Sie den inneren und äußeren schrägen Bauchmuskel. Während der Übung drehen Sie den Oberkörper nach links und rechts.",
    "tutorialVideoURL": "http://kieser.de"
  },
  {
    "id": "F 2.1",
    "title": "Rumpfbeugung",
    "parameters": ["Loch", "Fuss"],
    "affectedBodyParts": "<Bild>",
    "description":
        "Bei der Rumpfdrehung traininieren Sie den geraden Bauchmuskel. Während der Übung rollen Sie sich maximal ein.",
    "tutorialVideoURL": ""
  },
  {
    "id": "F 3.1",
    "title": "Rückenstreckung",
    "parameters": ["Fuss", "Beine", "Hebel", "Start", "Loch"],
    "affectedBodyParts": "<Bild>",
    "description":
        "Bei der Rückenstreckung trainieren Sie die Rückenstrecker, also die Streckmuskeln der Wirbelsäule. Während der Übung richten Sie sich sitzend auf und strecken sich so weit wie möglich nach hinten.",
    "tutorialVideoURL": ""
  },
  {
    "id": "C 1",
    "title": "Überzug",
    "parameters": ["Sitz", "Lehne", "Arme"],
    "affectedBodyParts": "<Bild>",
    "description":
        "Beim Überzug trainieren Sie den großen Rückenmuskel. Bei der Übungsausführung drücken Sie mit den Oberarmen zunächst nach vorne, dann nach unten und schließlich so weit wie möglich nach hinten.",
    "tutorialVideoURL": ""
  },
  {
    "id": "C 3",
    "title": "Armzug",
    "parameters": ["Sitz", "Griffe", "Hebel"],
    "affectedBodyParts": "<Bild>",
    "description":
        "Beim seitlichen Armzug trainieren Sie dieselben Muskeln wie beim Armzug vorne. Der große Rückenmuskel, der zweiköpfige Armmuskel sowie der Trapezmuskel werden trainiert. In der Ausführung ziehen Sie die Griffe nach unten, bis Ihre Hände neben Ihren Schultern befinden.",
    "tutorialVideoURL": ""
  },
  {
    "id": "C 7",
    "title": "Ruderzug",
    "parameters": ["Sitz"],
    "affectedBodyParts": "<Bild>",
    "description":
        "Beim Ruderzug trainieren Sie den großen Rückenmuskel, den zweiköpfigen Armmuskel, den Trapezmuskel sowie den Rautenmuskel. In der Ausführung ziehen Sie die Griffe nach hinten und führen die Ellbogen nahe am Körper entlang.",
    "tutorialVideoURL": ""
  },
  {
    "id": "D 5",
    "title": "Armkreuzen",
    "parameters": ["Lehne", "Arme"],
    "affectedBodyParts": "<Bild>",
    "description":
        "Die Übung Armkreuzen trainiert den großen Brustmuskel. Bei der Ausführung sind die Oberarme parallel zum Boden, und Sie drücken die Hebelarme so weit nach vorne, bis sie sich berühren.",
    "tutorialVideoURL": ""
  },
  {
    "id": "D 6",
    "title": "Brustdrücken",
    "parameters": ["Sitz", "Lehne", "Griffe"],
    "affectedBodyParts": "<Bild>",
    "description":
        "Beim Brustdrücken trainieren Sie den großen Brustmuskel und den dreiköpfigen Armmuskel. Während der Übung drücken Sie die Hebelarme nach vorne, ohne dass die Arme vollständig gestreckt werden.",
    "tutorialVideoURL": ""
  },
  {
    "id": "H 1",
    "title": "Armbeugung",
    "parameters": ["Sitz"],
    "affectedBodyParts": "<Bild>",
    "description":
        "Bei der Armbeugung trainieren Sie den zweiköpfigen Armmuskel. Während der Übung befinden sich die Ellbogen zwischen den Polstern und Sie beugen die Arme so weit wie möglich.",
    "tutorialVideoURL": ""
  }
];

const List<Map<String, dynamic>> PLAN_DATASET = [
  {
    "customerID": 19711,
    "validFrom": "2022-11-22",
    "stations": [
      {
        "machineID": "B 1",
        "parameterValues": ["8", "-"],
        "movement": "6°",
        "comments": ""
      },
      {
        "machineID": "B 7",
        "parameterValues": ["8", "-"],
        "movement": "120°",
        "comments": ""
      },
      {
        "machineID": "F 2.1",
        "parameterValues": ["N", "4 (gelb)", "9"],
        "movement": "",
        "comments": ""
      },
      {
        "machineID": "F 3.1",
        "parameterValues": ["1", "H7", "12", "10", "8", "N"],
        "movement": "",
        "comments": ""
      },
      {
        "machineID": "C 1",
        "parameterValues": ["7", "hinten", "1"],
        "movement": "20",
        "comments": "Beide Seiten!"
      },
      {
        "machineID": "C 3",
        "parameterValues": ["6", "parallel", "hinten"],
        "movement": "",
        "comments": ""
      },
      {
        "machineID": "C 7",
        "parameterValues": ["4", "-"],
        "movement": "5 - 18",
        "comments": "Arme eng am Körper"
      },
      {
        "machineID": "D 5",
        "parameterValues": ["2", "2", "-"],
        "movement": "",
        "comments": "Nur Polster halten. Ellbogen drücken, nicht Hand"
      },
      {
        "machineID": "D 6",
        "parameterValues": ["6", "3", "horizontal"],
        "movement": "",
        "comments": "Ellenbogen etwas nach Aussen"
      },
      {
        "machineID": "H 1",
        "parameterValues": ["9"],
        "movement": "",
        "comments": ""
      },
    ]
  },
  {
    "customerID": 19711,
    "validFrom": "2023-02-15",
    "stations": [
      {
        "machineID": "A 3",
        "parameterValues": ["2", "3", "4"],
        "movement": "",
        "comments": ""
      },
      {
        "machineID": "B 6",
        "parameterValues": ["-19", "2", "4"],
        "movement": "",
        "comments": ""
      },
      {
        "machineID": "F 1.1",
        "parameterValues": ["1", "F4", "12", "2", "4"],
        "movement": "",
        "comments": ""
      },
      {
        "machineID": "F 2.1",
        "parameterValues": ["4", "9"],
        "movement": "",
        "comments": ""
      },
      {
        "machineID": "F 3.1",
        "parameterValues": ["1", "H7", "12", "10", "8"],
        "movement": "",
        "comments": ""
      },
      {
        "machineID": "C 1",
        "parameterValues": ["7", "hinten", "1"],
        "movement": "21",
        "comments": "Beide Seiten!"
      },
      {
        "machineID": "C 3",
        "parameterValues": ["4", "parallel", "hinten"],
        "movement": "",
        "comments": ""
      },
      {
        "machineID": "C 7",
        "parameterValues": ["4"],
        "movement": "5 - 18",
        "comments": "Arme eng am Körper"
      },
      {
        "machineID": "D 5",
        "parameterValues": ["2", "2"],
        "movement": "",
        "comments": "Nur Polster halten. Ellbogen drücken, nicht Hand"
      },
      {
        "machineID": "D 6",
        "parameterValues": ["6", "3", "horizontal"],
        "movement": "",
        "comments": "Ellenbogen etwas nach Aussen"
      },
      {
        "machineID": "H 1",
        "parameterValues": ["9"],
        "movement": "",
        "comments": ""
      }
    ]
  }
];

const List<Map<String, dynamic>> PREFERENCES_DATASET = [
  {"customerID": 19711, "defaultDuration": 120, "autoForward": false}
];

const List<Map<String, dynamic>> RESULTS_DATASET = [
  {
    "customerID": 19711,
    "trainingDate": "2023-01-29",
    "results": [
      {
        "machineID": "B 1",
        "duration": 120,
        "weightDone": "110",
        "weightPlanned": 0
      },
      {
        "machineID": "B 7",
        "duration": 120,
        "weightDone": "110",
        "weightPlanned": 0
      },
      {
        "machineID": "F 2.1",
        "duration": 120,
        "weightDone": "86",
        "weightPlanned": 0
      },
      {
        "machineID": "F 3.1",
        "duration": 120,
        "weightDone": "88",
        "weightPlanned": 0
      },
      {
        "machineID": "C 1",
        "duration": 120,
        "weightDone": "88",
        "weightPlanned": 0
      },
      {
        "machineID": "C 3",
        "duration": 120,
        "weightDone": "180",
        "weightPlanned": 0
      },
      {
        "machineID": "C 7",
        "duration": 120,
        "weightDone": "92",
        "weightPlanned": 0
      },
      {
        "machineID": "D 5",
        "duration": 120,
        "weightDone": "68",
        "weightPlanned": 0
      },
      {
        "machineID": "D 6",
        "duration": 120,
        "weightDone": "92",
        "weightPlanned": 0
      },
      {
        "machineID": "H 1",
        "duration": 120,
        "weightDone": "62",
        "weightPlanned": 0
      }
    ]
  },
  {
    "customerID": 19711,
    "trainingDate": "2023-03-05",
    "results": [
      {
        "machineID": "A 3",
        "duration": 120,
        "weightDone": 70,
        "weightPlanned": 70
      },
      {
        "machineID": "B 6",
        "duration": 120,
        "weightDone": 390,
        "weightPlanned": 410
      },
      {
        "machineID": "F 1.1",
        "duration": 120,
        "weightDone": 50,
        "weightPlanned": 50
      },
      {
        "machineID": "F 2.1",
        "duration": 120,
        "weightDone": 94,
        "weightPlanned": 94
      },
      {
        "machineID": "F 3.1",
        "duration": 120,
        "weightDone": 94,
        "weightPlanned": 94
      },
      {
        "machineID": "C 1",
        "duration": 120,
        "weightDone": 94,
        "weightPlanned": 94
      },
      {
        "machineID": "C 3",
        "duration": 120,
        "weightDone": 186,
        "weightPlanned": 186
      },
      {
        "machineID": "C 7",
        "duration": 120,
        "weightDone": 96,
        "weightPlanned": 96
      },
      {
        "machineID": "D 5",
        "duration": 120,
        "weightDone": 76,
        "weightPlanned": 76
      },
      {
        "machineID": "D 6",
        "duration": 120,
        "weightDone": 94,
        "weightPlanned": 94
      },
      {
        "machineID": "H 1",
        "duration": 120,
        "weightDone": 62,
        "weightPlanned": 62
      }
    ]
  }
];
