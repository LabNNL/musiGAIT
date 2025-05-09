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
		"rect" : [ 205.0, 215.0, 1124.0, 551.0 ],
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
					"id" : "obj-47",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "path", "int" ],
					"patching_rect" : [ 36.0, 53.0, 826.0, 22.0 ],
					"text" : "t path 0"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-30",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 8,
							"minor" : 6,
							"revision" : 4,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 237.0, 590.0, 1430.0, 293.0 ],
						"bglocked" : 0,
						"openinpresentation" : 0,
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
						"boxes" : [ 							{
								"box" : 								{
									"id" : "obj-3",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 102.0, 169.0, 1283.0, 22.0 ],
									"text" : "window flags zoom, window flags minimize, window flags grow, window flags nofloat, window flags close, window flags menu, window exec, toolbarvisible 1, lefttoolbarpinned 1, righttoolbarpinned 1, toptoolbarpinned 1, bottomtoolbarpinned 1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-1",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "bang", "" ],
									"patching_rect" : [ 45.0, 90.0, 76.0, 22.0 ],
									"text" : "sel 0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-21",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 45.0, 129.0, 1323.0, 22.0 ],
									"text" : "window flags nozoom, window flags nominimize, window flags nogrow, window flags float, window flags close, window flags nomenu, window exec, toolbarvisible 0, lefttoolbarpinned 2, righttoolbarpinned 2, toptoolbarpinned 2, bottomtoolbarpinned 2"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-22",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"patching_rect" : [ 45.0, 39.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-23",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 45.0, 212.0, 30.0, 30.0 ]
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 0 ],
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-1", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"source" : [ "obj-21", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-22", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"source" : [ "obj-3", 0 ]
								}

							}
 ]
					}
,
					"patching_rect" : [ 843.0, 159.0, 59.0, 22.0 ],
					"saved_object_attributes" : 					{
						"description" : "",
						"digest" : "",
						"globalpatchername" : "",
						"tags" : ""
					}
,
					"text" : "p window"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-14",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"patching_rect" : [ 84.0, 202.0, 67.0, 22.0 ],
					"save" : [ "#N", "thispatcher", ";", "#Q", "end", ";" ],
					"text" : "thispatcher"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-13",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 84.0, 159.0, 720.0, 22.0 ],
					"text" : "script delete __main__, script newdefault __main__ 84 260 bpatcher @name $1 @presentation 1 @presentation_rect 0. 0. 1123. 551."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-9",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 84.0, 123.0, 231.0, 22.0 ],
					"text" : "sprintf symout %saudio/__main__.maxpat"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-6",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"patching_rect" : [ 36.0, 89.0, 67.0, 22.0 ],
					"save" : [ "#N", "thispatcher", ";", "#Q", "end", ";" ],
					"text" : "thispatcher"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-1",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 36.0, 18.0, 58.0, 22.0 ],
					"text" : "loadbang"
				}

			}
, 			{
				"box" : 				{
					"bgmode" : 0,
					"border" : 0,
					"clickthrough" : 0,
					"enablehscroll" : 0,
					"enablevscroll" : 0,
					"id" : "obj-3",
					"lockeddragscroll" : 0,
					"lockedsize" : 0,
					"maxclass" : "bpatcher",
					"name" : "__main__.maxpat",
					"numinlets" : 0,
					"numoutlets" : 0,
					"offset" : [ 0.0, 0.0 ],
					"patching_rect" : [ 84.0, 260.0, 128.0, 128.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 0.0, 0.0, 1123.0, 551.0 ],
					"varname" : "__main__",
					"viewvisibility" : 1
				}

			}
 ],
		"lines" : [ 			{
				"patchline" : 				{
					"destination" : [ "obj-47", 0 ],
					"source" : [ "obj-1", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-14", 0 ],
					"source" : [ "obj-13", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-14", 0 ],
					"source" : [ "obj-30", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-30", 0 ],
					"source" : [ "obj-47", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-6", 0 ],
					"source" : [ "obj-47", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-9", 0 ],
					"source" : [ "obj-6", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-13", 0 ],
					"source" : [ "obj-9", 0 ]
				}

			}
 ],
		"parameters" : 		{
			"obj-3::obj-119::obj-97" : [ "live.text[3]", "live.text[3]", 0 ],
			"obj-3::obj-135" : [ "live.text[16]", "live.text[1]", 0 ],
			"obj-3::obj-147::obj-10" : [ "live.tab", "live.tab", 0 ],
			"obj-3::obj-147::obj-115" : [ "live.numbox[4]", "Freq", 0 ],
			"obj-3::obj-147::obj-116" : [ "live.numbox[5]", "Freq", 0 ],
			"obj-3::obj-147::obj-137" : [ "live.menu[4]", "live.menu", 0 ],
			"obj-3::obj-147::obj-14" : [ "live.numbox[1]", "Freq", 0 ],
			"obj-3::obj-147::obj-148" : [ "live.numbox[6]", "Freq", 0 ],
			"obj-3::obj-147::obj-149" : [ "live.numbox[7]", "Freq", 0 ],
			"obj-3::obj-147::obj-15" : [ "live.numbox", "Freq", 0 ],
			"obj-3::obj-147::obj-178" : [ "live.numbox[9]", "Freq", 0 ],
			"obj-3::obj-147::obj-179" : [ "live.numbox[10]", "Freq", 0 ],
			"obj-3::obj-147::obj-48" : [ "live.numbox[12]", "Freq", 0 ],
			"obj-3::obj-147::obj-49" : [ "live.numbox[13]", "Freq", 0 ],
			"obj-3::obj-147::obj-52" : [ "live.gain~", "Audio", 0 ],
			"obj-3::obj-147::obj-75" : [ "live.text[2]", "live.text", 0 ],
			"obj-3::obj-147::obj-85" : [ "live.numbox[16]", "Freq", 0 ],
			"obj-3::obj-147::obj-86" : [ "live.numbox[17]", "Freq", 0 ],
			"obj-3::obj-167::obj-21" : [ "live.numbox[81]", "live.numbox[2]", 0 ],
			"obj-3::obj-167::obj-22" : [ "live.numbox[85]", "live.numbox[2]", 0 ],
			"obj-3::obj-167::obj-29" : [ "live.numbox[82]", "live.numbox[2]", 0 ],
			"obj-3::obj-167::obj-36" : [ "live.numbox[83]", "live.numbox[2]", 0 ],
			"obj-3::obj-167::obj-40" : [ "live.numbox[2]", "live.numbox[2]", 0 ],
			"obj-3::obj-177::obj-115" : [ "live.numbox[65]", "live.numbox", 0 ],
			"obj-3::obj-177::obj-120" : [ "live.numbox[80]", "live.numbox", 0 ],
			"obj-3::obj-177::obj-121" : [ "live.text[19]", "live.menu[1]", 0 ],
			"obj-3::obj-177::obj-126::obj-102::obj-101" : [ "live.numbox[59]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-102" : [ "live.numbox[27]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-106" : [ "live.numbox[28]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-108" : [ "live.numbox[29]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-109" : [ "live.numbox[30]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-110" : [ "live.numbox[31]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-111" : [ "live.numbox[57]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-112" : [ "live.numbox[33]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-114" : [ "live.numbox[34]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-115" : [ "live.numbox[26]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-116" : [ "live.numbox[36]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-125" : [ "live.numbox[37]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-128" : [ "live.numbox[38]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-129" : [ "live.numbox[39]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-130" : [ "live.numbox[40]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-131" : [ "live.numbox[41]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-132" : [ "live.numbox[60]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-133" : [ "live.numbox[43]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-134" : [ "live.numbox[44]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-135" : [ "live.numbox[45]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-14" : [ "live.numbox[53]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-145" : [ "live.numbox[46]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-147" : [ "live.numbox[54]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-149" : [ "live.numbox[48]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-151" : [ "live.numbox[49]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-162" : [ "live.text[1]", "live.text", 0 ],
			"obj-3::obj-177::obj-126::obj-102::obj-20" : [ "live.numbox[8]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-25" : [ "live.numbox[3]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-29" : [ "live.numbox[42]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-38" : [ "live.numbox[14]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-39" : [ "live.numbox[56]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-40" : [ "live.numbox[22]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-41" : [ "live.numbox[51]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-42" : [ "live.numbox[47]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-43" : [ "live.numbox[11]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-44" : [ "live.numbox[52]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-45" : [ "live.numbox[20]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-51" : [ "live.numbox[55]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-52" : [ "live.numbox[58]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-54" : [ "live.numbox[25]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-55" : [ "live.numbox[32]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-56" : [ "live.numbox[18]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-57" : [ "live.numbox[19]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-58" : [ "live.numbox[50]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-59" : [ "live.numbox[21]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-60" : [ "live.numbox[15]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-61" : [ "live.numbox[23]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-62" : [ "live.numbox[24]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-64" : [ "live.numbox[35]", "live.numbox", 1 ],
			"obj-3::obj-177::obj-126::obj-102::obj-68" : [ "live.text[4]", "live.text", 0 ],
			"obj-3::obj-177::obj-136" : [ "live.numbox[67]", "live.numbox", 0 ],
			"obj-3::obj-177::obj-141::obj-105" : [ "live.numbox[62]", "live.numbox", 0 ],
			"obj-3::obj-177::obj-141::obj-106" : [ "live.numbox[61]", "live.numbox", 0 ],
			"obj-3::obj-177::obj-141::obj-158" : [ "live.text[22]", "live.menu[1]", 0 ],
			"obj-3::obj-177::obj-141::obj-189" : [ "live.numbox[63]", "live.numbox", 0 ],
			"obj-3::obj-177::obj-141::obj-190" : [ "live.numbox[64]", "live.numbox", 0 ],
			"obj-3::obj-177::obj-141::obj-2" : [ "live.text[12]", "live.text[12]", 0 ],
			"obj-3::obj-177::obj-141::obj-26" : [ "live.text[14]", "live.text[12]", 0 ],
			"obj-3::obj-177::obj-141::obj-27" : [ "live.text[21]", "live.text[12]", 0 ],
			"obj-3::obj-177::obj-141::obj-3" : [ "live.text[13]", "live.text[12]", 0 ],
			"obj-3::obj-177::obj-144" : [ "live.numbox[79]", "live.numbox", 0 ],
			"obj-3::obj-177::obj-25" : [ "live.numbox[84]", "live.numbox", 0 ],
			"obj-3::obj-177::obj-30" : [ "live.text[23]", "live.text[1]", 0 ],
			"obj-3::obj-177::obj-74" : [ "live.numbox[66]", "live.numbox", 0 ],
			"obj-3::obj-177::obj-96" : [ "live.text[6]", "live.text[6]", 0 ],
			"obj-3::obj-214" : [ "live.menu[9]", "live.menu", 0 ],
			"obj-3::obj-215" : [ "live.text[24]", "live.text[1]", 0 ],
			"obj-3::obj-230" : [ "live.text[5]", "live.text[14]", 0 ],
			"obj-3::obj-23::obj-119::obj-10" : [ "live.menu[2]", "live.menu", 0 ],
			"obj-3::obj-23::obj-119::obj-16" : [ "live.menu[3]", "live.menu", 0 ],
			"obj-3::obj-23::obj-119::obj-20" : [ "live.text[15]", "live.text", 0 ],
			"obj-3::obj-23::obj-119::obj-33" : [ "live.menu[7]", "live.menu", 0 ],
			"obj-3::obj-23::obj-119::obj-34" : [ "live.menu[5]", "live.menu", 0 ],
			"obj-3::obj-23::obj-119::obj-35" : [ "live.menu[6]", "live.menu", 0 ],
			"obj-3::obj-23::obj-119::obj-8" : [ "live.menu", "live.menu", 0 ],
			"obj-3::obj-23::obj-119::obj-9" : [ "live.menu[1]", "live.menu", 0 ],
			"obj-3::obj-3" : [ "live.numbox[86]", "live.numbox[8]", 0 ],
			"obj-3::obj-36" : [ "live.text[7]", "live.text[1]", 0 ],
			"obj-3::obj-4" : [ "radiogroup", "radiogroup", 0 ],
			"obj-3::obj-49" : [ "live.text[20]", "live.menu[1]", 0 ],
			"obj-3::obj-67" : [ "live.menu[8]", "live.menu", 0 ],
			"obj-3::obj-85::obj-87" : [ "live.text", "live.text", 0 ],
			"obj-3::obj-95" : [ "radiogroup[1]", "radiogroup[1]", 0 ],
			"parameterbanks" : 			{
				"0" : 				{
					"index" : 0,
					"name" : "",
					"parameters" : [ "-", "-", "-", "-", "-", "-", "-", "-" ]
				}

			}
,
			"parameter_overrides" : 			{
				"obj-3::obj-135" : 				{
					"parameter_longname" : "live.text[16]"
				}
,
				"obj-3::obj-177::obj-115" : 				{
					"parameter_longname" : "live.numbox[65]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-101" : 				{
					"parameter_longname" : "live.numbox[59]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-111" : 				{
					"parameter_longname" : "live.numbox[57]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-115" : 				{
					"parameter_longname" : "live.numbox[26]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-132" : 				{
					"parameter_longname" : "live.numbox[60]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-14" : 				{
					"parameter_longname" : "live.numbox[53]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-147" : 				{
					"parameter_longname" : "live.numbox[54]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-20" : 				{
					"parameter_longname" : "live.numbox[8]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-29" : 				{
					"parameter_longname" : "live.numbox[42]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-38" : 				{
					"parameter_longname" : "live.numbox[14]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-39" : 				{
					"parameter_longname" : "live.numbox[56]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-40" : 				{
					"parameter_longname" : "live.numbox[22]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-41" : 				{
					"parameter_longname" : "live.numbox[51]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-42" : 				{
					"parameter_longname" : "live.numbox[47]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-44" : 				{
					"parameter_longname" : "live.numbox[52]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-45" : 				{
					"parameter_longname" : "live.numbox[20]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-51" : 				{
					"parameter_longname" : "live.numbox[55]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-52" : 				{
					"parameter_longname" : "live.numbox[58]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-54" : 				{
					"parameter_longname" : "live.numbox[25]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-55" : 				{
					"parameter_longname" : "live.numbox[32]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-58" : 				{
					"parameter_longname" : "live.numbox[50]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-60" : 				{
					"parameter_longname" : "live.numbox[15]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-64" : 				{
					"parameter_longname" : "live.numbox[35]"
				}
,
				"obj-3::obj-177::obj-126::obj-102::obj-68" : 				{
					"parameter_longname" : "live.text[4]"
				}
,
				"obj-3::obj-177::obj-136" : 				{
					"parameter_longname" : "live.numbox[67]"
				}
,
				"obj-3::obj-177::obj-141::obj-105" : 				{
					"parameter_longname" : "live.numbox[62]"
				}
,
				"obj-3::obj-177::obj-141::obj-106" : 				{
					"parameter_longname" : "live.numbox[61]"
				}
,
				"obj-3::obj-177::obj-141::obj-189" : 				{
					"parameter_longname" : "live.numbox[63]"
				}
,
				"obj-3::obj-177::obj-141::obj-190" : 				{
					"parameter_longname" : "live.numbox[64]"
				}
,
				"obj-3::obj-177::obj-30" : 				{
					"parameter_longname" : "live.text[23]"
				}
,
				"obj-3::obj-177::obj-74" : 				{
					"parameter_longname" : "live.numbox[66]"
				}
,
				"obj-3::obj-214" : 				{
					"parameter_longname" : "live.menu[9]"
				}
,
				"obj-3::obj-215" : 				{
					"parameter_longname" : "live.text[24]"
				}
,
				"obj-3::obj-23::obj-119::obj-10" : 				{
					"parameter_invisible" : 0,
					"parameter_modmode" : 0,
					"parameter_range" : [ "*", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024", "2025" ],
					"parameter_type" : 2,
					"parameter_unitstyle" : 10
				}
,
				"obj-3::obj-23::obj-119::obj-20" : 				{
					"parameter_longname" : "live.text[15]"
				}
,
				"obj-3::obj-23::obj-119::obj-33" : 				{
					"parameter_invisible" : 0,
					"parameter_longname" : "live.menu[7]",
					"parameter_modmode" : 0,
					"parameter_range" : [ "2023", "2024", "2025" ],
					"parameter_type" : 2,
					"parameter_unitstyle" : 10
				}
,
				"obj-3::obj-3" : 				{
					"parameter_longname" : "live.numbox[86]"
				}
,
				"obj-3::obj-67" : 				{
					"parameter_longname" : "live.menu[8]"
				}

			}
,
			"inherited_shortname" : 1
		}
,
		"dependency_cache" : [ 			{
				"name" : "__main__.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : "./audio",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "crossFade.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : "./audio",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "fluid.chroma~.mxe64",
				"type" : "mx64"
			}
, 			{
				"name" : "fluid.spectralshape~.mxe64",
				"type" : "mx64"
			}
, 			{
				"name" : "fluid.stats.mxe64",
				"type" : "mx64"
			}
, 			{
				"name" : "getTime.js",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : "./audio",
				"type" : "TEXT",
				"implicit" : 1
			}
, 			{
				"name" : "guiAnalyzers.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : "./audio",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "guiParams.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : "./audio",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "guiSliders.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : "./audio",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "logger.js",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : "./audio",
				"type" : "TEXT",
				"implicit" : 1
			}
, 			{
				"name" : "logger.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : "./audio",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "lookupGAIT.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : "./audio",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "pMatrix.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : "./audio",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "pSimpleSine.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : "./audio",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "plotter.js",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : "./audio",
				"type" : "TEXT",
				"implicit" : 1
			}
, 			{
				"name" : "shell.mxe64",
				"type" : "mx64"
			}
, 			{
				"name" : "sigmund~.mxe64",
				"type" : "mx64"
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
				"patcherrelativepath" : "./audio",
				"type" : "JSON",
				"implicit" : 1
			}
 ],
		"autosave" : 0
	}

}
