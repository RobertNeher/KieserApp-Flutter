const String DB_FILE = 'assets/test.db';
const String APP_TITLE = 'Your training companion';
const String ABOUT_TEXT = """
Die KieserApp führt dich durch dein Training:
* Einstellparameter pro Station
* Erklärungen zur aktuellen Station deines Trainingsplans
* Erfassung deiner
  - Gewichtseinstellung (in lbs.),
  - Geplantes Gewicht (in lbs.) für das nächste Training
  - Dauer der Übung (Standardwert: 120s)
  pro Station

Viel Spass beim Training!
""";
const List<Map<String, dynamic>> CUSTOMER_DATASET = [
  {"customerID": 19703, "name": "Lieschen Müller"},
  {"customerID": 19711, "name": "Robert Neher"},
  {"customerID": 19712, "name": "Max Mustermann"}
];

const List<Map<String, dynamic>> MACHINE_DATASET = [
  {
    "id": "A 3",
    "title": "-",
    "parameters": ["Lehne", "Beine", "Loch"],
    "affectedBodyParts": "<Bild>",
    "description": "Stärkung des kleinen Gesässmuskels",
    "tutorialVideoURL": "http://kieser.de"
  },
  {
    "id": "B 1",
    "title": "Beinstreckung",
    "parameters": ["Lehne", "Beine"],
    "affectedBodyParts": "<Bild>",
    "description": "Stärkung der Oberschenkelmuskeln",
    "tutorialVideoURL": "http://kieser.de"
  },
  {
    "id": "B 6",
    "title": "Beinpresse",
    "parameters": ["Sitz", "Lehne", "Schultern"],
    "affectedBodyParts": "<Bild>",
    "description": "Stärkung der Oberschenkelmuskeln",
    "tutorialVideoURL": "http://kieser.de"
  },
  {
    "id": "B 7",
    "title": "Beinbeugen",
    "parameters": ["Lehne", "Beine"],
    "affectedBodyParts": "<Bild>",
    "description": "",
    "tutorialVideoURL": ""
  },
  {
    "id": "F 1.1",
    "title": "-",
    "parameters": ["Fuss", "Beine", "Kurbel", "Start", "Loch"],
    "affectedBodyParts": "<Bild>",
    "description": "-",
    "tutorialVideoURL": "http://kieser.de"
  },
  {
    "id": "F 2.1",
    "title": "Bauchmuskel",
    "parameters": ["Polster", "Loch", "Fuss"],
    "affectedBodyParts": "<Bild>",
    "description": "",
    "tutorialVideoURL": ""
  },
  {
    "id": "F 3.1",
    "title": "Untere Rückenpartie",
    "parameters": ["Fuss", "Beine", "Hebel", "Start", "Loch"],
    "affectedBodyParts": "<Bild>",
    "description": "",
    "tutorialVideoURL": ""
  },
  {
    "id": "C 1",
    "title": "-",
    "parameters": ["Sitz", "Lehne", "Arme"],
    "affectedBodyParts": "<Bild>",
    "description": "",
    "tutorialVideoURL": ""
  },
  {
    "id": "C 3",
    "title": "-",
    "parameters": ["Sitz", "Griffe", "Hebel"],
    "affectedBodyParts": "<Bild>",
    "description": "",
    "tutorialVideoURL": ""
  },
  {
    "id": "C 7",
    "title": "-",
    "parameters": ["Polster"],
    "affectedBodyParts": "<Bild>",
    "description": "",
    "tutorialVideoURL": ""
  },
  {
    "id": "D 5",
    "title": "-",
    "parameters": ["Lehne", "Arme"],
    "affectedBodyParts": "<Bild>",
    "description": "",
    "tutorialVideoURL": ""
  },
  {
    "id": "D 6",
    "title": "-",
    "parameters": ["Sitz", "Lehne", "Griffe"],
    "affectedBodyParts": "<Bild>",
    "description": "",
    "tutorialVideoURL": ""
  },
  {
    "id": "H 1",
    "title": "Bizeps",
    "parameters": ["Sitz"],
    "affectedBodyParts": "<Bild>",
    "description": "",
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
        "parameterValues": ["1", "H7", "12", "10", "8", "N"],
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
  {
    "customerID": 19711,
    "defaultDuration": 120,
    "autoForward": false
  }
];

const List<Map<String, dynamic>> RESULTS_DATASET = [
  {
  "customerID": 19711,
  "trainings": [
      {
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
    ]
  }
];
