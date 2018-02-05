using System.Collections;
using System.Collections.Generic;
using RockVR.Video;
using UnityEngine;
using MidiJack;

public class s01Random : MonoBehaviour {
    public float maxvel = 3.0f;
    public float decay = 1.5f;
    
    float vel;
    float velAccum;

    public void Start() {
        MidiJack.MidiMaster.noteOnDelegate += OnNoteOn;
    }

    public void Update() {
        float acc = maxvel / decay;
        vel -= acc * Time.deltaTime;
        vel = Mathf.Max(vel, 0);
        velAccum += vel * Time.deltaTime;

        Main.instance.mPlayground.SetFloat("uOffset", velAccum);

        if (Input.GetMouseButtonDown(0))
        {
        	vel = maxvel;
        }
    }

    private void OnNoteOn(MidiChannel channel, int note, float velocity) {
    	if (velocity == 0) return;
    	vel = maxvel;
    }
}
