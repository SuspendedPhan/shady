using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MidiExample : MonoBehaviour
{

    // Use this for initialization
	void Start () {
		MidiJack.MidiMaster.noteOnDelegate += OnNoteOn;
	}
	
	// Update is called once per frame
	void Update () {
	}

	private void OnNoteOn(MidiJack.MidiChannel channel, int note, float velocity) {
    }
}
