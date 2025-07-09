{
	"patcher" : 	{
		"fileversion" : 1,
		"appversion" : 		{
			"major" : 8,
			"minor" : 6,
			"revision" : 4,
			"architecture" : "x64",
			"modernui" : 1
		}
,
		"classnamespace" : "box",
		"rect" : [ 44.0, 306.0, 1189.0, 570.0 ],
		"bglocked" : 0,
		"openinpresentation" : 1,
		"default_fontsize" : 12.0,
		"default_fontface" : 0,
		"default_fontname" : "Arial",
		"gridonopen" : 1,
		"gridsize" : [ 15.0, 15.0 ],
		"gridsnaponopen" : 1,
		"objectsnaponopen" : 1,
		"statusbarvisible" : 2,
		"toolbarvisible" : 1,
		"lefttoolbarpinned" : 0,
		"toptoolbarpinned" : 0,
		"righttoolbarpinned" : 0,
		"bottomtoolbarpinned" : 0,
		"toolbars_unpinned_last_save" : 0,
		"tallnewobj" : 0,
		"boxanimatetime" : 200,
		"enablehscroll" : 1,
		"enablevscroll" : 1,
		"devicewidth" : 0.0,
		"description" : "",
		"digest" : "",
		"tags" : "",
		"style" : "",
		"subpatcher_template" : "",
		"assistshowspatchername" : 0,
		"boxes" : [ 			{
				"box" : 				{
					"id" : "obj-13",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 895.5, 24.0, 88.0, 20.0 ],
					"text" : "Sensor Names"
				}

			}
, 			{
				"box" : 				{
					"comment" : "",
					"id" : "obj-19",
					"index" : 0,
					"maxclass" : "inlet",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 863.5, 19.0, 30.0, 30.0 ]
				}

			}
, 			{
				"box" : 				{
					"fontface" : 1,
					"fontsize" : 16.0,
					"id" : "obj-18",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 523.0, 83.0, 204.0, 25.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 524.0, 10.0, 137.0, 25.0 ],
					"text" : "Pace (Steps/Min)",
					"textjustification" : 1
				}

			}
, 			{
				"box" : 				{
					"fontface" : 1,
					"fontsize" : 16.0,
					"id" : "obj-15",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 142.0, 83.0, 209.0, 25.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 186.0, 10.0, 141.0, 25.0 ],
					"text" : "Sensor Targets",
					"textjustification" : 1
				}

			}
, 			{
				"box" : 				{
					"fontsize" : 24.0,
					"id" : "obj-17",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 971.5, 138.0, 41.0, 38.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1.0, 5.0, 54.0, 38.0 ],
					"text" : "🎯",
					"textjustification" : 1
				}

			}
, 			{
				"box" : 				{
					"comment" : "",
					"id" : "obj-11",
					"index" : 0,
					"maxclass" : "outlet",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 698.0, 449.0, 30.0, 30.0 ]
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-12",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 730.0, 454.0, 88.0, 20.0 ],
					"text" : "Walking Phase"
				}

			}
, 			{
				"box" : 				{
					"comment" : "",
					"id" : "obj-2",
					"index" : 0,
					"maxclass" : "outlet",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 532.0, 449.0, 30.0, 30.0 ]
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-7",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 564.0, 454.0, 76.0, 20.0 ],
					"text" : "Sensor Type"
				}

			}
, 			{
				"box" : 				{
					"comment" : "",
					"id" : "obj-16",
					"index" : 0,
					"maxclass" : "outlet",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 367.0, 449.0, 30.0, 30.0 ]
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-14",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 399.0, 454.0, 80.0, 20.0 ],
					"text" : "Comments[1]"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-9",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 233.0, 454.0, 80.0, 20.0 ],
					"text" : "Comments[0]"
				}

			}
, 			{
				"box" : 				{
					"comment" : "",
					"id" : "obj-10",
					"index" : 0,
					"maxclass" : "outlet",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 201.0, 449.0, 30.0, 30.0 ]
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-8",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 68.0, 454.0, 35.0, 20.0 ],
					"text" : "Plots"
				}

			}
, 			{
				"box" : 				{
					"comment" : "",
					"id" : "obj-6",
					"index" : 0,
					"maxclass" : "outlet",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 36.0, 449.0, 30.0, 30.0 ]
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-4",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 481.5, 24.0, 74.0, 20.0 ],
					"text" : "View Length"
				}

			}
, 			{
				"box" : 				{
					"comment" : "",
					"id" : "obj-5",
					"index" : 0,
					"maxclass" : "inlet",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 449.5, 19.0, 30.0, 30.0 ]
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-3",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 68.0, 24.0, 76.0, 20.0 ],
					"text" : "Sensor Type"
				}

			}
, 			{
				"box" : 				{
					"comment" : "",
					"id" : "obj-1",
					"index" : 0,
					"maxclass" : "inlet",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 36.0, 19.0, 30.0, 30.0 ]
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-26",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 863.5, 416.0, 102.0, 22.0 ],
					"text" : "s sensorsMinMax"
				}

			}
, 			{
				"box" : 				{
					"bgmode" : 0,
					"border" : 0,
					"clickthrough" : 0,
					"enablehscroll" : 0,
					"enablevscroll" : 0,
					"id" : "obj-177",
					"lockeddragscroll" : 0,
					"lockedsize" : 0,
					"maxclass" : "bpatcher",
					"name" : "guiParams.maxpat",
					"numinlets" : 3,
					"numoutlets" : 6,
					"offset" : [ 0.0, 0.0 ],
					"outlettype" : [ "", "", "", "", "", "" ],
					"patching_rect" : [ 35.5, 115.0, 847.0, 288.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1.0, 45.0, 723.0, 287.0 ],
					"varname" : "patcher",
					"viewvisibility" : 1
				}

			}
, 			{
				"box" : 				{
					"angle" : 270.0,
					"bgcolor" : [ 0.2, 0.2, 0.2, 0.0 ],
					"border" : 2,
					"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
					"id" : "obj-69",
					"maxclass" : "panel",
					"mode" : 0,
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 928.0, 195.0, 128.0, 128.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 57.0, 6.0, 399.0, 33.0 ],
					"proportion" : 0.5
				}

			}
, 			{
				"box" : 				{
					"angle" : 270.0,
					"bgcolor" : [ 0.2, 0.2, 0.2, 0.0 ],
					"border" : 2,
					"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
					"id" : "obj-30",
					"maxclass" : "panel",
					"mode" : 0,
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 943.0, 210.0, 128.0, 128.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 464.0, 6.0, 258.0, 33.0 ],
					"proportion" : 0.5
				}

			}
 ],
		"lines" : [ 			{
				"patchline" : 				{
					"destination" : [ "obj-177", 0 ],
					"source" : [ "obj-1", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-10", 0 ],
					"source" : [ "obj-177", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-11", 0 ],
					"source" : [ "obj-177", 4 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-16", 0 ],
					"source" : [ "obj-177", 2 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-2", 0 ],
					"source" : [ "obj-177", 3 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-26", 0 ],
					"source" : [ "obj-177", 5 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-6", 0 ],
					"source" : [ "obj-177", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-177", 2 ],
					"source" : [ "obj-19", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-177", 1 ],
					"source" : [ "obj-5", 0 ]
				}

			}
 ],
		"parameters" : 		{
			"obj-177::obj-115" : [ "live.numbox[56]", "live.numbox", 0 ],
			"obj-177::obj-120" : [ "live.numbox[80]", "live.numbox", 0 ],
			"obj-177::obj-121" : [ "live.text[19]", "live.menu[1]", 0 ],
			"obj-177::obj-126::obj-102::obj-101" : [ "live.numbox[72]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-102" : [ "live.numbox[27]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-106" : [ "live.numbox[28]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-108" : [ "live.numbox[29]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-109" : [ "live.numbox[30]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-110" : [ "live.numbox[5]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-111" : [ "live.numbox[69]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-112" : [ "live.numbox[42]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-114" : [ "live.numbox[34]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-115" : [ "live.numbox[88]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-116" : [ "live.numbox[63]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-125" : [ "live.numbox[86]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-128" : [ "live.numbox[38]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-129" : [ "live.numbox[39]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-130" : [ "live.numbox[65]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-131" : [ "live.numbox[53]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-132" : [ "live.numbox[87]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-133" : [ "live.numbox[43]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-134" : [ "live.numbox[44]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-135" : [ "live.numbox[45]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-14" : [ "live.numbox", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-145" : [ "live.numbox[46]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-147" : [ "live.numbox[47]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-149" : [ "live.numbox[48]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-151" : [ "live.numbox[66]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-162" : [ "live.text[1]", "live.text", 0 ],
			"obj-177::obj-126::obj-102::obj-20" : [ "live.numbox[3]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-25" : [ "live.numbox[49]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-29" : [ "live.numbox[50]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-38" : [ "live.numbox[6]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-39" : [ "live.numbox[52]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-40" : [ "live.numbox[41]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-41" : [ "live.numbox[9]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-42" : [ "live.numbox[77]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-43" : [ "live.numbox[54]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-44" : [ "live.numbox[12]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-45" : [ "live.numbox[13]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-51" : [ "live.numbox[14]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-52" : [ "live.numbox[15]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-54" : [ "live.numbox[74]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-55" : [ "live.numbox[17]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-56" : [ "live.numbox[40]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-57" : [ "live.numbox[19]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-58" : [ "live.numbox[20]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-59" : [ "live.numbox[21]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-60" : [ "live.numbox[22]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-61" : [ "live.numbox[23]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-62" : [ "live.numbox[24]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-64" : [ "live.numbox[25]", "live.numbox", 1 ],
			"obj-177::obj-126::obj-102::obj-68" : [ "live.text[17]", "live.text", 0 ],
			"obj-177::obj-12::obj-105" : [ "live.numbox[84]", "live.numbox", 0 ],
			"obj-177::obj-12::obj-106" : [ "live.numbox[58]", "live.numbox", 0 ],
			"obj-177::obj-12::obj-158" : [ "live.text[14]", "live.menu[1]", 0 ],
			"obj-177::obj-12::obj-2" : [ "live.text[5]", "live.text[12]", 0 ],
			"obj-177::obj-12::obj-3" : [ "live.text[4]", "live.text[12]", 0 ],
			"obj-177::obj-141::obj-105" : [ "live.numbox[78]", "live.numbox", 0 ],
			"obj-177::obj-141::obj-106" : [ "live.numbox[90]", "live.numbox", 0 ],
			"obj-177::obj-141::obj-158" : [ "live.text[22]", "live.menu[1]", 0 ],
			"obj-177::obj-141::obj-2" : [ "live.text[12]", "live.text[12]", 0 ],
			"obj-177::obj-141::obj-3" : [ "live.text[13]", "live.text[12]", 0 ],
			"obj-177::obj-25" : [ "live.numbox[92]", "live.numbox", 0 ],
			"obj-177::obj-30" : [ "live.text[24]", "live.text[1]", 0 ],
			"obj-177::obj-7" : [ "live.numbox[55]", "live.numbox", 0 ],
			"obj-177::obj-74" : [ "live.numbox[67]", "live.numbox", 0 ],
			"obj-177::obj-8" : [ "live.numbox[91]", "live.numbox", 0 ],
			"obj-177::obj-96" : [ "live.text[6]", "live.text[6]", 0 ],
			"parameterbanks" : 			{
				"0" : 				{
					"index" : 0,
					"name" : "",
					"parameters" : [ "-", "-", "-", "-", "-", "-", "-", "-" ]
				}

			}
,
			"parameter_overrides" : 			{
				"obj-177::obj-115" : 				{
					"parameter_longname" : "live.numbox[56]",
					"parameter_range" : [ -180.0, 180.0 ],
					"parameter_units" : "%d°"
				}
,
				"obj-177::obj-120" : 				{
					"parameter_range" : [ 0.0, 180.0 ],
					"parameter_units" : "%d°"
				}
,
				"obj-177::obj-126::obj-102::obj-101" : 				{
					"parameter_longname" : "live.numbox[72]"
				}
,
				"obj-177::obj-126::obj-102::obj-110" : 				{
					"parameter_longname" : "live.numbox[5]"
				}
,
				"obj-177::obj-126::obj-102::obj-111" : 				{
					"parameter_longname" : "live.numbox[69]"
				}
,
				"obj-177::obj-126::obj-102::obj-112" : 				{
					"parameter_longname" : "live.numbox[42]"
				}
,
				"obj-177::obj-126::obj-102::obj-115" : 				{
					"parameter_longname" : "live.numbox[88]"
				}
,
				"obj-177::obj-126::obj-102::obj-116" : 				{
					"parameter_longname" : "live.numbox[63]"
				}
,
				"obj-177::obj-126::obj-102::obj-125" : 				{
					"parameter_longname" : "live.numbox[86]"
				}
,
				"obj-177::obj-126::obj-102::obj-130" : 				{
					"parameter_longname" : "live.numbox[65]"
				}
,
				"obj-177::obj-126::obj-102::obj-131" : 				{
					"parameter_longname" : "live.numbox[53]"
				}
,
				"obj-177::obj-126::obj-102::obj-132" : 				{
					"parameter_longname" : "live.numbox[87]"
				}
,
				"obj-177::obj-126::obj-102::obj-151" : 				{
					"parameter_longname" : "live.numbox[66]"
				}
,
				"obj-177::obj-126::obj-102::obj-20" : 				{
					"parameter_longname" : "live.numbox[3]"
				}
,
				"obj-177::obj-126::obj-102::obj-25" : 				{
					"parameter_longname" : "live.numbox[49]"
				}
,
				"obj-177::obj-126::obj-102::obj-29" : 				{
					"parameter_longname" : "live.numbox[50]"
				}
,
				"obj-177::obj-126::obj-102::obj-39" : 				{
					"parameter_longname" : "live.numbox[52]"
				}
,
				"obj-177::obj-126::obj-102::obj-40" : 				{
					"parameter_longname" : "live.numbox[41]"
				}
,
				"obj-177::obj-126::obj-102::obj-42" : 				{
					"parameter_longname" : "live.numbox[77]"
				}
,
				"obj-177::obj-126::obj-102::obj-43" : 				{
					"parameter_longname" : "live.numbox[54]"
				}
,
				"obj-177::obj-126::obj-102::obj-54" : 				{
					"parameter_longname" : "live.numbox[74]"
				}
,
				"obj-177::obj-126::obj-102::obj-56" : 				{
					"parameter_longname" : "live.numbox[40]"
				}
,
				"obj-177::obj-126::obj-102::obj-68" : 				{
					"parameter_longname" : "live.text[17]"
				}
,
				"obj-177::obj-12::obj-105" : 				{
					"parameter_initial" : 140,
					"parameter_longname" : "live.numbox[84]",
					"parameter_range" : [ -180.0, 180.0 ],
					"parameter_units" : "= %d°"
				}
,
				"obj-177::obj-12::obj-106" : 				{
					"parameter_range" : [ -180.0, 180.0 ],
					"parameter_units" : "= %d°"
				}
,
				"obj-177::obj-12::obj-158" : 				{
					"parameter_longname" : "live.text[14]"
				}
,
				"obj-177::obj-141::obj-105" : 				{
					"parameter_initial" : 140,
					"parameter_longname" : "live.numbox[78]",
					"parameter_range" : [ -180.0, 180.0 ],
					"parameter_units" : "= %d°"
				}
,
				"obj-177::obj-141::obj-106" : 				{
					"parameter_longname" : "live.numbox[90]",
					"parameter_range" : [ -180.0, 180.0 ],
					"parameter_units" : "= %d°"
				}
,
				"obj-177::obj-25" : 				{
					"parameter_longname" : "live.numbox[92]"
				}
,
				"obj-177::obj-30" : 				{
					"parameter_longname" : "live.text[24]"
				}
,
				"obj-177::obj-7" : 				{
					"parameter_range" : [ 0.0, 180.0 ],
					"parameter_units" : "%d°"
				}
,
				"obj-177::obj-74" : 				{
					"parameter_longname" : "live.numbox[67]"
				}
,
				"obj-177::obj-8" : 				{
					"parameter_longname" : "live.numbox[91]",
					"parameter_range" : [ -180.0, 180.0 ],
					"parameter_units" : "%d°"
				}

			}
,
			"inherited_shortname" : 1
		}
,
		"dependency_cache" : [ 			{
				"name" : "deviation.js",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "TEXT",
				"implicit" : 1
			}
, 			{
				"name" : "guiParams.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "lookupGAIT.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "pattrLookup.json",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "thru.maxpat",
				"bootpath" : "C74:/patchers/m4l/Pluggo for Live resources/patches",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "windows.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
 ],
		"autosave" : 0
	}

}
