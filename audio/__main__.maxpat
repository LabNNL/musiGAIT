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
		"rect" : [ 145.0, 184.0, 1237.0, 619.0 ],
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
					"coll_data" : 					{
						"count" : 4,
						"data" : [ 							{
								"key" : 4,
								"value" : [ 0.263, 0.627, 0.278, 1 ]
							}
, 							{
								"key" : 3,
								"value" : [ 0.984, 0.549, 0.0, 1 ]
							}
, 							{
								"key" : 2,
								"value" : [ 0.557, 0.141, 0.667, 1 ]
							}
, 							{
								"key" : 1,
								"value" : [ 0.118, 0.533, 0.898, 1 ]
							}
 ]
					}
,
					"color" : [ 0.890196078431372, 0.345098039215686, 0.345098039215686, 1.0 ],
					"id" : "obj-7",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 4,
					"outlettype" : [ "", "", "", "" ],
					"patching_rect" : [ 64.0, 179.0, 163.0, 22.0 ],
					"saved_object_attributes" : 					{
						"embed" : 1,
						"precision" : 6
					}
,
					"text" : "coll sensorColors @embed 1"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-9",
					"linecount" : 4,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 73.0, 203.0, 146.0, 62.0 ],
					"text" : "1: Sensor 1 :: EMG\n2. Sensor 2 :: EMG\n3. Sensor 1 :: Goniometer\n4. Sensor 2 :: Goniometer"
				}

			}
, 			{
				"box" : 				{
					"bgmode" : 0,
					"border" : 0,
					"clickthrough" : 0,
					"enablehscroll" : 0,
					"enablevscroll" : 0,
					"id" : "obj-33",
					"lockeddragscroll" : 0,
					"lockedsize" : 0,
					"maxclass" : "bpatcher",
					"name" : "tabLiveMonitor.maxpat",
					"numinlets" : 4,
					"numoutlets" : 0,
					"offset" : [ 0.0, 0.0 ],
					"patching_rect" : [ 1338.0, 1243.0, 313.0, 584.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 891.0, 0.0, 312.0, 582.0 ],
					"viewvisibility" : 1
				}

			}
, 			{
				"box" : 				{
					"fontsize" : 14.0,
					"id" : "obj-27",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 744.375, 32.0, 97.0, 23.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 304.0, 312.0, 97.0, 23.0 ],
					"text" : "Time Window:",
					"textcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
					"varname" : "viewLengthCom"
				}

			}
, 			{
				"box" : 				{
					"fontsize" : 14.0,
					"id" : "obj-36",
					"maxclass" : "live.numbox",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "float" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 843.375, 33.0, 106.0, 20.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 403.0, 314.0, 59.0, 20.0 ],
					"saved_attribute_attributes" : 					{
						"valueof" : 						{
							"parameter_initial" : [ 3 ],
							"parameter_initial_enable" : 1,
							"parameter_longname" : "live.numbox[136]",
							"parameter_mmax" : 60.0,
							"parameter_mmin" : 1.0,
							"parameter_modmode" : 4,
							"parameter_shortname" : "live.numbox[60]",
							"parameter_type" : 1,
							"parameter_units" : "%d sec",
							"parameter_unitstyle" : 9
						}

					}
,
					"varname" : "viewLength"
				}

			}
, 			{
				"box" : 				{
					"bgmode" : 0,
					"border" : 0,
					"clickthrough" : 0,
					"enablehscroll" : 0,
					"enablevscroll" : 0,
					"hidden" : 1,
					"id" : "obj-8",
					"lockeddragscroll" : 0,
					"lockedsize" : 0,
					"maxclass" : "bpatcher",
					"name" : "tabAudio.maxpat",
					"numinlets" : 2,
					"numoutlets" : 1,
					"offset" : [ 0.0, 0.0 ],
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 421.0, 1244.0, 864.0, 518.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 14.0, 52.0, 861.0, 518.0 ],
					"varname" : "tabAudio",
					"viewvisibility" : 1
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-20",
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
						"rect" : [ 129.0, 592.0, 633.0, 397.0 ],
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
									"id" : "obj-26",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : 									{
										"fileversion" : 1,
										"appversion" : 										{
											"major" : 8,
											"minor" : 6,
											"revision" : 4,
											"architecture" : "x64",
											"modernui" : 1
										}
,
										"classnamespace" : "box",
										"rect" : [ 135.0, 685.0, 1090.0, 346.0 ],
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
										"boxes" : [ 											{
												"box" : 												{
													"id" : "obj-11",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 472.0, 174.0, 99.0, 22.0 ],
													"text" : "403. 216. 59. 20."
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-12",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 134.0, 174.0, 99.0, 22.0 ],
													"text" : "304. 214. 97. 23."
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-10",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 359.0, 174.0, 99.0, 22.0 ],
													"text" : "403. 314. 59. 20."
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-9",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 24.0, 174.0, 99.0, 22.0 ],
													"text" : "304. 312. 97. 23."
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-7",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 359.0, 214.0, 293.0, 22.0 ],
													"text" : "script send viewLength presentation_rect $1 $2 $3 $4"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-5",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 24.0, 214.0, 319.0, 22.0 ],
													"text" : "script send viewLengthCom presentation_rect $1 $2 $3 $4"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 3,
													"outlettype" : [ "bang", "bang", "bang" ],
													"patching_rect" : [ 364.5, 120.0, 40.0, 22.0 ],
													"text" : "b 3"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-1",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 3,
													"outlettype" : [ "bang", "bang", "bang" ],
													"patching_rect" : [ 24.0, 120.0, 40.0, 22.0 ],
													"text" : "b 3"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-20",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 658.0, 214.0, 259.0, 22.0 ],
													"text" : "script $1 viewLength, script $1 viewLengthCom"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-21",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 658.0, 174.0, 37.0, 22.0 ],
													"text" : "show"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-22",
													"maxclass" : "newobj",
													"numinlets" : 4,
													"numoutlets" : 4,
													"outlettype" : [ "bang", "bang", "bang", "" ],
													"patching_rect" : [ 24.0, 83.0, 1040.5, 22.0 ],
													"text" : "sel 0 1 2"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-23",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 705.0, 174.0, 31.0, 22.0 ],
													"text" : "hide"
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-24",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 24.0, 21.0, 30.0, 30.0 ]
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-25",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 24.0, 268.0, 30.0, 30.0 ]
												}

											}
 ],
										"lines" : [ 											{
												"patchline" : 												{
													"destination" : [ "obj-10", 0 ],
													"source" : [ "obj-1", 1 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-21", 0 ],
													"source" : [ "obj-1", 2 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-1", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-7", 0 ],
													"source" : [ "obj-10", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-7", 0 ],
													"source" : [ "obj-11", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-5", 0 ],
													"source" : [ "obj-12", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-11", 0 ],
													"source" : [ "obj-2", 1 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-12", 0 ],
													"source" : [ "obj-2", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-21", 0 ],
													"source" : [ "obj-2", 2 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-25", 0 ],
													"source" : [ "obj-20", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-20", 0 ],
													"source" : [ "obj-21", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-22", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-2", 0 ],
													"source" : [ "obj-22", 1 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-23", 0 ],
													"source" : [ "obj-22", 2 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-20", 0 ],
													"source" : [ "obj-23", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-22", 0 ],
													"source" : [ "obj-24", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-25", 0 ],
													"source" : [ "obj-5", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-25", 0 ],
													"source" : [ "obj-7", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-5", 0 ],
													"source" : [ "obj-9", 0 ]
												}

											}
 ]
									}
,
									"patching_rect" : [ 530.0, 234.0, 79.0, 22.0 ],
									"saved_object_attributes" : 									{
										"description" : "",
										"digest" : "",
										"globalpatchername" : "",
										"tags" : ""
									}
,
									"text" : "p viewLength"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-7",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 365.0, 234.0, 105.0, 22.0 ],
									"text" : "script $1 tabAudio"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-9",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"patching_rect" : [ 365.0, 121.0, 33.0, 22.0 ],
									"text" : "== 2"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-14",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 401.0, 194.0, 37.0, 22.0 ],
									"text" : "show"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-17",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 3,
									"outlettype" : [ "bang", "bang", "" ],
									"patching_rect" : [ 365.0, 158.0, 91.0, 22.0 ],
									"text" : "sel 0 1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-19",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 365.0, 194.0, 31.0, 22.0 ],
									"text" : "hide"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-6",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 35.0, 287.0, 29.0, 22.0 ],
									"text" : "thru"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-1",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 200.0, 234.0, 143.0, 22.0 ],
									"text" : "script $1 tabPerformance"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-2",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"patching_rect" : [ 200.0, 121.0, 33.0, 22.0 ],
									"text" : "== 1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-3",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 236.0, 194.0, 37.0, 22.0 ],
									"text" : "show"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-4",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 3,
									"outlettype" : [ "bang", "bang", "" ],
									"patching_rect" : [ 200.0, 158.0, 91.0, 22.0 ],
									"text" : "sel 0 1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-5",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 200.0, 194.0, 31.0, 22.0 ],
									"text" : "hide"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-15",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 35.0, 234.0, 105.0, 22.0 ],
									"text" : "script $1 tabSetup"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-13",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"patching_rect" : [ 35.0, 121.0, 33.0, 22.0 ],
									"text" : "== 0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-12",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 71.0, 194.0, 37.0, 22.0 ],
									"text" : "show"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-11",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 3,
									"outlettype" : [ "bang", "bang", "" ],
									"patching_rect" : [ 35.0, 158.0, 91.0, 22.0 ],
									"text" : "sel 0 1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-10",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 35.0, 194.0, 31.0, 22.0 ],
									"text" : "hide"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-8",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 4,
									"outlettype" : [ "int", "int", "int", "int" ],
									"patching_rect" : [ 35.0, 83.0, 514.0, 22.0 ],
									"text" : "t i i i i"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-16",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"patching_rect" : [ 35.0, 23.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-18",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 35.0, 331.0, 30.0, 30.0 ]
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-15", 0 ],
									"source" : [ "obj-10", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-10", 0 ],
									"source" : [ "obj-11", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-11", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-15", 0 ],
									"source" : [ "obj-12", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-11", 0 ],
									"source" : [ "obj-13", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-7", 0 ],
									"source" : [ "obj-14", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-15", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-8", 0 ],
									"source" : [ "obj-16", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-17", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-19", 0 ],
									"source" : [ "obj-17", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-7", 0 ],
									"source" : [ "obj-19", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-4", 0 ],
									"source" : [ "obj-2", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-26", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-3", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-4", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-5", 0 ],
									"source" : [ "obj-4", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-5", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-18", 0 ],
									"source" : [ "obj-6", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-7", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-13", 0 ],
									"source" : [ "obj-8", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-8", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-26", 0 ],
									"source" : [ "obj-8", 3 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-9", 0 ],
									"source" : [ "obj-8", 2 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-17", 0 ],
									"source" : [ "obj-9", 0 ]
								}

							}
 ]
					}
,
					"patching_rect" : [ 58.0, 88.0, 71.0, 22.0 ],
					"saved_object_attributes" : 					{
						"description" : "",
						"digest" : "",
						"globalpatchername" : "",
						"tags" : ""
					}
,
					"text" : "p showHide"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-6",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"patching_rect" : [ 58.0, 123.0, 67.0, 22.0 ],
					"save" : [ "#N", "thispatcher", ";", "#Q", "end", ";" ],
					"text" : "thispatcher"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-5",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"patching_rect" : [ 1302.0, 636.0, 29.0, 22.0 ],
					"text" : "thru"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-4",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "int", "int" ],
					"patching_rect" : [ 843.375, 100.0, 478.625, 22.0 ],
					"text" : "t i i"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-40",
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
						"rect" : [ 59.0, 107.0, 334.0, 297.0 ],
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
									"id" : "obj-13",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "float", "bang" ],
									"patching_rect" : [ 39.0, 115.0, 125.0, 22.0 ],
									"text" : "t f b"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-45",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 178.0, 152.0, 138.0, 20.0 ],
									"text" : "new values each ~25ms"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-43",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 145.0, 151.0, 29.5, 22.0 ],
									"text" : "25"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-69",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 39.0, 81.0, 47.0, 22.0 ],
									"text" : "* 1000."
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-66",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 39.0, 190.0, 125.0, 22.0 ],
									"text" : "expr ceil($f1 / $f2) + 1"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-25",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 39.0, 22.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-35",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 39.0, 235.0, 30.0, 30.0 ]
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-13", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-66", 0 ],
									"source" : [ "obj-13", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-69", 0 ],
									"source" : [ "obj-25", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-66", 1 ],
									"source" : [ "obj-43", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-35", 0 ],
									"source" : [ "obj-66", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-13", 0 ],
									"source" : [ "obj-69", 0 ]
								}

							}
 ]
					}
,
					"patching_rect" : [ 843.375, 64.0, 75.0, 22.0 ],
					"saved_object_attributes" : 					{
						"description" : "",
						"digest" : "",
						"globalpatchername" : "",
						"tags" : ""
					}
,
					"text" : "p viewlength"
				}

			}
, 			{
				"box" : 				{
					"bgmode" : 0,
					"border" : 0,
					"clickthrough" : 0,
					"enablehscroll" : 0,
					"enablevscroll" : 0,
					"hidden" : 1,
					"id" : "obj-2",
					"lockeddragscroll" : 0,
					"lockedsize" : 0,
					"maxclass" : "bpatcher",
					"name" : "tabPerformance.maxpat",
					"numinlets" : 3,
					"numoutlets" : 5,
					"offset" : [ 0.0, 0.0 ],
					"outlettype" : [ "", "", "", "", "" ],
					"patching_rect" : [ 421.0, 139.0, 863.75, 519.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 14.0, 52.0, 861.0, 518.0 ],
					"varname" : "tabPerformance",
					"viewvisibility" : 1
				}

			}
, 			{
				"box" : 				{
					"bgmode" : 0,
					"border" : 0,
					"clickthrough" : 0,
					"enablehscroll" : 0,
					"enablevscroll" : 0,
					"id" : "obj-1",
					"lockeddragscroll" : 0,
					"lockedsize" : 0,
					"maxclass" : "bpatcher",
					"name" : "tabSetup.maxpat",
					"numinlets" : 5,
					"numoutlets" : 5,
					"offset" : [ 0.0, 0.0 ],
					"outlettype" : [ "", "", "", "", "" ],
					"patching_rect" : [ 210.0, 688.0, 863.0, 518.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 14.0, 52.0, 861.0, 518.0 ],
					"varname" : "tabSetup",
					"viewvisibility" : 1
				}

			}
, 			{
				"box" : 				{
					"contrastactivetab" : 0,
					"fontsize" : 18.0,
					"htabcolor" : [ 1.0, 0.694117647058824, 0.0, 1.0 ],
					"id" : "obj-3",
					"maxclass" : "tab",
					"multiline" : 0,
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "int", "", "" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 58.0, 33.0, 505.0, 28.5 ],
					"presentation" : 1,
					"presentation_rect" : [ 0.0, 0.0, 862.0, 38.0 ],
					"saved_attribute_attributes" : 					{
						"tabcolor" : 						{
							"expression" : "themecolor.live_control_bg"
						}
,
						"valueof" : 						{
							"parameter_enum" : [ "🖥  Setup", "🎯  Performance", "🎵  Audio" ],
							"parameter_initial" : [ 0.0 ],
							"parameter_initial_enable" : 1,
							"parameter_longname" : "live.tab[1]",
							"parameter_mmax" : 2,
							"parameter_modmode" : 0,
							"parameter_shortname" : "live.tab[1]",
							"parameter_type" : 2
						}

					}
,
					"spacing_y" : 0.0,
					"tabcolor" : [ 0.647058823529412, 0.647058823529412, 0.647058823529412, 1.0 ],
					"tabs" : [ "🖥  Setup", "🎯  Performance", "🎵  Audio" ],
					"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
					"valign" : 2,
					"varname" : "live.tab"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-25",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 233.0, 1244.0, 29.0, 22.0 ],
					"text" : "thru"
				}

			}
, 			{
				"box" : 				{
					"color" : [ 0.427450980392157, 0.843137254901961, 1.0, 1.0 ],
					"id" : "obj-151",
					"maxclass" : "newobj",
					"numinlets" : 2,
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
						"rect" : [ 149.0, 140.0, 1641.0, 729.0 ],
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
									"id" : "obj-26",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1064.0, 357.0, 100.0, 22.0 ],
									"text" : "r sensorsMinMax"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-59",
									"index" : 2,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 914.0, 12.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-58",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 473.0, 595.0, 55.0, 22.0 ],
									"text" : "del 1000"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-56",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 330.0, 595.0, 29.0, 22.0 ],
									"text" : "thru"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-54",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 368.0, 595.0, 77.0, 22.0 ],
									"text" : "route symbol"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-53",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 368.0, 637.0, 93.0, 22.0 ],
									"text" : "join @triggers 1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-47",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "dump" ],
									"patching_rect" : [ 473.0, 637.0, 45.0, 22.0 ],
									"text" : "t dump"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-43",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "bang", "" ],
									"patching_rect" : [ 473.0, 563.0, 54.0, 22.0 ],
									"text" : "sel open"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-41",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 473.0, 529.0, 82.0, 22.0 ],
									"text" : "route /tdOpen"
								}

							}
, 							{
								"box" : 								{
									"color" : [ 0.909803921568627, 0.423529411764706, 1.0, 1.0 ],
									"id" : "obj-40",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 473.0, 496.0, 97.0, 22.0 ],
									"text" : "udpreceive 4445"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-39",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 330.0, 529.0, 83.0, 22.0 ],
									"text" : "prepend store"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-30",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 4,
									"outlettype" : [ "", "", "", "" ],
									"patching_rect" : [ 330.0, 563.0, 132.999999999999943, 22.0 ],
									"saved_object_attributes" : 									{
										"embed" : 0,
										"precision" : 6
									}
,
									"text" : "coll"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-48",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"patching_rect" : [ 914.0, 391.0, 29.5, 22.0 ],
									"text" : "+ 1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-45",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 914.0, 443.0, 131.0, 22.0 ],
									"text" : "prepend /num_sensors"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-24",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 279.0, 443.0, 29.0, 22.0 ],
									"text" : "thru"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-23",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 497.0, 391.0, 122.0, 22.0 ],
									"text" : "prepend /emg_dev_1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-22",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 765.0, 272.0, 118.0, 22.0 ],
									"text" : "prepend /emg_val_1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-21",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "float", "float" ],
									"patching_rect" : [ 364.0, 357.0, 152.0, 22.0 ],
									"text" : "unpack f f"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-20",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "float", "float" ],
									"patching_rect" : [ 632.0, 242.0, 152.0, 22.0 ],
									"text" : "unpack f f"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-19",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 279.0, 320.0, 29.0, 22.0 ],
									"text" : "thru"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-18",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 487.0, 272.0, 128.0, 22.0 ],
									"text" : "prepend /angle_dev_1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-17",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "float", "float" ],
									"patching_rect" : [ 354.0, 242.0, 152.0, 22.0 ],
									"text" : "unpack f f"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-16",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 688.0, 115.0, 129.0, 22.0 ],
									"text" : "prepend /angle_deg_1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-15",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "float", "float" ],
									"patching_rect" : [ 555.0, 86.0, 152.0, 22.0 ],
									"text" : "unpack f f"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-14",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 279.0, 169.0, 29.0, 22.0 ],
									"text" : "thru"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-13",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 412.0, 115.0, 127.0, 22.0 ],
									"text" : "prepend /foot_cycle_1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-12",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "float", "float" ],
									"patching_rect" : [ 279.0, 86.0, 152.0, 22.0 ],
									"text" : "unpack f f"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-10",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1481.0, 443.0, 138.0, 22.0 ],
									"text" : "prepend /sensor_1_max"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-11",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1342.0, 443.0, 135.0, 22.0 ],
									"text" : "prepend /sensor_1_min"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-9",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1203.0, 443.0, 138.0, 22.0 ],
									"text" : "prepend /sensor_0_max"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-8",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1064.0, 443.0, 135.0, 22.0 ],
									"text" : "prepend /sensor_0_min"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-7",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 4,
									"outlettype" : [ "float", "float", "float", "float" ],
									"patching_rect" : [ 1064.0, 409.0, 436.0, 22.0 ],
									"text" : "unpack f f f f"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-6",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 24.0, 443.0, 125.0, 22.0 ],
									"text" : "prepend /sensor_type"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-5",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 24.0, 12.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-2",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 364.0, 391.0, 122.0, 22.0 ],
									"text" : "prepend /emg_dev_0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-3",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 632.0, 272.0, 118.0, 22.0 ],
									"text" : "prepend /emg_val_0"
								}

							}
, 							{
								"box" : 								{
									"color" : [ 1.0, 0.596078431372549, 0.658823529411765, 1.0 ],
									"id" : "obj-107",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 632.0, 202.0, 61.0, 22.0 ],
									"text" : "r emg_val"
								}

							}
, 							{
								"box" : 								{
									"color" : [ 1.0, 0.423529411764706, 0.513725490196078, 1.0 ],
									"id" : "obj-116",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 364.0, 325.0, 65.0, 22.0 ],
									"text" : "r emg_dev"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-1",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 279.0, 496.0, 70.0, 22.0 ],
									"text" : "t l l"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-149",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 354.0, 272.0, 128.0, 22.0 ],
									"text" : "prepend /angle_dev_0"
								}

							}
, 							{
								"box" : 								{
									"color" : [ 1.0, 0.694117647058824, 0.0, 1.0 ],
									"id" : "obj-148",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 354.0, 202.0, 71.0, 22.0 ],
									"text" : "r angle_dev"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-102",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 555.0, 115.0, 129.0, 22.0 ],
									"text" : "prepend /angle_deg_0"
								}

							}
, 							{
								"box" : 								{
									"color" : [ 1.0, 0.784313725490196, 0.301960784313725, 1.0 ],
									"id" : "obj-84",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 555.0, 52.0, 72.0, 22.0 ],
									"text" : "r angle_deg"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-72",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 157.0, 443.0, 108.0, 22.0 ],
									"text" : "prepend /step_min"
								}

							}
, 							{
								"box" : 								{
									"color" : [ 0.72156862745098, 0.545098039215686, 0.403921568627451, 1.0 ],
									"id" : "obj-70",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 157.0, 409.0, 65.0, 22.0 ],
									"text" : "r step_min"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-64",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 279.0, 115.0, 127.0, 22.0 ],
									"text" : "prepend /foot_cycle_0"
								}

							}
, 							{
								"box" : 								{
									"color" : [ 0.572549019607843, 0.854901960784314, 0.0, 1.0 ],
									"id" : "obj-51",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 279.0, 52.0, 76.0, 22.0 ],
									"text" : "r foot_cycles"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-150",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 279.0, 680.0, 30.0, 30.0 ]
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-150", 0 ],
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-39", 0 ],
									"source" : [ "obj-1", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-10", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-102", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-20", 0 ],
									"source" : [ "obj-107", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-11", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 0 ],
									"source" : [ "obj-116", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-13", 0 ],
									"source" : [ "obj-12", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-64", 0 ],
									"source" : [ "obj-12", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-13", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-19", 0 ],
									"source" : [ "obj-14", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-17", 0 ],
									"source" : [ "obj-148", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-19", 0 ],
									"source" : [ "obj-149", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-102", 0 ],
									"source" : [ "obj-15", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-16", 0 ],
									"source" : [ "obj-15", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-16", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-149", 0 ],
									"source" : [ "obj-17", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-18", 0 ],
									"source" : [ "obj-17", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-19", 0 ],
									"source" : [ "obj-18", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-24", 0 ],
									"source" : [ "obj-19", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-24", 0 ],
									"source" : [ "obj-2", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-22", 0 ],
									"source" : [ "obj-20", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-20", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-21", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"source" : [ "obj-21", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-19", 0 ],
									"source" : [ "obj-22", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-24", 0 ],
									"source" : [ "obj-23", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-24", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-7", 0 ],
									"source" : [ "obj-26", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-19", 0 ],
									"source" : [ "obj-3", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-54", 0 ],
									"source" : [ "obj-30", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-56", 0 ],
									"source" : [ "obj-30", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-30", 0 ],
									"source" : [ "obj-39", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-41", 0 ],
									"source" : [ "obj-40", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-41", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-58", 0 ],
									"source" : [ "obj-43", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-45", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-30", 0 ],
									"source" : [ "obj-47", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-45", 0 ],
									"source" : [ "obj-48", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-5", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-51", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-150", 0 ],
									"source" : [ "obj-53", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-53", 0 ],
									"source" : [ "obj-54", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-53", 1 ],
									"source" : [ "obj-56", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-47", 0 ],
									"source" : [ "obj-58", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-48", 0 ],
									"source" : [ "obj-59", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-6", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-64", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-10", 0 ],
									"source" : [ "obj-7", 3 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-11", 0 ],
									"source" : [ "obj-7", 2 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-8", 0 ],
									"source" : [ "obj-7", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-9", 0 ],
									"source" : [ "obj-7", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-72", 0 ],
									"source" : [ "obj-70", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-72", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-8", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-15", 0 ],
									"source" : [ "obj-84", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-9", 0 ]
								}

							}
 ]
					}
,
					"patching_rect" : [ 210.0, 1600.0, 42.0, 22.0 ],
					"saved_object_attributes" : 					{
						"description" : "",
						"digest" : "",
						"globalpatchername" : "",
						"tags" : ""
					}
,
					"text" : "p data"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-47",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 220.0, 1672.0, 117.0, 20.0 ],
					"text" : "TOUCH DESIGNER"
				}

			}
, 			{
				"box" : 				{
					"color" : [ 0.811764705882353, 0.266666666666667, 0.368627450980392, 1.0 ],
					"id" : "obj-45",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 210.0, 1648.0, 138.0, 22.0 ],
					"text" : "udpsend 127.0.0.1 4444"
				}

			}
, 			{
				"box" : 				{
					"angle" : 270.0,
					"bgcolor" : [ 0.2, 0.2, 0.2, 0.0 ],
					"border" : 2,
					"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
					"id" : "obj-11",
					"maxclass" : "panel",
					"mode" : 0,
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 58.0, 290.0, 128.0, 128.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 0.0, 40.0, 889.0, 542.0 ],
					"proportion" : 0.5
				}

			}
 ],
		"lines" : [ 			{
				"patchline" : 				{
					"destination" : [ "obj-151", 0 ],
					"order" : 0,
					"source" : [ "obj-1", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-2", 2 ],
					"order" : 0,
					"source" : [ "obj-1", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-2", 0 ],
					"order" : 3,
					"source" : [ "obj-1", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-25", 0 ],
					"source" : [ "obj-1", 2 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-33", 3 ],
					"source" : [ "obj-1", 4 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-33", 0 ],
					"source" : [ "obj-1", 3 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-33", 2 ],
					"order" : 1,
					"source" : [ "obj-1", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-33", 1 ],
					"order" : 1,
					"source" : [ "obj-1", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-8", 0 ],
					"order" : 2,
					"source" : [ "obj-1", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-45", 0 ],
					"source" : [ "obj-151", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-1", 0 ],
					"source" : [ "obj-2", 3 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-1", 3 ],
					"source" : [ "obj-2", 2 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-1", 2 ],
					"source" : [ "obj-2", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-1", 1 ],
					"source" : [ "obj-2", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-8", 1 ],
					"source" : [ "obj-2", 4 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-6", 0 ],
					"source" : [ "obj-20", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-151", 1 ],
					"source" : [ "obj-25", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-20", 0 ],
					"source" : [ "obj-3", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-40", 0 ],
					"source" : [ "obj-36", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-2", 1 ],
					"source" : [ "obj-4", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-5", 0 ],
					"source" : [ "obj-4", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-4", 0 ],
					"source" : [ "obj-40", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-1", 4 ],
					"source" : [ "obj-5", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-1", 0 ],
					"source" : [ "obj-8", 0 ]
				}

			}
 ],
		"parameters" : 		{
			"obj-1::obj-167::obj-21" : [ "live.numbox[81]", "live.numbox[2]", 0 ],
			"obj-1::obj-167::obj-22" : [ "live.numbox[85]", "live.numbox[2]", 0 ],
			"obj-1::obj-167::obj-29" : [ "live.numbox[82]", "live.menu", 0 ],
			"obj-1::obj-167::obj-36" : [ "live.numbox[83]", "live.numbox[2]", 0 ],
			"obj-1::obj-167::obj-40" : [ "live.numbox[2]", "live.menu", 0 ],
			"obj-1::obj-230" : [ "live.text[29]", "live.text[14]", 0 ],
			"obj-1::obj-30" : [ "live.text[25]", "live.text[14]", 0 ],
			"obj-1::obj-34" : [ "live.toggle", "live.text[2]", 0 ],
			"obj-1::obj-39" : [ "live.numbox[59]", "live.numbox[92]", 0 ],
			"obj-1::obj-47" : [ "live.toggle[1]", "live.text[2]", 0 ],
			"obj-1::obj-49" : [ "live.text[8]", "live.menu[1]", 3 ],
			"obj-1::obj-67" : [ "live.menu[10]", "live.menu", 0 ],
			"obj-1::obj-68" : [ "live.text[11]", "live.text", 0 ],
			"obj-1::obj-7" : [ "live.menu[11]", "live.menu", 0 ],
			"obj-1::obj-72" : [ "live.text[9]", "live.text", 0 ],
			"obj-1::obj-73" : [ "live.text[7]", "live.text[3]", 0 ],
			"obj-1::obj-85::obj-24" : [ "live.menu[12]", "live.menu[12]", 0 ],
			"obj-1::obj-85::obj-41" : [ "live.menu[13]", "live.menu[12]", 0 ],
			"obj-1::obj-85::obj-48" : [ "live.menu[15]", "live.menu[12]", 0 ],
			"obj-1::obj-87" : [ "live.text[54]", "live.text[1]", 0 ],
			"obj-1::obj-88" : [ "live.text[53]", "live.text[11]", 0 ],
			"obj-1::obj-89::obj-119::obj-10" : [ "live.menu[2]", "live.menu", 0 ],
			"obj-1::obj-89::obj-119::obj-16" : [ "live.menu[3]", "live.menu", 0 ],
			"obj-1::obj-89::obj-119::obj-20" : [ "live.text", "live.text", 0 ],
			"obj-1::obj-89::obj-119::obj-33" : [ "live.menu[4]", "live.menu", 0 ],
			"obj-1::obj-89::obj-119::obj-34" : [ "live.menu[5]", "live.menu", 0 ],
			"obj-1::obj-89::obj-119::obj-35" : [ "live.menu[6]", "live.menu", 0 ],
			"obj-1::obj-89::obj-119::obj-46" : [ "live.text[2]", "live.text[1]", 0 ],
			"obj-1::obj-89::obj-119::obj-49" : [ "live.text[1]", "live.text[1]", 0 ],
			"obj-1::obj-89::obj-119::obj-50" : [ "live.text[3]", "live.text[1]", 0 ],
			"obj-1::obj-89::obj-119::obj-53" : [ "live.text[4]", "live.text[1]", 0 ],
			"obj-1::obj-89::obj-119::obj-54" : [ "live.text[5]", "live.text[1]", 0 ],
			"obj-1::obj-89::obj-119::obj-55" : [ "live.text[6]", "live.text[1]", 0 ],
			"obj-1::obj-89::obj-119::obj-8" : [ "live.menu", "live.menu", 0 ],
			"obj-1::obj-89::obj-119::obj-9" : [ "live.menu[1]", "live.menu", 0 ],
			"obj-1::obj-90" : [ "live.text[12]", "live.text[1]", 0 ],
			"obj-2::obj-177::obj-115" : [ "live.numbox[131]", "live.numbox", 0 ],
			"obj-2::obj-177::obj-120" : [ "live.numbox[127]", "live.numbox", 0 ],
			"obj-2::obj-177::obj-121" : [ "live.text[45]", "live.menu[1]", 0 ],
			"obj-2::obj-177::obj-126::obj-102::obj-101" : [ "live.numbox[89]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-102" : [ "live.numbox[4]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-106" : [ "live.numbox[99]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-108" : [ "live.numbox[106]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-109" : [ "live.numbox[79]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-110" : [ "live.numbox[73]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-111" : [ "live.numbox[71]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-112" : [ "live.numbox[110]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-114" : [ "live.numbox[117]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-115" : [ "live.numbox[96]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-116" : [ "live.numbox[100]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-125" : [ "live.numbox[121]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-128" : [ "live.numbox[111]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-129" : [ "live.numbox[78]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-130" : [ "live.numbox[76]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-131" : [ "live.numbox[103]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-132" : [ "live.numbox[94]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-133" : [ "live.numbox[74]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-134" : [ "live.numbox[115]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-135" : [ "live.numbox[63]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-14" : [ "live.numbox[97]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-145" : [ "live.numbox[107]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-147" : [ "live.numbox[118]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-149" : [ "live.numbox[101]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-151" : [ "live.numbox[122]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-162" : [ "live.text[38]", "live.text", 0 ],
			"obj-2::obj-177::obj-126::obj-102::obj-20" : [ "live.numbox[114]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-25" : [ "live.numbox[95]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-29" : [ "live.numbox[90]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-290" : [ "live.numbox[50]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-312" : [ "live.text[14]", "live.text", 0 ],
			"obj-2::obj-177::obj-126::obj-102::obj-318" : [ "live.text[13]", "live.text", 0 ],
			"obj-2::obj-177::obj-126::obj-102::obj-319" : [ "live.numbox[51]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-320" : [ "live.numbox[52]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-321" : [ "live.numbox[53]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-322" : [ "live.numbox[54]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-326" : [ "live.numbox[55]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-327" : [ "live.numbox[56]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-328" : [ "live.numbox[57]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-329" : [ "live.numbox[58]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-331" : [ "live.numbox[3]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-332" : [ "live.numbox[60]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-333" : [ "live.numbox[61]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-334" : [ "live.numbox[62]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-336" : [ "live.numbox[68]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-337" : [ "live.numbox[64]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-338" : [ "live.numbox[65]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-38" : [ "live.numbox[109]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-39" : [ "live.numbox[102]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-40" : [ "live.numbox[70]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-41" : [ "live.numbox[120]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-42" : [ "live.numbox[119]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-43" : [ "live.numbox[67]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-44" : [ "live.numbox[77]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-45" : [ "live.numbox[116]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-51" : [ "live.numbox[5]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-52" : [ "live.numbox[88]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-54" : [ "live.numbox[108]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-55" : [ "live.numbox[75]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-56" : [ "live.numbox[105]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-57" : [ "live.numbox[66]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-58" : [ "live.numbox[113]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-59" : [ "live.numbox[104]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-60" : [ "live.numbox[112]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-61" : [ "live.numbox[86]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-62" : [ "live.numbox[72]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-64" : [ "live.numbox[98]", "live.numbox", 1 ],
			"obj-2::obj-177::obj-126::obj-102::obj-68" : [ "live.text[37]", "live.text", 0 ],
			"obj-2::obj-177::obj-12::obj-105" : [ "live.numbox[125]", "live.numbox", 0 ],
			"obj-2::obj-177::obj-12::obj-106" : [ "live.numbox[124]", "live.numbox", 0 ],
			"obj-2::obj-177::obj-12::obj-158" : [ "live.text[24]", "live.menu[1]", 0 ],
			"obj-2::obj-177::obj-12::obj-2" : [ "live.text[41]", "live.text[12]", 0 ],
			"obj-2::obj-177::obj-12::obj-3" : [ "live.text[42]", "live.text[12]", 0 ],
			"obj-2::obj-177::obj-141::obj-105" : [ "live.numbox[123]", "live.numbox", 0 ],
			"obj-2::obj-177::obj-141::obj-106" : [ "live.numbox[91]", "live.numbox", 0 ],
			"obj-2::obj-177::obj-141::obj-158" : [ "live.text[23]", "live.menu[1]", 0 ],
			"obj-2::obj-177::obj-141::obj-2" : [ "live.text[40]", "live.text[12]", 0 ],
			"obj-2::obj-177::obj-141::obj-3" : [ "live.text[39]", "live.text[12]", 0 ],
			"obj-2::obj-177::obj-25" : [ "live.numbox[126]", "live.numbox", 0 ],
			"obj-2::obj-177::obj-30" : [ "live.text[43]", "live.text[1]", 0 ],
			"obj-2::obj-177::obj-7" : [ "live.numbox[129]", "live.numbox", 0 ],
			"obj-2::obj-177::obj-74" : [ "live.numbox[128]", "live.numbox", 0 ],
			"obj-2::obj-177::obj-8" : [ "live.numbox[130]", "live.numbox", 0 ],
			"obj-2::obj-177::obj-96" : [ "live.text[44]", "live.text[6]", 0 ],
			"obj-3" : [ "live.tab[1]", "live.tab[1]", 0 ],
			"obj-33::obj-30" : [ "live.text[56]", "live.text[14]", 0 ],
			"obj-36" : [ "live.numbox[136]", "live.numbox[60]", 0 ],
			"obj-8::obj-10::obj-30" : [ "live.text[51]", "live.text[14]", 0 ],
			"obj-8::obj-119::obj-97" : [ "live.text[50]", "live.text[3]", 0 ],
			"obj-8::obj-135" : [ "live.text[52]", "live.text[1]", 0 ],
			"obj-8::obj-147::obj-10" : [ "live.tab", "live.tab", 0 ],
			"obj-8::obj-147::obj-111" : [ "live.numbox[132]", "Gain", 0 ],
			"obj-8::obj-147::obj-112" : [ "live.numbox[25]", "live.numbox[57]", 0 ],
			"obj-8::obj-147::obj-115" : [ "live.numbox[135]", "Freq", 0 ],
			"obj-8::obj-147::obj-116" : [ "live.numbox[133]", "Freq", 0 ],
			"obj-8::obj-147::obj-137" : [ "live.menu[8]", "live.menu", 0 ],
			"obj-8::obj-147::obj-14" : [ "live.numbox[1]", "Freq", 0 ],
			"obj-8::obj-147::obj-144" : [ "live.text[46]", "live.text", 0 ],
			"obj-8::obj-147::obj-148" : [ "live.numbox[6]", "Freq", 0 ],
			"obj-8::obj-147::obj-149" : [ "live.numbox[7]", "Freq", 0 ],
			"obj-8::obj-147::obj-15" : [ "live.numbox", "Freq", 0 ],
			"obj-8::obj-147::obj-152" : [ "live.menu[16]", "live.menu[5]", 0 ],
			"obj-8::obj-147::obj-163" : [ "live.numbox[19]", "live.numbox[57]", 0 ],
			"obj-8::obj-147::obj-165" : [ "live.numbox[20]", "live.numbox[57]", 0 ],
			"obj-8::obj-147::obj-168" : [ "live.numbox[21]", "live.numbox[57]", 0 ],
			"obj-8::obj-147::obj-172" : [ "live.numbox[22]", "live.numbox[57]", 0 ],
			"obj-8::obj-147::obj-178" : [ "live.numbox[9]", "Freq", 0 ],
			"obj-8::obj-147::obj-179" : [ "live.numbox[10]", "Freq", 0 ],
			"obj-8::obj-147::obj-196" : [ "live.numbox[23]", "live.numbox[57]", 0 ],
			"obj-8::obj-147::obj-2" : [ "live.text[47]", "live.text[4]", 0 ],
			"obj-8::obj-147::obj-205" : [ "live.numbox[24]", "live.numbox[57]", 0 ],
			"obj-8::obj-147::obj-206" : [ "live.text[48]", "live.text", 0 ],
			"obj-8::obj-147::obj-216" : [ "live.text[49]", "live.text", 0 ],
			"obj-8::obj-147::obj-48" : [ "live.numbox[12]", "Freq", 0 ],
			"obj-8::obj-147::obj-49" : [ "live.numbox[13]", "Freq", 0 ],
			"obj-8::obj-147::obj-52" : [ "live.gain~", "live.gain~", 0 ],
			"obj-8::obj-147::obj-54" : [ "live.numbox[134]", "live.numbox[57]", 0 ],
			"obj-8::obj-147::obj-55::obj-10" : [ "live.dial", "Speed", 0 ],
			"obj-8::obj-147::obj-55::obj-13" : [ "live.dial[6]", "Brightness", 0 ],
			"obj-8::obj-147::obj-55::obj-14" : [ "live.dial[4]", "Harmonicity", 0 ],
			"obj-8::obj-147::obj-55::obj-16" : [ "live.dial[5]", "Sync", 0 ],
			"obj-8::obj-147::obj-55::obj-28" : [ "live.dial[1]", "Glissando", 0 ],
			"obj-8::obj-147::obj-55::obj-4" : [ "live.menu[7]", "live.menu", 0 ],
			"obj-8::obj-147::obj-55::obj-5" : [ "live.dial[2]", "Time", 0 ],
			"obj-8::obj-147::obj-7" : [ "live.numbox[18]", "live.numbox[57]", 0 ],
			"obj-8::obj-147::obj-75" : [ "live.text[15]", "live.text", 0 ],
			"obj-8::obj-147::obj-85" : [ "live.numbox[16]", "Freq", 0 ],
			"obj-8::obj-147::obj-86" : [ "live.numbox[17]", "Freq", 0 ],
			"obj-8::obj-215" : [ "live.text[55]", "live.text[1]", 0 ],
			"parameterbanks" : 			{
				"0" : 				{
					"index" : 0,
					"name" : "",
					"parameters" : [ "-", "-", "-", "-", "-", "-", "-", "-" ]
				}

			}
,
			"parameter_overrides" : 			{
				"obj-1::obj-68" : 				{
					"parameter_longname" : "live.text[11]"
				}
,
				"obj-1::obj-72" : 				{
					"parameter_longname" : "live.text[9]"
				}
,
				"obj-1::obj-73" : 				{
					"parameter_longname" : "live.text[7]"
				}
,
				"obj-1::obj-89::obj-119::obj-10" : 				{
					"parameter_invisible" : 0,
					"parameter_modmode" : 0,
					"parameter_range" : [ "*", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024", "2025" ],
					"parameter_type" : 2,
					"parameter_unitstyle" : 10
				}
,
				"obj-1::obj-89::obj-119::obj-33" : 				{
					"parameter_invisible" : 0,
					"parameter_modmode" : 0,
					"parameter_range" : [ "2023", "2024", "2025" ],
					"parameter_type" : 2,
					"parameter_unitstyle" : 10
				}
,
				"obj-2::obj-177::obj-115" : 				{
					"parameter_longname" : "live.numbox[131]",
					"parameter_range" : [ -180.0, 180.0 ],
					"parameter_units" : "%d°"
				}
,
				"obj-2::obj-177::obj-120" : 				{
					"parameter_longname" : "live.numbox[127]",
					"parameter_range" : [ 0.0, 180.0 ],
					"parameter_units" : "%d°"
				}
,
				"obj-2::obj-177::obj-121" : 				{
					"parameter_longname" : "live.text[45]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-101" : 				{
					"parameter_longname" : "live.numbox[89]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-102" : 				{
					"parameter_longname" : "live.numbox[4]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-106" : 				{
					"parameter_longname" : "live.numbox[99]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-108" : 				{
					"parameter_longname" : "live.numbox[106]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-109" : 				{
					"parameter_longname" : "live.numbox[79]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-110" : 				{
					"parameter_longname" : "live.numbox[73]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-111" : 				{
					"parameter_longname" : "live.numbox[71]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-112" : 				{
					"parameter_longname" : "live.numbox[110]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-114" : 				{
					"parameter_longname" : "live.numbox[117]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-115" : 				{
					"parameter_longname" : "live.numbox[96]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-116" : 				{
					"parameter_longname" : "live.numbox[100]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-125" : 				{
					"parameter_longname" : "live.numbox[121]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-128" : 				{
					"parameter_longname" : "live.numbox[111]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-129" : 				{
					"parameter_longname" : "live.numbox[78]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-130" : 				{
					"parameter_longname" : "live.numbox[76]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-131" : 				{
					"parameter_longname" : "live.numbox[103]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-132" : 				{
					"parameter_longname" : "live.numbox[94]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-133" : 				{
					"parameter_longname" : "live.numbox[74]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-134" : 				{
					"parameter_longname" : "live.numbox[115]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-135" : 				{
					"parameter_longname" : "live.numbox[63]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-14" : 				{
					"parameter_longname" : "live.numbox[97]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-145" : 				{
					"parameter_longname" : "live.numbox[107]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-147" : 				{
					"parameter_longname" : "live.numbox[118]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-149" : 				{
					"parameter_longname" : "live.numbox[101]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-151" : 				{
					"parameter_longname" : "live.numbox[122]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-162" : 				{
					"parameter_longname" : "live.text[38]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-20" : 				{
					"parameter_longname" : "live.numbox[114]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-25" : 				{
					"parameter_longname" : "live.numbox[95]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-29" : 				{
					"parameter_longname" : "live.numbox[90]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-312" : 				{
					"parameter_longname" : "live.text[14]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-318" : 				{
					"parameter_longname" : "live.text[13]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-331" : 				{
					"parameter_longname" : "live.numbox[3]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-336" : 				{
					"parameter_longname" : "live.numbox[68]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-38" : 				{
					"parameter_longname" : "live.numbox[109]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-39" : 				{
					"parameter_longname" : "live.numbox[102]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-40" : 				{
					"parameter_longname" : "live.numbox[70]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-41" : 				{
					"parameter_longname" : "live.numbox[120]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-42" : 				{
					"parameter_longname" : "live.numbox[119]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-43" : 				{
					"parameter_longname" : "live.numbox[67]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-44" : 				{
					"parameter_longname" : "live.numbox[77]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-45" : 				{
					"parameter_longname" : "live.numbox[116]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-51" : 				{
					"parameter_longname" : "live.numbox[5]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-52" : 				{
					"parameter_longname" : "live.numbox[88]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-54" : 				{
					"parameter_longname" : "live.numbox[108]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-55" : 				{
					"parameter_longname" : "live.numbox[75]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-56" : 				{
					"parameter_longname" : "live.numbox[105]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-57" : 				{
					"parameter_longname" : "live.numbox[66]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-58" : 				{
					"parameter_longname" : "live.numbox[113]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-59" : 				{
					"parameter_longname" : "live.numbox[104]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-60" : 				{
					"parameter_longname" : "live.numbox[112]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-61" : 				{
					"parameter_longname" : "live.numbox[86]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-62" : 				{
					"parameter_longname" : "live.numbox[72]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-64" : 				{
					"parameter_longname" : "live.numbox[98]"
				}
,
				"obj-2::obj-177::obj-126::obj-102::obj-68" : 				{
					"parameter_longname" : "live.text[37]"
				}
,
				"obj-2::obj-177::obj-12::obj-105" : 				{
					"parameter_initial" : 140,
					"parameter_longname" : "live.numbox[125]",
					"parameter_range" : [ -180.0, 180.0 ],
					"parameter_units" : "= %d°"
				}
,
				"obj-2::obj-177::obj-12::obj-106" : 				{
					"parameter_longname" : "live.numbox[124]",
					"parameter_range" : [ -180.0, 180.0 ],
					"parameter_units" : "= %d°"
				}
,
				"obj-2::obj-177::obj-12::obj-158" : 				{
					"parameter_longname" : "live.text[24]"
				}
,
				"obj-2::obj-177::obj-12::obj-2" : 				{
					"parameter_longname" : "live.text[41]"
				}
,
				"obj-2::obj-177::obj-12::obj-3" : 				{
					"parameter_longname" : "live.text[42]"
				}
,
				"obj-2::obj-177::obj-141::obj-105" : 				{
					"parameter_initial" : 140,
					"parameter_longname" : "live.numbox[123]",
					"parameter_range" : [ -180.0, 180.0 ],
					"parameter_units" : "= %d°"
				}
,
				"obj-2::obj-177::obj-141::obj-106" : 				{
					"parameter_longname" : "live.numbox[91]",
					"parameter_range" : [ -180.0, 180.0 ],
					"parameter_units" : "= %d°"
				}
,
				"obj-2::obj-177::obj-141::obj-158" : 				{
					"parameter_longname" : "live.text[23]"
				}
,
				"obj-2::obj-177::obj-141::obj-2" : 				{
					"parameter_longname" : "live.text[40]"
				}
,
				"obj-2::obj-177::obj-141::obj-3" : 				{
					"parameter_longname" : "live.text[39]"
				}
,
				"obj-2::obj-177::obj-25" : 				{
					"parameter_longname" : "live.numbox[126]"
				}
,
				"obj-2::obj-177::obj-30" : 				{
					"parameter_longname" : "live.text[43]"
				}
,
				"obj-2::obj-177::obj-7" : 				{
					"parameter_longname" : "live.numbox[129]",
					"parameter_range" : [ 0.0, 180.0 ],
					"parameter_units" : "%d°"
				}
,
				"obj-2::obj-177::obj-74" : 				{
					"parameter_longname" : "live.numbox[128]"
				}
,
				"obj-2::obj-177::obj-8" : 				{
					"parameter_longname" : "live.numbox[130]",
					"parameter_range" : [ -180.0, 180.0 ],
					"parameter_units" : "%d°"
				}
,
				"obj-2::obj-177::obj-96" : 				{
					"parameter_longname" : "live.text[44]"
				}
,
				"obj-33::obj-30" : 				{
					"parameter_longname" : "live.text[56]"
				}
,
				"obj-8::obj-10::obj-30" : 				{
					"parameter_longname" : "live.text[51]"
				}
,
				"obj-8::obj-119::obj-97" : 				{
					"parameter_longname" : "live.text[50]"
				}
,
				"obj-8::obj-135" : 				{
					"parameter_longname" : "live.text[52]"
				}
,
				"obj-8::obj-147::obj-111" : 				{
					"parameter_longname" : "live.numbox[132]"
				}
,
				"obj-8::obj-147::obj-115" : 				{
					"parameter_longname" : "live.numbox[135]"
				}
,
				"obj-8::obj-147::obj-116" : 				{
					"parameter_longname" : "live.numbox[133]"
				}
,
				"obj-8::obj-147::obj-137" : 				{
					"parameter_longname" : "live.menu[8]"
				}
,
				"obj-8::obj-147::obj-144" : 				{
					"parameter_longname" : "live.text[46]"
				}
,
				"obj-8::obj-147::obj-152" : 				{
					"parameter_longname" : "live.menu[16]"
				}
,
				"obj-8::obj-147::obj-2" : 				{
					"parameter_longname" : "live.text[47]"
				}
,
				"obj-8::obj-147::obj-206" : 				{
					"parameter_longname" : "live.text[48]"
				}
,
				"obj-8::obj-147::obj-216" : 				{
					"parameter_longname" : "live.text[49]"
				}
,
				"obj-8::obj-147::obj-54" : 				{
					"parameter_longname" : "live.numbox[134]"
				}
,
				"obj-8::obj-147::obj-55::obj-4" : 				{
					"parameter_longname" : "live.menu[7]"
				}
,
				"obj-8::obj-147::obj-75" : 				{
					"parameter_longname" : "live.text[15]"
				}
,
				"obj-8::obj-215" : 				{
					"parameter_longname" : "live.text[55]"
				}

			}
,
			"inherited_shortname" : 1
		}
,
		"dependency_cache" : [ 			{
				"name" : "audioDriver.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "crossFade.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "deviation.js",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "TEXT",
				"implicit" : 1
			}
, 			{
				"name" : "fileDate.js",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "TEXT",
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
				"patcherrelativepath" : ".",
				"type" : "TEXT",
				"implicit" : 1
			}
, 			{
				"name" : "grainflow.util.stereopan~.mxe64",
				"type" : "mx64"
			}
, 			{
				"name" : "grainflow~.mxe64",
				"type" : "mx64"
			}
, 			{
				"name" : "guiAnalyzers.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "JSON",
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
				"name" : "guiSliders.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "logger.js",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "TEXT",
				"implicit" : 1
			}
, 			{
				"name" : "logger.maxpat",
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
				"name" : "pGenMidi.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "pMatrix.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "pSimpleSine.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "parseEvents.js",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "TEXT",
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
				"name" : "printLevel.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "JSON",
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
				"name" : "smooth.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "tabAudio.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "tabLiveMonitor.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "tabPerformance.maxpat",
				"bootpath" : "D:/musiGAIT/audio",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "tabSetup.maxpat",
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
