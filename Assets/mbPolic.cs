using MidiJack;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class mbPolic : MonoBehaviour {

	HashSet<int> aactiveNotes = new HashSet<int>();
	GameObject spotlight;

	// Use this for initialization
	void Start () {
		MidiJack.MidiMaster.noteOnDelegate += OnNoteOn;
		spotlight = GameObject.Find("Spotlight");
		spotlight.SetActive(false);
	}
	
	// Update is called once per frame
	void Update () {
	}

	private void OnNoteOn(MidiChannel channel, int note, float velocity) {
		Debug.Log(string.Format("{0} {1} {2}", channel, note, velocity));
		Debug.Log("helo");
    	if (velocity == 0) {
    		aactiveNotes.Remove(note);
    		if (aactiveNotes.Count == 0) {
    			spotlight.SetActive(false);
    		}
    	}
    	else {
    		aactiveNotes.Add(note);
    		spotlight.SetActive(true);
    	}
    }
}
