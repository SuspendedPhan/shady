using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MidiJack;

public class s07Fireflies : MonoBehaviour {

	public Color color1 = Color.black;
	public Color color2 = new Color(.459f, .145f, .878f);
	public GameObject sdf;
	public List<Floater> mixacc = new List<Floater>();

	// Use this for initialization
	void Start () {
		Camera.main.backgroundColor = color1;
		MidiJack.MidiMaster.noteOnDelegate += OnNoteOn;
		// StartCoroutine(stutter(1f));
	}
	
	// Update is called once per frame
	void Update () {
		float mix = 0;
		foreach (var mixer in mixacc) {
			mix += mixer.value;
		}
		Camera.main.backgroundColor = Color.Lerp(color1, color2, mix);
	}

	private void OnNoteOn(MidiChannel channel, int note, float velocity) {
    	if (velocity == 0) return;
    	if (note == 67) {
	    	// StartCoroutine(stutter(.6f, .05f));
    	} else if (note == 68) {
	    	StartCoroutine(stutter(.6f, .2f));
    	} else if (note == 69) {
    		StartCoroutine(bloom(.2f));
    	} else if (note == 70) {
    		StartCoroutine(bloom(1f));
    	}
    }

    IEnumerator bloom(float strength01) {
    	float duration = .8f;
    	float startTime = Time.time;
    	float endTime = startTime + duration;
    	Floater mixer = new Floater();
    	mixacc.Add(mixer);
    	mixer.value = strength01;
    	while (Time.time < endTime) {
    		mixer.value -= Time.deltaTime / duration * strength01;
    		yield return null;
    	}
    	mixacc.Remove(mixer);
    }

    IEnumerator stutter(float strength01, float period) {
    	float duration = .6f;
    	float startTime = Time.time;
    	float endTime = Time.time + duration;
    	Floater mixer = new Floater();
    	mixacc.Add(mixer);

    	while (Time.time < endTime) {
    		float t = Mathf.InverseLerp(startTime, endTime, Time.time);
    		bool ison = t / period % 2 < 1f;
    		if (ison) {
    			mixer.value = 1;
    		} else {
    			mixer.value = 0;
    		}
    		yield return null;
    	}
    	mixacc.Remove(mixer);
    }

    public class Floater {
    	public float value;
    }
}
