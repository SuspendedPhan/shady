using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class mbCubes : MonoBehaviour {
	public GameObject pCube;
	List<GameObject> list1 = new List<GameObject>();
	List<GameObject> list2 = new List<GameObject>();

	// Use this for initialization
	void Start () {
		var parent = new GameObject("Cubes");

		bool bX = true;
		bool bY = true;
		bool bZ = true;
		for (float x = -15; x < 15; x += 2)
		{
			bX = !bX;
			bY = bX;
			for (float y = -15; y < 15; y += 2)
			{
				bY = !bY;
				bZ = bY;
				for (float z = -2; z < 20; z += 2)
				{
					bZ = !bZ;
					var cube = Instantiate(pCube, parent.transform);
					cube.transform.position = new Vector3(x, y, z);
					if (bZ)
					{
						list1.Add(cube);
					}
					else
					{
						list2.Add(cube);
					}
				}
			}
		}
	}
	
	// Update is called once per frame
	void Update () {
		var hue = Input.mousePosition.x / Screen.width;
		var scale = Input.mousePosition.y / Screen.height;
		scale = Mathf.Clamp01(scale) * 2;
		// float hue = .25f;
		float hue2 = 1 - hue;
		foreach (var cube in list1)
		{
			var color = Color.HSVToRGB(hue, 1, 1);
			cube.GetComponent<Renderer>().material.SetColor("_Color", color);
			cube.transform.localScale = new Vector3(scale, scale, scale);
		}
		foreach (var cube in list2)
		{
			var color = Color.HSVToRGB(hue2, 1, 1);
			cube.GetComponent<Renderer>().material.SetColor("_Color", color);
			cube.transform.localScale = new Vector3(scale, scale, scale);
		}
	}
}
