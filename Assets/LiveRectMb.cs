using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LiveRectMb : MonoBehaviour
{
	private Vector2 screenFillScale = new Vector2(.25f, .25f);

	private Rect rect;
	public Rect Rect
	{
		get
		{
			return rect;
		}
		set
		{
			rect = value;
			transform.position = value.center * .5f;
			// transform.localScale = new Vector3(value.width, value.height, 1.0f);
			transform.localScale = new Vector3(screenFillScale.x * value.width, screenFillScale.y * value.height, 1.0f);
		}
	}

	public Color Color
	{
		get
		{
			return GetComponent<Renderer>().material.color;
		}
		set
		{
			GetComponent<Renderer>().material.color = value;
		}
	}

	void Awake()
	{
		GetComponent<Renderer>().material = new Material(Shader.Find("Unlit/Color"));
	}

    // Update is called once per frame
    void Update()
    {
    }
}
