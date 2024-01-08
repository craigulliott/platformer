module Platformer
  module Generators
    module FromGrape
      SCHEMA = {
        "Studios::Attendance": {
          name: "attendances",
          description: "Returns all attendances",
          filter_params: {
            requires: {},
            optional: {
              user_id: {
                uuid: true,
                desc: "the user these attendances belong to"
              },
              organization_id: {
                uuid: true,
                desc: "the organization these attendances belong to"
              },
              location_id: {
                uuid: true,
                desc: "the location these attendances occured"
              },
              location_ids: {
                type: "Array",
                desc: "array of location ids"
              },
              occasion_id: {
                uuid: true,
                desc: "the occasion these attendances occured"
              },
              occasion_ids: {
                type: "Array",
                desc: "array of occasion ids"
              },
              date: {
                type: "Date",
                desc: "the date of the booking"
              },
              status: {
                type: "Symbol",
                values: [
                  "pending",
                  "late_arrival",
                  "checked_in",
                  "completed",
                  "no_show",
                  "canceled"
                ],
                desc: "pending, late_arrival, checked_in, completed, no_show or canceled"
              },
              statuses: {
                type: "Array",
                desc: "array of statuses"
              },
              exclude_status: {
                type: "Symbol",
                values: [
                  "pending",
                  "late_arrival",
                  "checked_in",
                  "completed",
                  "no_show",
                  "canceled"
                ],
                desc: "pending, late_arrival, checked_in, completed, no_show or canceled"
              },
              start_hour: {
                type: "Integer",
                desc: "the hour of the day that the booking starts"
              },
              start_minute: {
                type: "Integer",
                desc: "the minute of the day that the booking starts"
              },
              end_hour: {
                type: "Integer",
                desc: "the hour of the day that the booking ends"
              },
              end_minute: {
                type: "Integer",
                desc: "the minute of the day that the booking ends"
              }
            }
          },
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "date",
            "start_hour",
            "end_hour",
            "check_in_at",
            "check_out_at"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a attendance",
              get: true
            },
            {
              name: "id",
              description: "Update an attendance with information about who picked up this child",
              update_options: [
                {
                  optional_relationships: [
                    {
                      name: "check_in_user",
                      as: "user"
                    },
                    {
                      name: "check_out_user",
                      as: "user"
                    }
                  ]
                }
              ],
              update_params: {
                requires: {
                  status: {
                    type: "Symbol",
                    values: [
                      "checked_in",
                      "completed",
                      "canceled",
                      "pending"
                    ],
                    desc: "can be checked_in, completed, canceled or pending. If ommited, then the checked_in and completed states can be set at once by using the check_in_user, check_out_user, check_in_at and check_out_atattributes"
                  }
                },
                optional: {
                  check_in_at: {
                    type: "Time",
                    desc: "the time that this child was dropped off"
                  },
                  check_out_at: {
                    type: "Time",
                    desc: "the time that this child was picked up"
                  },
                  canceled_at: {
                    type: "Time",
                    desc: "the time that this booking was canceled"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                booking: {
                  name: "booking",
                  description: "Get a booking for this attendance",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                notes: {
                  name: "notes",
                  description: "List of notes for this attendance",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                photos: {
                  name: "photos",
                  description: "List of photos for this attendance",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Studios::Booking": {
          name: "bookings",
          description: "Returns all bookings",
          create_options: [
            {
              optional_relationships: [
                "location",
                "organization"
              ],
              required_relationships: [
                "occasion",
                "user"
              ]
            }
          ],
          create_params: {
            requires: {
              start_hour: {
                type: "Integer",
                desc: "the hour of the day that this booking starts"
              },
              start_minute: {
                type: "Integer",
                desc: "the minute of the day that this booking starts"
              },
              end_hour: {
                type: "Integer",
                desc: "the hour of the day that this booking ends"
              },
              end_minute: {
                type: "Integer",
                desc: "the minute of the day that this booking ends"
              },
              first_visit_at: {
                type: "Date",
                desc: "the date when this booking first occurs"
              }
            },
            optional: {
              last_visit_at: {
                type: "Date",
                desc: "the date when this booking will be deactivated, can be null for perpetually active"
              },
              excluded_dates: {
                type: "Array",
                desc: "An array of dates where this booking will not be available, used when a customer reschedules by adding a new one-off booking"
              },
              time_zone: {
                type: "String",
                desc: "This locations time zone, i.e. America/Chicago",
                default: "America/Chicago"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              ids: {
                type: "Array"
              },
              organization_id: {
                type: "UUID"
              },
              date: {
                type: "Date",
                desc: "the date of the booking"
              },
              start_hour: {
                type: "Integer",
                desc: "the hour of the day that the booking starts"
              },
              start_minute: {
                type: "Integer",
                desc: "the minute of the day that the booking starts"
              },
              end_hour: {
                type: "Integer",
                desc: "the hour of the day that the booking ends"
              },
              end_minute: {
                type: "Integer",
                desc: "the minute of the day that the booking ends"
              },
              status: {
                type: "Symbol",
                values: [
                  "held",
                  "deposit_invoiced",
                  "deposit_invoice_past_due",
                  "invoiced",
                  "invoice_past_due",
                  "attaching_to_subscription",
                  "pending",
                  "active",
                  "completing",
                  "completed"
                ],
                desc: "held, deposit_invoiced, deposit_invoice_past_due, invoiced, invoice_past_due, attaching_to_subscription, pending, active, completing or completed"
              },
              statuses: {
                type: "Array",
                desc: "array of statuses"
              },
              exclude_status: {
                type: "Symbol",
                values: [
                  "held",
                  "deposit_invoiced",
                  "deposit_invoice_past_due",
                  "invoiced",
                  "invoice_past_due",
                  "attaching_to_subscription",
                  "pending",
                  "active",
                  "completing",
                  "completed"
                ],
                desc: "held, deposit_invoiced, deposit_invoice_past_due, invoiced, invoice_past_due, attaching_to_subscription, pending, active, completing or completed"
              },
              occasion_id: {
                type: "UUID",
                desc: "a single of occasion id"
              },
              occasion_ids: {
                type: "Array",
                desc: "array of occasion ids"
              },
              location_id: {
                type: "UUID",
                desc: "a single of location id"
              },
              location_ids: {
                type: "Array",
                desc: "array of location ids"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "first_visit_at",
            "last_visit_at",
            "start_hour",
            "end_hour"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a booking",
              get: true
            },
            {
              name: "id",
              description: "Update a booking",
              update_options: [
                {
                  optional_relationships: [
                    "location",
                    "occasion",
                    "subscription"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  start_hour: {
                    type: "Integer",
                    desc: "the hour of the day that this booking starts"
                  },
                  start_minute: {
                    type: "Integer",
                    desc: "the minute of the day that this booking starts"
                  },
                  end_hour: {
                    type: "Integer",
                    desc: "the hour of the day that this booking ends"
                  },
                  end_minute: {
                    type: "Integer",
                    desc: "the minute of the day that this booking ends"
                  },
                  first_visit_at: {
                    type: "Date",
                    desc: "the date when this booking first occurs"
                  },
                  last_visit_at: {
                    type: "Date",
                    desc: "the date when this booking will be deactivated, can be null for perpetually active"
                  },
                  completed_reason: {
                    type: "Symbol",
                    values: [
                      "completed",
                      "no_show",
                      "canceled",
                      "superseded",
                      "delinquent",
                      "stopped"
                    ],
                    desc: "can be null, completed, no_show, canceled, superseded, delinquent or stopped, setting this will permanently complete and close theis booking."
                  },
                  excluded_dates: {
                    type: "Array",
                    desc: "An array of dates where this booking will not be available, used when a customer reschedules by adding a new one-off booking"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a booking",
              delete: true
            },
            {
              name: "id",
              resources: {
                attendances: {
                  name: "attendances",
                  description: "List of attendances for this booking",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      status: {
                        type: "Symbol",
                        desc: "a single status"
                      },
                      statuses: {
                        type: "Array",
                        desc: "array of statuses"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                location: {
                  name: "location",
                  description: "Get a location for this booking",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                organization: {
                  name: "organization",
                  description: "Get a organization for this booking",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                occasion: {
                  name: "occasion",
                  description: "Get a occasion for this booking",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                user: {
                  name: "user",
                  description: "Get a user for this booking",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                subscription: {
                  name: "subscription",
                  description: "Get a subscription for this booking",
                  get: true
                }
              }
            }
          ]
        },
        "Studios::BookingInstance": {
          name: "booking_instances",
          description: "Returns all booking_instances",
          filter_params: {
            requires: {},
            optional: {
              after: {
                type: "Date",
                desc: "filter by date"
              },
              before: {
                type: "Date",
                desc: "filter by date"
              },
              start_hour: {
                type: "Integer",
                desc: "the hour of the day that the booking starts"
              },
              start_minute: {
                type: "Integer",
                desc: "the minute of the day that the booking starts"
              },
              end_hour: {
                type: "Integer",
                desc: "the hour of the day that the booking ends"
              },
              end_minute: {
                type: "Integer",
                desc: "the minute of the day that the booking ends"
              },
              location_id: {
                type: "UUID"
              },
              location_ids: {
                type: "Array"
              },
              slot_instance_id: {
                type: "UUID"
              },
              slot_instance_ids: {
                type: "Array"
              },
              user_id: {
                type: "UUID"
              },
              user_ids: {
                type: "Array"
              },
              occasion_id: {
                type: "UUID"
              },
              occasion_ids: {
                type: "Array"
              }
            }
          },
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "date",
            "start_hour"
          ]
        },
        "Communication::CallQueue": {
          name: "call_queues",
          description: "Returns all call_queues",
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                desc: "Name of this call_queue"
              }
            },
            optional: {
              dialing_code: {
                type: "String",
                values: [
                  "1",
                  "20",
                  "211",
                  "212",
                  "213",
                  "216",
                  "218",
                  "220",
                  "221",
                  "222",
                  "223",
                  "224",
                  "225",
                  "226",
                  "227",
                  "228",
                  "229",
                  "230",
                  "231",
                  "232",
                  "233",
                  "234",
                  "235",
                  "236",
                  "237",
                  "238",
                  "239",
                  "240",
                  "241",
                  "242",
                  "243",
                  "244",
                  "245",
                  "246",
                  "248",
                  "249",
                  "250",
                  "251",
                  "252",
                  "253",
                  "254",
                  "255",
                  "256",
                  "257",
                  "258",
                  "260",
                  "261",
                  "262",
                  "263",
                  "264",
                  "265",
                  "266",
                  "267",
                  "268",
                  "269",
                  "27",
                  "290",
                  "291",
                  "297",
                  "298",
                  "299",
                  "30",
                  "31",
                  "32",
                  "33",
                  "34",
                  "350",
                  "351",
                  "352",
                  "353",
                  "354",
                  "355",
                  "356",
                  "357",
                  "358",
                  "359",
                  "36",
                  "370",
                  "371",
                  "372",
                  "373",
                  "374",
                  "375",
                  "376",
                  "377",
                  "378",
                  "380",
                  "381",
                  "382",
                  "385",
                  "386",
                  "387",
                  "389",
                  "39",
                  "40",
                  "41",
                  "420",
                  "421",
                  "423",
                  "43",
                  "44",
                  "45",
                  "46",
                  "47",
                  "48",
                  "49",
                  "500",
                  "501",
                  "502",
                  "503",
                  "504",
                  "505",
                  "506",
                  "507",
                  "508",
                  "509",
                  "51",
                  "52",
                  "53",
                  "54",
                  "55",
                  "56",
                  "57",
                  "58",
                  "590",
                  "591",
                  "592",
                  "593",
                  "594",
                  "595",
                  "596",
                  "597",
                  "598",
                  "599",
                  "60",
                  "61",
                  "62",
                  "63",
                  "64",
                  "65",
                  "66",
                  "670",
                  "672",
                  "673",
                  "674",
                  "675",
                  "676",
                  "677",
                  "678",
                  "679",
                  "680",
                  "681",
                  "682",
                  "683",
                  "685",
                  "686",
                  "687",
                  "688",
                  "689",
                  "690",
                  "691",
                  "692",
                  "7",
                  "81",
                  "82",
                  "84",
                  "850",
                  "852",
                  "853",
                  "855",
                  "856",
                  "86",
                  "880",
                  "886",
                  "90",
                  "91",
                  "92",
                  "93",
                  "94",
                  "95",
                  "960",
                  "961",
                  "962",
                  "963",
                  "964",
                  "965",
                  "966",
                  "967",
                  "968",
                  "970",
                  "971",
                  "972",
                  "973",
                  "974",
                  "975",
                  "976",
                  "977",
                  "98",
                  "992",
                  "993",
                  "994",
                  "995",
                  "996",
                  "998"
                ],
                desc: "a valid country dialing code, i.e. 1 for the US and 44 for the UK"
              },
              phone_number: {
                type: "String",
                desc: "Direct line to this queue"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a call_queue",
              get: true
            },
            {
              name: "id",
              description: "Update a call_queue",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this call_queue"
                  },
                  dialing_code: {
                    type: "String",
                    values: [
                      "1",
                      "20",
                      "211",
                      "212",
                      "213",
                      "216",
                      "218",
                      "220",
                      "221",
                      "222",
                      "223",
                      "224",
                      "225",
                      "226",
                      "227",
                      "228",
                      "229",
                      "230",
                      "231",
                      "232",
                      "233",
                      "234",
                      "235",
                      "236",
                      "237",
                      "238",
                      "239",
                      "240",
                      "241",
                      "242",
                      "243",
                      "244",
                      "245",
                      "246",
                      "248",
                      "249",
                      "250",
                      "251",
                      "252",
                      "253",
                      "254",
                      "255",
                      "256",
                      "257",
                      "258",
                      "260",
                      "261",
                      "262",
                      "263",
                      "264",
                      "265",
                      "266",
                      "267",
                      "268",
                      "269",
                      "27",
                      "290",
                      "291",
                      "297",
                      "298",
                      "299",
                      "30",
                      "31",
                      "32",
                      "33",
                      "34",
                      "350",
                      "351",
                      "352",
                      "353",
                      "354",
                      "355",
                      "356",
                      "357",
                      "358",
                      "359",
                      "36",
                      "370",
                      "371",
                      "372",
                      "373",
                      "374",
                      "375",
                      "376",
                      "377",
                      "378",
                      "380",
                      "381",
                      "382",
                      "385",
                      "386",
                      "387",
                      "389",
                      "39",
                      "40",
                      "41",
                      "420",
                      "421",
                      "423",
                      "43",
                      "44",
                      "45",
                      "46",
                      "47",
                      "48",
                      "49",
                      "500",
                      "501",
                      "502",
                      "503",
                      "504",
                      "505",
                      "506",
                      "507",
                      "508",
                      "509",
                      "51",
                      "52",
                      "53",
                      "54",
                      "55",
                      "56",
                      "57",
                      "58",
                      "590",
                      "591",
                      "592",
                      "593",
                      "594",
                      "595",
                      "596",
                      "597",
                      "598",
                      "599",
                      "60",
                      "61",
                      "62",
                      "63",
                      "64",
                      "65",
                      "66",
                      "670",
                      "672",
                      "673",
                      "674",
                      "675",
                      "676",
                      "677",
                      "678",
                      "679",
                      "680",
                      "681",
                      "682",
                      "683",
                      "685",
                      "686",
                      "687",
                      "688",
                      "689",
                      "690",
                      "691",
                      "692",
                      "7",
                      "81",
                      "82",
                      "84",
                      "850",
                      "852",
                      "853",
                      "855",
                      "856",
                      "86",
                      "880",
                      "886",
                      "90",
                      "91",
                      "92",
                      "93",
                      "94",
                      "95",
                      "960",
                      "961",
                      "962",
                      "963",
                      "964",
                      "965",
                      "966",
                      "967",
                      "968",
                      "970",
                      "971",
                      "972",
                      "973",
                      "974",
                      "975",
                      "976",
                      "977",
                      "98",
                      "992",
                      "993",
                      "994",
                      "995",
                      "996",
                      "998"
                    ],
                    desc: "a valid country dialing code, i.e. 1 for the US and 44 for the UK"
                  },
                  phone_number: {
                    type: "String",
                    desc: "Direct line to this queue"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a call_queue",
              delete: true
            }
          ]
        },
        "Communication::CallQueueMembership": {
          name: "call_queue_memberships",
          description: "Returns all call_queue_memberships",
          create_options: [
            {
              optional_relationships: [
                "phone",
                "call_queue"
              ]
            }
          ],
          create_params: {
            requires: {
              enabled: {
                type: "Virtus::Attribute::Boolean",
                desc: "Is accepting calls"
              },
              failover: {
                type: "Virtus::Attribute::Boolean",
                desc: "Should failover to the phones failover number, if there is one"
              }
            },
            optional: {
              priority: {
                type: "Integer",
                desc: "Priority of this phone when ringing phones in this group"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              phone_id: {
                type: "String",
                desc: "search the call_queue_memberships by phone"
              },
              phone_ids: {
                type: "Array",
                desc: "search the call_queue_memberships for multiple phones"
              },
              call_queue_id: {
                type: "UUID",
                desc: "get call_queue_memberships for a given call queue"
              },
              call_queue_ids: {
                type: "Array",
                desc: "get call_queue_memberships for multiple call queues"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a call_queue_membership",
              get: true
            },
            {
              name: "id",
              description: "Update a call_queue_membership",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  enabled: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Is accepting calls"
                  },
                  failover: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Should failover to the phones failover number, if there is one"
                  },
                  priority: {
                    type: "Integer",
                    desc: "Priority of this phone when ringing phones in this group"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a call_queue_membership",
              delete: true
            }
          ]
        },
        "Billing::InvoiceCharge": {
          name: "charges",
          description: "Returns all charges",
          create_options: [
            {
              required_relationships: [
                "invoice",
                "payment_method"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              amount: {
                type: "BigDecimal",
                coerce_with: "APICoercions::MoneyToBigDecimal",
                desc: "Amount of this charge"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a charge",
              get: true
            },
            {
              name: "id",
              resources: {
                charge_refunds: {
                  name: "charge_refunds",
                  description: "List of charge_refunds for this charge",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Billing::ChargeRefund": {
          name: "charge_refunds",
          description: "Returns all charge_refunds",
          create_options: [
            {
              optional_relationships: [
                "charge"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              amount: {
                type: "BigDecimal",
                coerce_with: "APICoercions::MoneyToBigDecimal",
                desc: "Amount of this charge_refund"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a charge_refund",
              get: true
            },
            {
              name: "id",
              resources: {
                charge: {
                  name: "charge",
                  description: "Get a charge for this charge_refund",
                  get: true
                }
              }
            }
          ]
        },
        "Checklists::Item": {
          name: "checklist_items",
          description: "Returns all checklist_items",
          create_options: [
            {
              required_relationships: [
                "checklist_version"
              ]
            }
          ],
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                desc: "Name of this checklist_item"
              },
              field_type: {
                type: "Symbol",
                values: [
                  "checkbox",
                  "text",
                  "select",
                  "radio",
                  "header"
                ],
                desc: "checkbox, text, select, radio or header"
              }
            },
            optional: {
              required: {
                type: "Virtus::Attribute::Boolean",
                desc: "Required true/false",
                default: false
              },
              description: {
                type: "String",
                desc: "Description of this checklist_item"
              },
              choices: {
                type: "Array",
                desc: "Choices of this checklist_item"
              },
              position: {
                type: "Integer",
                desc: "Position of this checklist_item"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a checklist_item",
              get: true
            },
            {
              name: "id",
              description: "Update a checklist_item",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this checklist_item"
                  },
                  description: {
                    type: "String",
                    desc: "Details of this checklist_item"
                  },
                  choices: {
                    type: "Array",
                    desc: "Choices of this checklist_item"
                  },
                  required: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Required true/false"
                  },
                  field_type: {
                    type: "Symbol",
                    values: [
                      "checkbox",
                      "text",
                      "select",
                      "radio",
                      "header"
                    ],
                    desc: "checkbox, text, select, radio or header"
                  },
                  position: {
                    type: "Integer",
                    desc: "Position of this checklist_item"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a checklist_item",
              delete: true
            },
            {
              name: "id",
              resources: {
                checklist_version: {
                  name: "checklist_version",
                  description: "Get a version for this checklist_item",
                  get: true
                }
              }
            }
          ]
        },
        "Checklists::SubmissionItem": {
          name: "checklist_submission_items",
          description: "Returns all checklist_submission_items",
          create_options: [
            {
              required_relationships: [
                "checklist_submission",
                "checklist_item"
              ]
            }
          ],
          create_params: {
            requires: {
              value: {
                type: "String",
                allow_blank: false,
                desc: "Value of this checklist_submission_item"
              }
            },
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a checklist_submission_item",
              get: true
            },
            {
              name: "id",
              description: "Update a checklist_submission_item",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {
                  value: {
                    type: "String",
                    allow_blank: false,
                    desc: "Value of this checklist_submission_item"
                  }
                },
                optional: {}
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a checklist_submission_item",
              delete: true
            },
            {
              name: "id",
              resources: {
                checklist_item: {
                  name: "checklist_item",
                  description: "Get a item for this checklist_submission_item",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                checklist_submission: {
                  name: "checklist_submission",
                  description: "Get a submission for this checklist_submission_item",
                  get: true
                }
              }
            }
          ]
        },
        "Checklists::Submission": {
          name: "checklist_submissions",
          description: "Returns all checklist_submissions",
          create_options: [
            {
              required_relationships: [
                "checklist_version"
              ]
            }
          ],
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a checklist_submission",
              get: true
            },
            {
              name: "id",
              description: "Update a submission",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  status: {
                    type: "Symbol",
                    values: [
                      "new",
                      "submitted",
                      "approved",
                      "denied"
                    ],
                    desc: "new, submitted, approved or denied"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a checklist_submission",
              delete: true
            },
            {
              name: "id",
              resources: {
                checklist_submission_items: {
                  name: "checklist_submission_items",
                  description: "List of submission_items for this checklist_submission",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                checklist_version: {
                  name: "checklist_version",
                  description: "Get a version for this checklist_submission",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                user: {
                  name: "user",
                  description: "Get a user for this checklist_submission",
                  get: true
                }
              }
            }
          ]
        },
        "Checklists::Version": {
          name: "checklist_versions",
          description: "Returns all checklist_versions",
          create_options: [
            {
              required_relationships: [
                "checklist"
              ]
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              ids: {
                type: "Array"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a checklist_version",
              get: true
            },
            {
              name: "id",
              resources: {
                checklist: {
                  name: "checklist",
                  description: "Get a checklist for this checklist_version",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                checklist_items: {
                  name: "checklist_items",
                  description: "List of items for this checklist_version",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                checklist_submissions: {
                  name: "checklist_submissions",
                  description: "List of submissions for this checklist_version",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Checklists::Checklist": {
          name: "checklists",
          description: "Returns all checklists",
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                desc: "Name of this checklist"
              }
            },
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a checklist",
              get: true
            },
            {
              name: "id",
              description: "Update a checklist",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    {
                      name: "current_version",
                      as: "checklist_version"
                    }
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this checklist"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a checklist",
              delete: true
            },
            {
              name: "id",
              resources: {
                checklist_submissions: {
                  name: "checklist_submissions",
                  description: "List of submissions for this checklist",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                checklist_versions: {
                  name: "checklist_versions",
                  description: "List of versions for this checklist",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                current_version: {
                  name: "current_version",
                  description: "Get a current_version for this checklist",
                  get: true
                }
              }
            }
          ]
        },
        "Contracts::Execution": {
          name: "contract_executions",
          description: "Returns all contract_executions",
          create_options: [
            {
              required_relationships: [
                "contract_version"
              ],
              optional_relationships: [
                "user",
                "organization"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              signature: {
                type: "String",
                desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/jpeg;base64,iVBORw0KGgo...\""
              },
              photo: {
                type: "String",
                desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/jpeg;base64,iVBORw0KGgo...\""
              },
              scan: {
                type: "String",
                desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/jpeg;base64,iVBORw0KGgo...\""
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a contract_execution",
              get: true
            },
            {
              name: "id",
              resources: {
                contract_version: {
                  name: "contract_version",
                  description: "Get a version for this contract_execution",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                user: {
                  name: "user",
                  description: "Get a user for this contract_execution",
                  get: true
                }
              }
            }
          ]
        },
        "Contracts::Version": {
          name: "contract_versions",
          description: "Returns all contract_versions",
          create_options: [
            {
              required_relationships: [
                "contract"
              ]
            }
          ],
          create_params: {
            requires: {
              contents: {
                type: "String",
                allow_blank: false,
                desc: "Contents of this contract_version"
              }
            },
            optional: {}
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a contract_version",
              get: true
            },
            {
              name: "id",
              description: "Update a contract_version",
              update_params: {
                requires: {},
                optional: {
                  contents: {
                    type: "String",
                    desc: "Contents of this contract_version"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                contract: {
                  name: "contract",
                  description: "Get a contract for this contract_version",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                contract_executions: {
                  name: "contract_executions",
                  description: "List of executions for this contract_version",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Contracts::Contract": {
          name: "contracts",
          description: "Returns all contracts",
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                desc: "Name of this contract"
              }
            },
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a contract",
              get: true
            },
            {
              name: "id",
              description: "Update a contract",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    {
                      name: "current_version",
                      as: "contract_version"
                    }
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this contract"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a contract",
              delete: true
            },
            {
              name: "id",
              resources: {
                contract_executions: {
                  name: "contract_executions",
                  description: "List of executions for this contract",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                contract_versions: {
                  name: "contract_versions",
                  description: "List of versions for this contract",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                current_version: {
                  name: "current_version",
                  description: "Get a current_version for this contract",
                  get: true
                }
              }
            }
          ]
        },
        "Curriculum::Course": {
          name: "courses",
          description: "Get a list of courses",
          create_options: [
            {
              publishable: true
            }
          ],
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                desc: "Name of this course"
              },
              description: {
                type: "String",
                allow_blank: false,
                desc: "Description of this course"
              }
            },
            optional: {
              studio_only: {
                type: "Virtus::Attribute::Boolean",
                default: false,
                desc: "If this course is only available in the studio"
              },
              position: {
                type: "Integer",
                desc: "The sort order for steps within each difficulty."
              },
              image: {
                type: "String",
                desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              }
            }
          },
          filter_options: [
            {
              deletable: true,
              publishable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a specific course",
              get: true
            },
            {
              name: "id",
              description: "Update a course",
              update_options: [
                {
                  deletable: true,
                  publishable: true
                }
              ],
              update_params: {
                requires: {
                  name: {
                    type: "String",
                    allow_blank: false,
                    desc: "Name of this course"
                  },
                  description: {
                    type: "String",
                    allow_blank: false,
                    desc: "Description of this course"
                  }
                },
                optional: {
                  studio_only: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "If this course is only available in the studio"
                  },
                  position: {
                    type: "Integer",
                    desc: "The sort order for steps within each difficulty."
                  },
                  image: {
                    type: "String",
                    desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a course",
              delete: true
            },
            {
              name: "id",
              resources: {
                difficulties: {
                  name: "difficulties",
                  description: "Get a list of difficulties for this course",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                images: {
                  name: "images",
                  description: "Get the images for this course",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Curriculum::Assets::Asset": {
          name: "curriculum_assets",
          description: "Returns all curriculum_assets",
          create_options: [
            {
              required_relationships: [
                "course"
              ]
            }
          ],
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                desc: "Name of this asset"
              },
              file: {
                type: "String",
                allow_blank: false,
                desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/jpeg;base64,iVBORw0KGgo...\""
              }
            },
            optional: {
              description: {
                type: "String",
                desc: "Description of this asset"
              },
              medium: {
                type: "Symbol",
                values: [
                  "photo",
                  "audio",
                  "video"
                ],
                desc: "photo, audio or video"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get an asset",
              get: true
            },
            {
              name: "id",
              description: "Update an asset",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this asset"
                  },
                  file: {
                    type: "String",
                    desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/jpeg;base64,iVBORw0KGgo...\""
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete an asset",
              delete: true
            }
          ]
        },
        "Billing::Coupon": {
          name: "coupons",
          description: "Returns all coupons",
          create_options: [
            {
              optional_relationships: [
                {
                  name: "ambassador",
                  as: "user"
                }
              ]
            }
          ],
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                coerce_with: "APICoercions::Uppercase",
                desc: "Name of this coupon"
              }
            },
            optional: {
              description: {
                type: "String",
                desc: "Description of this coupon"
              },
              quantity: {
                type: "Integer",
                desc: "Quantity of this coupon"
              },
              combinable: {
                type: "Virtus::Attribute::Boolean",
                desc: "Can this coupon be combined with other discounts"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search the coupons by name"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a coupon",
              get: true
            },
            {
              name: "id",
              description: "Update a coupon",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    coerce_with: "APICoercions::Uppercase",
                    desc: "Name of this coupon"
                  },
                  description: {
                    type: "String",
                    desc: "Description of this coupon"
                  },
                  quantity: {
                    type: "Integer",
                    desc: "Quantity of this coupon"
                  },
                  combinable: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Can this coupon be combined with other discounts"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a coupon",
              delete: true
            },
            {
              name: "id",
              resources: {
                coupon_occasions: {
                  name: "coupon_occasions",
                  description: "List of occasions for this coupon",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                coupon_subscription_discounts: {
                  name: "coupon_subscription_discounts",
                  description: "List of coupon_subscription_discounts for this coupon",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Billing::CouponOccasion": {
          name: "coupon_occasions",
          description: "Create a coupon_occasion",
          create_options: [
            {
              required_relationships: [
                "coupon",
                "occasion"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {}
          },
          post: true,
          authorize: [
            "account"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a coupon_occasion",
              delete: true
            }
          ]
        },
        "Curriculum::Difficulty": {
          name: "difficulties",
          authorize: [
            "account"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a difficulty",
              get: true
            },
            {
              name: "id",
              resources: {
                course: {
                  name: "course",
                  description: "Get the course for this difficulty",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                tutorials: {
                  name: "tutorials",
                  description: "Get a list of tutorials for this difficulty",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Projects::Document": {
          name: "documents",
          description: "Returns all documents",
          create_options: [
            {
              required_relationships: [
                "project"
              ]
            }
          ],
          create_params: {
            requires: {
              kidscript: {
                type: "String",
                allow_blank: true,
                desc: "the source code",
                default: ""
              },
              filename: {
                type: "String",
                allow_blank: false,
                desc: "the filename"
              }
            },
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a document",
              get: true
            },
            {
              name: "id",
              description: "Update a document",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  kidscript: {
                    type: "String",
                    desc: "the source code"
                  },
                  filename: {
                    type: "String",
                    desc: "the filename"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a document",
              delete: true
            },
            {
              name: "id",
              resources: {
                revisions: {
                  name: "revisions",
                  description: "List of revisions for this document",
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Marketing::Event": {
          name: "events",
          description: "Store a user generated event",
          create_options: [
            {
              required_relationships: [
                "public_session"
              ]
            }
          ],
          create_params: {
            requires: {
              element: {
                type: "String",
                allow_blank: false,
                desc: "the element which this event took place on, such as signup_button or age_selection must be lowercase, have no spaces and end with _button, _input, _link, _image, _cell, _form, _page"
              },
              page: {
                type: "String",
                allow_blank: false,
                desc: "where this event took place, either a path to an app view or a url to a webpage"
              },
              action: {
                type: "Symbol",
                values: [
                  "blur",
                  "click",
                  "dblclick",
                  "focus",
                  "hover",
                  "keydown",
                  "mouseenter",
                  "resize",
                  "scroll",
                  "select",
                  "submit",
                  "triggered",
                  "view"
                ],
                desc: "the type of this event, accepted values are blur, click, dblclick, focus, hover, keydown, mouseenter, resize, scroll, select, submit, triggered, view"
              }
            },
            optional: {
              location: {
                type: "String",
                desc: "where on the page this element was, such as header for signup_button or child_2 for age_selection"
              },
              properties: {
                default: {},
                type: "Hash",
                desc: "additional metadata describing this event"
              }
            }
          },
          post: true
        },
        "Communication::Emails::Email": {
          name: "emails",
          description: "Returns all emails",
          create_options: [
            {
              optional_relationships: [
                {
                  name: "replying_to",
                  as: "email"
                },
                "user",
                "organization"
              ]
            }
          ],
          create_params: {
            requires: {
              template: {
                type: "Symbol",
                values: [
                  "birthday_party_receipt",
                  "booking_created",
                  "camp_receipt",
                  "certification_support_conversation",
                  "crew_membership_info",
                  "day_camp_receipt",
                  "explorer_account_billing_notification",
                  "explorer_confirmation",
                  "explorer_launch",
                  "explorer_welcome",
                  "field_trip_receipt",
                  "guide_support_conversation",
                  "inbound",
                  "influencer_conversation",
                  "kids_night_out_receipt",
                  "lead_conversation",
                  "password_create",
                  "password_reset",
                  "product_purchase_receipt",
                  "subscription_created",
                  "support_conversation",
                  "three_day_member_billing_notification",
                  "virtual_class_one_hour_reminder",
                  "virtual_class_twenty_four_hour_reminder",
                  "welcome_kit",
                  "acquisition_stream_follow_up/attended",
                  "acquisition_stream_follow_up/trial_information",
                  "acquisition_stream_follow_up/follow_up1",
                  "acquisition_stream_follow_up/follow_up2",
                  "acquisition_stream_registered/registration_created",
                  "acquisition_stream_registered/join_stream_link",
                  "acquisition_stream_registered/twenty_four_hour_reminder",
                  "acquisition_stream_registered/two_hour_reminder",
                  "adult_player_high_intent/account_created",
                  "adult_player_low_intent/account_created",
                  "canceled_member/confirmation",
                  "canceled_member/check_in",
                  "conversion_stream_follow_up/attended",
                  "conversion_stream_follow_up/trial_information",
                  "conversion_stream_follow_up/follow_up1",
                  "conversion_stream_follow_up/follow_up2",
                  "conversion_stream_registered/registration_created",
                  "conversion_stream_registered/join_stream_link",
                  "conversion_stream_registered/twenty_four_hour_reminder",
                  "conversion_stream_registered/two_hour_reminder",
                  "gift_of_code/welcome",
                  "missed_trial_session/we_missed_you",
                  "past_due_subscription/bookings_canceled",
                  "past_due_subscription/update_payment_info",
                  "guide_certification/welcome",
                  "guide_certification/follow_up",
                  "guide_contractor_agreement_signed/renewal_notice",
                  "guide_contractor_agreement_signed/renewal_notice_without_raise",
                  "guide_contractor_agreement_signed/termination_notice",
                  "guide_onboarding/welcome",
                  "guide_onboarding/follow_up",
                  "influencer_program_lead/account_setup",
                  "influencer_program_lead/follow_up1",
                  "influencer_program_lead/follow_up2",
                  "influencer_program_lead/follow_up3",
                  "influencer_program_lead/follow_up4",
                  "kid_player/account_created",
                  "on_demand_stream_follow_up/attended",
                  "on_demand_stream_follow_up/follow_up1",
                  "on_demand_stream_follow_up/follow_up2",
                  "on_demand_stream_registered/registration_created",
                  "partner_group_class_booked/booking_created",
                  "partner_group_class_booked/twenty_four_hour_reminder",
                  "partner_group_class_booked/two_hour_reminder",
                  "partner_group_class_follow_up/class_recap",
                  "partner_group_class_follow_up/membership_information",
                  "unused_credits/end_of_cycle_reminder",
                  "unused_credits/new_credits",
                  "unused_credits/one_week_reminder",
                  "ussc_virtual_camp_booked/registration_packet",
                  "ussc_virtual_camp_booked/two_day_reminder",
                  "ussc_virtual_camp_booked/camp_recap",
                  "ussc_virtual_camp_follow_up/trial_information",
                  "virtual_classes_lead/account_created",
                  "virtual_classes_lead/share_games",
                  "virtual_classes_lead/share_videos",
                  "virtual_classes_lead/share_events",
                  "virtual_classes_lead/checking_in1",
                  "virtual_classes_lead/checking_in2",
                  "virtual_classes_prospect/account_created",
                  "virtual_classes_prospect/share_games",
                  "virtual_classes_prospect/share_videos",
                  "virtual_classes_prospect/share_events",
                  "virtual_classes_prospect/checking_in1",
                  "virtual_classes_prospect/checking_in2",
                  "virtual_trial_booked/one_hour_reminder",
                  "virtual_trial_booked/trial_created",
                  "virtual_trial_booked/twenty_four_hour_reminder",
                  "virtual_trial_follow_up/attended",
                  "virtual_trial_period/day5",
                  "virtual_trial_period/day5_with_subscription",
                  "virtual_trial_period/day7",
                  "virtual_trial_period/day7_with_subscription",
                  "virtual_trial_period/trial_created",
                  "virtual_trial_period/trial_created_with_subscription"
                ],
                desc: "birthday_party_receipt, booking_created, camp_receipt, certification_support_conversation, crew_membership_info, day_camp_receipt, explorer_account_billing_notification, explorer_confirmation, explorer_launch, explorer_welcome, field_trip_receipt, guide_support_conversation, inbound, influencer_conversation, kids_night_out_receipt, lead_conversation, password_create, password_reset, product_purchase_receipt, subscription_created, support_conversation, three_day_member_billing_notification, virtual_class_one_hour_reminder, virtual_class_twenty_four_hour_reminder, welcome_kit, acquisition_stream_follow_up/attended, acquisition_stream_follow_up/trial_information, acquisition_stream_follow_up/follow_up1, acquisition_stream_follow_up/follow_up2, acquisition_stream_registered/registration_created, acquisition_stream_registered/join_stream_link, acquisition_stream_registered/twenty_four_hour_reminder, acquisition_stream_registered/two_hour_reminder, adult_player_high_intent/account_created, adult_player_low_intent/account_created, canceled_member/confirmation, canceled_member/check_in, conversion_stream_follow_up/attended, conversion_stream_follow_up/trial_information, conversion_stream_follow_up/follow_up1, conversion_stream_follow_up/follow_up2, conversion_stream_registered/registration_created, conversion_stream_registered/join_stream_link, conversion_stream_registered/twenty_four_hour_reminder, conversion_stream_registered/two_hour_reminder, gift_of_code/welcome, missed_trial_session/we_missed_you, past_due_subscription/bookings_canceled, past_due_subscription/update_payment_info, guide_certification/welcome, guide_certification/follow_up, guide_contractor_agreement_signed/renewal_notice, guide_contractor_agreement_signed/renewal_notice_without_raise, guide_contractor_agreement_signed/termination_notice, guide_onboarding/welcome, guide_onboarding/follow_up, influencer_program_lead/account_setup, influencer_program_lead/follow_up1, influencer_program_lead/follow_up2, influencer_program_lead/follow_up3, influencer_program_lead/follow_up4, kid_player/account_created, on_demand_stream_follow_up/attended, on_demand_stream_follow_up/follow_up1, on_demand_stream_follow_up/follow_up2, on_demand_stream_registered/registration_created, partner_group_class_booked/booking_created, partner_group_class_booked/twenty_four_hour_reminder, partner_group_class_booked/two_hour_reminder, partner_group_class_follow_up/class_recap, partner_group_class_follow_up/membership_information, unused_credits/end_of_cycle_reminder, unused_credits/new_credits, unused_credits/one_week_reminder, ussc_virtual_camp_booked/registration_packet, ussc_virtual_camp_booked/two_day_reminder, ussc_virtual_camp_booked/camp_recap, ussc_virtual_camp_follow_up/trial_information, virtual_classes_lead/account_created, virtual_classes_lead/share_games, virtual_classes_lead/share_videos, virtual_classes_lead/share_events, virtual_classes_lead/checking_in1, virtual_classes_lead/checking_in2, virtual_classes_prospect/account_created, virtual_classes_prospect/share_games, virtual_classes_prospect/share_videos, virtual_classes_prospect/share_events, virtual_classes_prospect/checking_in1, virtual_classes_prospect/checking_in2, virtual_trial_booked/one_hour_reminder, virtual_trial_booked/trial_created, virtual_trial_booked/twenty_four_hour_reminder, virtual_trial_follow_up/attended, virtual_trial_period/day5, virtual_trial_period/day5_with_subscription, virtual_trial_period/day7, virtual_trial_period/day7_with_subscription, virtual_trial_period/trial_created or virtual_trial_period/trial_created_with_subscription"
              }
            },
            optional: {
              subject: {
                type: "String",
                desc: "Subject line for this message"
              },
              body: {
                type: "String",
                desc: "Plain text content of the message"
              },
              attachments: {
                type: "Array",
                default: [],
                desc: "Attributes for related email attachments"
              }
            }
          },
          filter_options: [
            {
              handleable: true,
              claimable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search the emails"
              },
              template: {
                type: "Symbol",
                values: [
                  "birthday_party_receipt",
                  "booking_created",
                  "camp_receipt",
                  "certification_support_conversation",
                  "crew_membership_info",
                  "day_camp_receipt",
                  "explorer_account_billing_notification",
                  "explorer_confirmation",
                  "explorer_launch",
                  "explorer_welcome",
                  "field_trip_receipt",
                  "guide_support_conversation",
                  "inbound",
                  "influencer_conversation",
                  "kids_night_out_receipt",
                  "lead_conversation",
                  "password_create",
                  "password_reset",
                  "product_purchase_receipt",
                  "subscription_created",
                  "support_conversation",
                  "three_day_member_billing_notification",
                  "virtual_class_one_hour_reminder",
                  "virtual_class_twenty_four_hour_reminder",
                  "welcome_kit",
                  "acquisition_stream_follow_up/attended",
                  "acquisition_stream_follow_up/trial_information",
                  "acquisition_stream_follow_up/follow_up1",
                  "acquisition_stream_follow_up/follow_up2",
                  "acquisition_stream_registered/registration_created",
                  "acquisition_stream_registered/join_stream_link",
                  "acquisition_stream_registered/twenty_four_hour_reminder",
                  "acquisition_stream_registered/two_hour_reminder",
                  "adult_player_high_intent/account_created",
                  "adult_player_low_intent/account_created",
                  "canceled_member/confirmation",
                  "canceled_member/check_in",
                  "conversion_stream_follow_up/attended",
                  "conversion_stream_follow_up/trial_information",
                  "conversion_stream_follow_up/follow_up1",
                  "conversion_stream_follow_up/follow_up2",
                  "conversion_stream_registered/registration_created",
                  "conversion_stream_registered/join_stream_link",
                  "conversion_stream_registered/twenty_four_hour_reminder",
                  "conversion_stream_registered/two_hour_reminder",
                  "gift_of_code/welcome",
                  "missed_trial_session/we_missed_you",
                  "past_due_subscription/bookings_canceled",
                  "past_due_subscription/update_payment_info",
                  "guide_certification/welcome",
                  "guide_certification/follow_up",
                  "guide_contractor_agreement_signed/renewal_notice",
                  "guide_contractor_agreement_signed/renewal_notice_without_raise",
                  "guide_contractor_agreement_signed/termination_notice",
                  "guide_onboarding/welcome",
                  "guide_onboarding/follow_up",
                  "influencer_program_lead/account_setup",
                  "influencer_program_lead/follow_up1",
                  "influencer_program_lead/follow_up2",
                  "influencer_program_lead/follow_up3",
                  "influencer_program_lead/follow_up4",
                  "kid_player/account_created",
                  "on_demand_stream_follow_up/attended",
                  "on_demand_stream_follow_up/follow_up1",
                  "on_demand_stream_follow_up/follow_up2",
                  "on_demand_stream_registered/registration_created",
                  "partner_group_class_booked/booking_created",
                  "partner_group_class_booked/twenty_four_hour_reminder",
                  "partner_group_class_booked/two_hour_reminder",
                  "partner_group_class_follow_up/class_recap",
                  "partner_group_class_follow_up/membership_information",
                  "unused_credits/end_of_cycle_reminder",
                  "unused_credits/new_credits",
                  "unused_credits/one_week_reminder",
                  "ussc_virtual_camp_booked/registration_packet",
                  "ussc_virtual_camp_booked/two_day_reminder",
                  "ussc_virtual_camp_booked/camp_recap",
                  "ussc_virtual_camp_follow_up/trial_information",
                  "virtual_classes_lead/account_created",
                  "virtual_classes_lead/share_games",
                  "virtual_classes_lead/share_videos",
                  "virtual_classes_lead/share_events",
                  "virtual_classes_lead/checking_in1",
                  "virtual_classes_lead/checking_in2",
                  "virtual_classes_prospect/account_created",
                  "virtual_classes_prospect/share_games",
                  "virtual_classes_prospect/share_videos",
                  "virtual_classes_prospect/share_events",
                  "virtual_classes_prospect/checking_in1",
                  "virtual_classes_prospect/checking_in2",
                  "virtual_trial_booked/one_hour_reminder",
                  "virtual_trial_booked/trial_created",
                  "virtual_trial_booked/twenty_four_hour_reminder",
                  "virtual_trial_follow_up/attended",
                  "virtual_trial_period/day5",
                  "virtual_trial_period/day5_with_subscription",
                  "virtual_trial_period/day7",
                  "virtual_trial_period/day7_with_subscription",
                  "virtual_trial_period/trial_created",
                  "virtual_trial_period/trial_created_with_subscription"
                ],
                desc: "an email template"
              },
              templates: {
                type: "Array",
                desc: "array of templates"
              },
              status: {
                type: "Symbol",
                values: [
                  "new",
                  "received",
                  "queued",
                  "scheduled",
                  "rejected",
                  "sent",
                  "not_valid",
                  "error"
                ],
                desc: "an email status"
              },
              statuses: {
                type: "Array",
                desc: "array of statuses"
              },
              staff_team_id: {
                type: "UUID"
              },
              claimed_by_id: {
                type: "UUID"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "handled_at"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a email",
              get: true
            },
            {
              name: "id",
              description: "Update a email",
              update_options: [
                {
                  handleable: true,
                  claimable: true,
                  optional_relationships: [
                    "staff_team"
                  ]
                }
              ],
              put: true
            },
            {
              name: "id",
              resources: {
                organizations: {
                  name: "organizations",
                  description: "List of organizations for this email",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                notes: {
                  name: "notes",
                  description: "List of notes for this email",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Organizations::EmergencyContact": {
          name: "emergency_contacts",
          description: "Returns all emergency_contacts",
          create_options: [
            {
              optional_relationships: [
                "organization"
              ]
            }
          ],
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                desc: "name of this emergency_contact"
              },
              dialing_code: {
                type: "String",
                allow_blank: false,
                default: "1",
                desc: "dialing_code for this emergency_contact"
              },
              phone_number: {
                type: "String",
                allow_blank: false,
                desc: "phone_number for this emergency_contact"
              }
            },
            optional: {
              relationship: {
                type: "String",
                desc: "relationship with this emergency_contact"
              },
              additional_information: {
                type: "String",
                desc: "any additional information for this emergency_contact"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a emergency_contact",
              get: true
            },
            {
              name: "id",
              description: "Update a emergency_contact",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "name of this emergency_contact"
                  },
                  dialing_code: {
                    type: "String",
                    default: "1",
                    desc: "dialing_code for this emergency_contact"
                  },
                  phone_number: {
                    type: "String",
                    desc: "phone_number for this emergency_contact"
                  },
                  relationship: {
                    type: "String",
                    desc: "relationship with this emergency_contact"
                  },
                  additional_information: {
                    type: "String",
                    desc: "any additional information for this emergency_contact"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a emergency_contact",
              delete: true
            }
          ]
        },
        "Staff::EmployeeReview": {
          name: "employee_reviews",
          description: "Returns all employee_reviews",
          create_options: [
            {
              required_relationships: [
                "employee"
              ]
            }
          ],
          create_params: {
            requires: {
              reason: {
                type: "Symbol",
                values: [
                  "scheduled",
                  "requested",
                  "warning"
                ],
                desc: "scheduled, requested or warning"
              }
            },
            optional: {
              details: {
                type: "String",
                desc: "Details of this employee_review"
              },
              employee_comments: {
                type: "String",
                desc: "Employee Comments of this employee_review"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a employee_review",
              get: true
            },
            {
              name: "id",
              description: "Update a employee_review",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  reason: {
                    type: "Symbol",
                    desc: "Reason of this employee_review"
                  },
                  details: {
                    type: "String",
                    desc: "Details of this employee_review"
                  },
                  employee_comments: {
                    type: "String",
                    desc: "Employee Comments of this employee_review"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a employee_review",
              delete: true
            }
          ]
        },
        "Hardware::Components::Component": {
          name: "hardware_components",
          description: "Returns all components",
          create_options: [
            {
              required_relationships: [
                "location",
                "hardware_vendor"
              ],
              optional_relationships: [
                {
                  name: "hardware_parent_component",
                  as: "hardware_component"
                }
              ]
            }
          ],
          create_params: {
            requires: {
              driver: {
                type: "Symbol",
                values: [
                  "codeverse_module",
                  "display",
                  "door_controller",
                  "estimote_beacon",
                  "imac",
                  "student_ipad",
                  "instructor_ipad",
                  "retail_ipad",
                  "fixed_ipad",
                  "home_pod",
                  "lifx_bulb",
                  "maker_bot",
                  "carvey",
                  "meraki_access_point",
                  "meraki_router",
                  "moving_spot_light",
                  "moving_mini_spot_light",
                  "moving_wash_light",
                  "nova_server",
                  "network_interface",
                  "portal",
                  "phone",
                  "printer",
                  "thermostat",
                  "projector",
                  "speaker",
                  "smart_glass",
                  "power_switch",
                  "power_outlet",
                  "strobe_light",
                  "robot_arm",
                  "ubiquiti_camera",
                  "ubiquiti_switch"
                ],
                desc: "codeverse_module, display, door_controller, estimote_beacon, imac, student_ipad, instructor_ipad, retail_ipad, fixed_ipad, home_pod, lifx_bulb, maker_bot, carvey, meraki_access_point, meraki_router, moving_spot_light, moving_mini_spot_light, moving_wash_light, nova_server, network_interface, portal, phone, printer, thermostat, projector, speaker, smart_glass, power_switch, power_outlet, strobe_light, robot_arm, ubiquiti_camera or ubiquiti_switch"
              }
            },
            optional: {
              asset_tag: {
                type: "Integer",
                desc: "Asset Tag of this component"
              },
              hostname: {
                type: "String",
                desc: "Hostname of this component"
              },
              serial_number: {
                type: "String",
                desc: "Serial Number of this component"
              },
              mac_address: {
                type: "String",
                desc: "Mac Address of this component"
              },
              ip_address: {
                type: "String",
                desc: "Ip Address of this component"
              },
              subnet: {
                type: "String",
                desc: "Subnet of this component"
              },
              port: {
                type: "Integer",
                desc: "Port of this component"
              },
              dmx_channel: {
                type: "Integer",
                desc: "Dmx Channel of this component"
              },
              major_channel: {
                type: "String",
                desc: "Major Channel of this component"
              },
              minor_channel: {
                type: "String",
                desc: "Minor Channel of this component"
              },
              push_token: {
                type: "String",
                desc: "Push Token of this component"
              },
              x: {
                type: "Integer",
                desc: "X of this component"
              },
              y: {
                type: "Integer",
                desc: "Y of this component"
              },
              z: {
                type: "Integer",
                desc: "Z of this component"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              driver: {
                type: "Symbol",
                values: [
                  "codeverse_module",
                  "display",
                  "door_controller",
                  "estimote_beacon",
                  "imac",
                  "student_ipad",
                  "instructor_ipad",
                  "retail_ipad",
                  "fixed_ipad",
                  "home_pod",
                  "lifx_bulb",
                  "maker_bot",
                  "carvey",
                  "meraki_access_point",
                  "meraki_router",
                  "moving_spot_light",
                  "moving_mini_spot_light",
                  "moving_wash_light",
                  "nova_server",
                  "network_interface",
                  "portal",
                  "phone",
                  "printer",
                  "thermostat",
                  "projector",
                  "speaker",
                  "smart_glass",
                  "power_switch",
                  "power_outlet",
                  "strobe_light",
                  "robot_arm",
                  "ubiquiti_camera",
                  "ubiquiti_switch"
                ],
                desc: "codeverse_module, display, door_controller, estimote_beacon, imac, student_ipad, instructor_ipad, retail_ipad, fixed_ipad, home_pod, lifx_bulb, maker_bot, carvey, meraki_access_point, meraki_router, moving_spot_light, moving_mini_spot_light, moving_wash_light, nova_server, network_interface, portal, phone, printer, thermostat, projector, speaker, smart_glass, power_switch, power_outlet, strobe_light, robot_arm, ubiquiti_camera or ubiquiti_switch"
              },
              q: {
                type: "String",
                desc: "search the hostname"
              },
              last_heartbeat_topic: {
                type: "Symbol",
                values: [
                  "healthy",
                  "info",
                  "warning",
                  "error"
                ],
                desc: "the current health state of this component"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "last_seen_at",
            "hostname",
            "driver",
            "status"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a component",
              get: true
            },
            {
              name: "id",
              description: "Update a component",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "location",
                    "hardware_vendor",
                    {
                      name: "hardware_parent_component",
                      as: "hardware_component"
                    }
                  ]
                }
              ],
              update_params: {
                requires: {
                  driver: {
                    type: "Symbol",
                    values: [
                      "codeverse_module",
                      "display",
                      "door_controller",
                      "estimote_beacon",
                      "imac",
                      "student_ipad",
                      "instructor_ipad",
                      "retail_ipad",
                      "fixed_ipad",
                      "home_pod",
                      "lifx_bulb",
                      "maker_bot",
                      "carvey",
                      "meraki_access_point",
                      "meraki_router",
                      "moving_spot_light",
                      "moving_mini_spot_light",
                      "moving_wash_light",
                      "nova_server",
                      "network_interface",
                      "portal",
                      "phone",
                      "printer",
                      "thermostat",
                      "projector",
                      "speaker",
                      "smart_glass",
                      "power_switch",
                      "power_outlet",
                      "strobe_light",
                      "robot_arm",
                      "ubiquiti_camera",
                      "ubiquiti_switch"
                    ],
                    desc: "codeverse_module, display, door_controller, estimote_beacon, imac, student_ipad, instructor_ipad, retail_ipad, fixed_ipad, home_pod, lifx_bulb, maker_bot, carvey, meraki_access_point, meraki_router, moving_spot_light, moving_mini_spot_light, moving_wash_light, nova_server, network_interface, portal, phone, printer, thermostat, projector, speaker, smart_glass, power_switch, power_outlet, strobe_light, robot_arm, ubiquiti_camera or ubiquiti_switch"
                  }
                },
                optional: {
                  asset_tag: {
                    type: "Integer",
                    desc: "Asset Tag of this component"
                  },
                  hostname: {
                    type: "String",
                    desc: "Hostname of this component"
                  },
                  serial_number: {
                    type: "String",
                    desc: "Serial Number of this component"
                  },
                  mac_address: {
                    type: "String",
                    desc: "Mac Address of this component"
                  },
                  ip_address: {
                    type: "String",
                    desc: "Ip Address of this component"
                  },
                  subnet: {
                    type: "String",
                    desc: "Subnet of this component"
                  },
                  port: {
                    type: "Integer",
                    desc: "Port of this component"
                  },
                  dmx_channel: {
                    type: "Integer",
                    desc: "Dmx Channel of this component"
                  },
                  major_channel: {
                    type: "String",
                    desc: "Major Channel of this component"
                  },
                  minor_channel: {
                    type: "String",
                    desc: "Minor Channel of this component"
                  },
                  push_token: {
                    type: "String",
                    desc: "Push Token of this component"
                  },
                  x: {
                    type: "Integer",
                    desc: "X of this component"
                  },
                  y: {
                    type: "Integer",
                    desc: "Y of this component"
                  },
                  z: {
                    type: "Integer",
                    desc: "Z of this component"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a component",
              delete: true
            },
            {
              name: "id",
              resources: {
                hardware_heartbeats: {
                  name: "hardware_heartbeats",
                  description: "List of hardware_heartbeats for this component",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Hardware::Heartbeat": {
          name: "hardware_heartbeats",
          description: "Returns all heartbeats",
          create_options: [
            {
              required_relationships: [
                "hardware_component"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              comment: {
                type: "String",
                desc: "Useful description of this heartbeat"
              },
              topic: {
                type: "Symbol",
                values: [
                  "healthy",
                  "info",
                  "warning",
                  "error"
                ],
                desc: "healthy, info, warning or error"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a heartbeat",
              get: true
            }
          ]
        },
        "Hardware::Vendor": {
          name: "hardware_vendors",
          description: "Returns all vendors",
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this vendor"
              },
              contact_name: {
                type: "String",
                desc: "Contact Name of this vendor"
              },
              contact_email: {
                type: "String",
                desc: "Contact Email of this vendor"
              },
              contact_phone: {
                type: "String",
                desc: "Contact Phone of this vendor"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a vendor",
              get: true
            },
            {
              name: "id",
              description: "Update a vendor",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this vendor"
                  },
                  contact_name: {
                    type: "String",
                    desc: "Contact Name of this vendor"
                  },
                  contact_email: {
                    type: "String",
                    desc: "Contact Email of this vendor"
                  },
                  contact_phone: {
                    type: "String",
                    desc: "Contact Phone of this vendor"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a vendor",
              delete: true
            }
          ]
        },
        "Users::HealthRecord": {
          name: "health_records",
          description: "Returns all health_records",
          create_options: [
            {
              optional_relationships: [
                "organization",
                "user"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              allergies: {
                type: "String",
                desc: "description goes here"
              },
              learning: {
                type: "String",
                desc: "description goes here"
              },
              mobility: {
                type: "String",
                desc: "description goes here"
              },
              eyesight: {
                type: "String",
                desc: "description goes here"
              },
              hearing: {
                type: "String",
                desc: "description goes here"
              },
              medications: {
                type: "String",
                desc: "description goes here"
              },
              seizures: {
                type: "String",
                desc: "description goes here"
              },
              additional_information: {
                type: "String",
                desc: "description goes here"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a health_record",
              get: true
            },
            {
              name: "id",
              description: "Update a health_record",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  allergies: {
                    type: "String",
                    desc: "description goes here"
                  },
                  learning: {
                    type: "String",
                    desc: "description goes here"
                  },
                  mobility: {
                    type: "String",
                    desc: "description goes here"
                  },
                  eyesight: {
                    type: "String",
                    desc: "description goes here"
                  },
                  hearing: {
                    type: "String",
                    desc: "description goes here"
                  },
                  medications: {
                    type: "String",
                    desc: "description goes here"
                  },
                  seizures: {
                    type: "String",
                    desc: "description goes here"
                  },
                  additional_information: {
                    type: "String",
                    desc: "description goes here"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a health_record",
              delete: true
            }
          ]
        },
        "Users::HowHeardAbout": {
          name: "how_heard_abouts",
          description: "Returns all how_heard_abouts",
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this how_heard_about"
              },
              description: {
                type: "String",
                desc: "Description of this how_heard_about"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search the how heard abouts"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a how_heard_about",
              get: true
            },
            {
              name: "id",
              description: "Update a how_heard_about",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this how_heard_about"
                  },
                  description: {
                    type: "String",
                    desc: "Description of this how_heard_about"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a how_heard_about",
              delete: true
            }
          ]
        },
        "Curriculum::Image": {
          name: "images",
          description: "Returns all images",
          create_options: [
            {
              optional_relationships: [
                "course"
              ]
            }
          ],
          create_params: {
            requires: {
              file: {
                type: "String",
                allow_blank: false,
                desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              }
            },
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a image",
              get: true
            },
            {
              name: "id",
              description: "Update a image",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "course"
                  ]
                }
              ],
              update_params: {
                requires: {
                  file: {
                    type: "String",
                    allow_blank: false,
                    desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  }
                },
                optional: {}
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a image",
              delete: true
            },
            {
              name: "id",
              resources: {
                course: {
                  name: "course",
                  description: "Get the course for this image",
                  get: true
                }
              }
            }
          ]
        },
        "Incidents::Incident": {
          name: "incidents",
          description: "Returns all incidents",
          create_options: [
            {
              optional_relationships: [
                "location",
                {
                  name: "owner",
                  as: "user"
                }
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              occured_at: {
                type: "Time",
                desc: "Occured At of this incident"
              },
              topic: {
                type: "Symbol",
                values: [
                  "behavior",
                  "customer_service",
                  "facilities",
                  "health_and_safety",
                  "other",
                  "technology"
                ],
                desc: "behavior, customer_service, facilities, health_and_safety, other or technology"
              },
              emergency: {
                type: "Virtus::Attribute::Boolean",
                desc: "Emergency of this incident"
              },
              other: {
                type: "String",
                desc: "Other of this incident"
              },
              description: {
                type: "String",
                desc: "Description of this incident"
              }
            }
          },
          filter_options: [
            {
              deletable: true,
              handleable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search by string"
              },
              location_id: {
                type: "String",
                desc: "get leads for location"
              },
              location_ids: {
                type: "Array",
                desc: "get leads for multiple locations"
              },
              topic: {
                type: "Symbol",
                values: [
                  "behavior",
                  "customer_service",
                  "facilities",
                  "health_and_safety",
                  "other",
                  "technology"
                ],
                desc: "behavior, customer_service, facilities, health_and_safety, other or technology"
              },
              topics: {
                type: "Array",
                desc: "array of topics"
              },
              owner_id: {
                type: "UUID"
              },
              author_id: {
                type: "UUID"
              },
              occured_after: {
                type: "Date",
                desc: "filter by occured date"
              },
              occured_before: {
                type: "Date",
                desc: "filter by occured date"
              },
              emergency: {
                type: "Virtus::Attribute::Boolean"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "occured_at"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a incident",
              get: true
            },
            {
              name: "id",
              description: "Update a incident",
              update_options: [
                {
                  deletable: true,
                  handleable: true,
                  optional_relationships: [
                    {
                      name: "owner",
                      as: "user"
                    }
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  occured_at: {
                    type: "Time",
                    desc: "Occured At of this incident"
                  },
                  topic: {
                    type: "Symbol",
                    desc: "Topic of this incident"
                  },
                  emergency: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Emergency of this incident"
                  },
                  other: {
                    type: "String",
                    desc: "Other of this incident"
                  },
                  description: {
                    type: "String",
                    desc: "Description of this incident"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a incident",
              delete: true
            },
            {
              name: "id",
              resources: {
                location: {
                  name: "location",
                  description: "Get a location for this incident",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                incident_attachments: {
                  name: "incident_attachments",
                  description: "List of attachments for this incident",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                incident_involvements: {
                  name: "incident_involvements",
                  description: "List of involvements for this incident",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                incident_tasks: {
                  name: "incident_tasks",
                  description: "List of tasks for this incident",
                  filter_options: [
                    {
                      deletable: true,
                      completable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Incidents::Attachment": {
          name: "incident_attachments",
          description: "Returns all incident_attachments",
          create_options: [
            {
              optional_relationships: [
                "incident"
              ]
            }
          ],
          create_params: {
            requires: {
              file: {
                type: "String",
                allow_blank: false,
                desc: "A file to attach, should be sent base64 encoded in Data URI format such as \"data:image/jpeg;base64,iVBORw0KGgo...\""
              }
            },
            optional: {
              description: {
                type: "String",
                desc: "Description of this incident_attachment"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a incident_attachment",
              get: true
            },
            {
              name: "id",
              description: "Update a incident_attachment",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "incident"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  description: {
                    type: "String",
                    desc: "Description of this incident_attachment"
                  },
                  attachment_file_name: {
                    type: "String",
                    desc: "Attachment File Name of this incident_attachment"
                  },
                  attachment_content_type: {
                    type: "String",
                    desc: "Attachment Content Type of this incident_attachment"
                  },
                  attachment_file_size: {
                    type: "Integer",
                    desc: "Attachment File Size of this incident_attachment"
                  },
                  attachment_updated_at: {
                    type: "Time",
                    desc: "Attachment Updated At of this incident_attachment"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a incident_attachment",
              delete: true
            },
            {
              name: "id",
              resources: {
                incident: {
                  name: "incident",
                  description: "Get a incident for this incident_attachment",
                  get: true
                }
              }
            }
          ]
        },
        "Incidents::Involvement": {
          name: "incident_involvements",
          description: "Returns all incident_involvements",
          create_options: [
            {
              required_relationships: [
                "incident",
                "user"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              description: {
                type: "String",
                desc: "Description of this incident_involvement"
              },
              perspective: {
                type: "String",
                desc: "Perspective of this incident_involvement"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a incident_involvement",
              get: true
            },
            {
              name: "id",
              description: "Update a incident_involvement",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  description: {
                    type: "String",
                    desc: "Description of this incident_involvement"
                  },
                  perspective: {
                    type: "String",
                    desc: "Perspective of this incident_involvement"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a incident_involvement",
              delete: true
            },
            {
              name: "id",
              resources: {
                incident: {
                  name: "incident",
                  description: "Get a incident for this incident_involvement",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                user: {
                  name: "user",
                  description: "Get a user for this incident_involvement",
                  get: true
                }
              }
            }
          ]
        },
        "Incidents::Task": {
          name: "incident_tasks",
          description: "Returns all incident_tasks",
          create_options: [
            {
              optional_relationships: [
                "incident",
                "staff_team",
                {
                  name: "assignee",
                  as: "user"
                }
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              instruction: {
                type: "String",
                desc: "Instruction of this incident_task"
              },
              conclusion: {
                type: "String",
                desc: "Conclusion of this incident_task"
              },
              priority: {
                type: "Symbol",
                values: [
                  "low",
                  "medium",
                  "high"
                ],
                desc: "low, medium or high"
              },
              due_at: {
                type: "Time",
                desc: "Due At of this incident_task"
              }
            }
          },
          filter_options: [
            {
              deletable: true,
              completable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search by string"
              },
              ids: {
                type: "Array"
              },
              completed: {
                type: "Virtus::Attribute::Boolean"
              },
              location_id: {
                type: "String",
                desc: "get leads for location"
              },
              author_id: {
                type: "UUID"
              },
              assignor_id: {
                type: "UUID"
              },
              assignee_id: {
                type: "UUID"
              },
              staff_team_id: {
                type: "UUID"
              },
              due_after: {
                type: "Date",
                desc: "filter by due date"
              },
              due_before: {
                type: "Date",
                desc: "filter by due date"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "due_at",
            "completed_at"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a incident_task",
              get: true
            },
            {
              name: "id",
              description: "Update a incident_task",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "staff_team",
                    {
                      name: "assignee",
                      as: "user"
                    }
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  instruction: {
                    type: "String",
                    desc: "Instruction of this incident_task"
                  },
                  conclusion: {
                    type: "String",
                    desc: "Conclusion of this incident_task"
                  },
                  completed: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Completed of this incident_task"
                  },
                  priority: {
                    type: "Symbol",
                    values: [
                      "low",
                      "medium",
                      "high"
                    ],
                    desc: "low, medium or high"
                  },
                  due_at: {
                    type: "Time",
                    desc: "Due At of this incident_task"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a incident_task",
              delete: true
            },
            {
              name: "id",
              resources: {
                incident: {
                  name: "incident",
                  description: "Get a incident for this incident_task",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                assignee: {
                  name: "assignee",
                  description: "Get a assignee for this incident_task",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                assignor: {
                  name: "assignor",
                  description: "Get a assignor for this incident_task",
                  get: true
                }
              }
            }
          ]
        },
        "Leads::Interest": {
          name: "interests",
          description: "Returns all interests",
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                desc: "Name of this interest"
              }
            },
            optional: {}
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a interest",
              get: true
            }
          ]
        },
        "Billing::Invoice": {
          name: "invoices",
          description: "Returns all invoices",
          create_options: [
            {
              required_relationships: [
                "merchant_account"
              ],
              optional_relationships: [
                "organization",
                "payment_method"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              due_at: {
                type: "Date",
                desc: "the date when this invoice is due"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a invoice",
              get: true
            },
            {
              name: "id",
              description: "Update an invoice",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "payment_method"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  due_at: {
                    type: "Date",
                    desc: "the date when this invoice is due"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a invoice",
              delete: true
            },
            {
              name: "id",
              resources: {
                organization: {
                  name: "organization",
                  description: "Get a organization for this invoice",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                payment_method: {
                  name: "payment_method",
                  description: "List of payment_methods for this invoice",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                coupons: {
                  name: "coupons",
                  description: "List of coupons for this invoice",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                invoice_bookings: {
                  name: "invoice_bookings",
                  description: "List of invoice_bookings for this invoice",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                invoice_product_purchases: {
                  name: "invoice_product_purchases",
                  description: "List of invoice_product_purchases for this invoice",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                invoice_product_returns: {
                  name: "invoice_product_returns",
                  description: "List of invoice_product_returns for this invoice",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                invoice_subscription_prepayments: {
                  name: "invoice_subscription_prepayments",
                  description: "List of invoice_subscription_prepayments for this invoice",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                invoice_vouchers: {
                  name: "invoice_vouchers",
                  description: "List of invoice_vouchers for this invoice",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                invoice_coupons: {
                  name: "invoice_coupons",
                  description: "List of invoice_coupons for this invoice",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                charges: {
                  name: "charges",
                  description: "List of charges for this invoice",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Billing::InvoiceBookings::InvoiceBooking": {
          name: "invoice_bookings",
          description: "Create an invoice_booking",
          create_options: [
            {
              optional_relationships: [
                "invoice",
                "booking"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              allocation: {
                type: "Symbol",
                values: [
                  "deposit",
                  "balance"
                ],
                desc: "deposit and balance"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a invoice_booking",
              get: true
            },
            {
              name: "id",
              description: "Delete a invoice_booking",
              delete: true
            },
            {
              name: "id",
              resources: {
                invoice: {
                  name: "invoice",
                  description: "Get a invoice for this invoice_booking",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                booking: {
                  name: "booking",
                  description: "Get a booking for this invoice_booking",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                invoice_booking_discounts: {
                  name: "invoice_booking_discounts",
                  description: "List of invoice_booking_discounts for this invoice_booking",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Billing::InvoiceBookingDiscount": {
          name: "invoice_booking_discounts",
          description: "Create a invoice_booking_discount",
          create_options: [
            {
              optional_relationships: [
                "invoice_booking"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              amount: {
                type: "BigDecimal",
                coerce_with: "APICoercions::MoneyToBigDecimal",
                desc: "Amount of this invoice_booking_discount"
              },
              comment: {
                type: "String",
                desc: "Comment of this invoice_booking_discount"
              },
              code: {
                type: "Symbol",
                values: [
                  "sales",
                  "promotion"
                ],
                desc: "sales and promotion"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a invoice_booking_discount",
              get: true
            },
            {
              name: "id",
              description: "Update a invoice_booking_discount",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "invoice_booking"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  amount: {
                    type: "BigDecimal",
                    coerce_with: "APICoercions::MoneyToBigDecimal",
                    desc: "Amount of this invoice_booking_discount"
                  },
                  comment: {
                    type: "String",
                    desc: "Comment of this invoice_booking_discount"
                  },
                  code: {
                    type: "Symbol",
                    values: [
                      "sales",
                      "promotion"
                    ],
                    desc: "sales and promotion"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a invoice_booking_discount",
              delete: true
            },
            {
              name: "id",
              resources: {
                invoice_booking: {
                  name: "invoice_booking",
                  description: "Get a invoice_booking for this invoice_booking",
                  get: true
                }
              }
            }
          ]
        },
        "Billing::InvoiceCoupon": {
          name: "invoice_coupons",
          description: "Returns all invoice_coupons",
          create_options: [
            {
              required_relationships: [
                "invoice",
                "coupon"
              ]
            }
          ],
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a invoice_coupon",
              get: true
            },
            {
              name: "id",
              description: "Delete a invoice_coupon",
              delete: true
            }
          ]
        },
        "Billing::InvoiceProductPurchaseDiscount": {
          name: "invoice_product_purchase_discounts",
          description: "Returns all invoice_product_purchase_discounts",
          create_options: [
            {
              optional_relationships: [
                "invoice_product_purchase"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              amount: {
                type: "BigDecimal",
                coerce_with: "APICoercions::MoneyToBigDecimal",
                desc: "Amount of this invoice_product_purchase_discount"
              },
              comment: {
                type: "String",
                desc: "Comment of this invoice_product_purchase_discount"
              },
              code: {
                type: "Symbol",
                values: [
                  "promotion",
                  "damaged",
                  "other"
                ],
                desc: "promotion, damaged or other"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a invoice_product_purchase_discount",
              get: true
            },
            {
              name: "id",
              description: "Update a invoice_product_purchase_discount",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "invoice_product_purchase"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  amount: {
                    type: "BigDecimal",
                    coerce_with: "APICoercions::MoneyToBigDecimal",
                    desc: "Amount of this invoice_product_purchase_discount"
                  },
                  comment: {
                    type: "String",
                    desc: "Comment of this invoice_product_purchase_discount"
                  },
                  code: {
                    type: "Symbol",
                    values: [
                      "promotion",
                      "damaged",
                      "other"
                    ],
                    desc: "promotion, damaged or other"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a invoice_product_purchase_discount",
              delete: true
            },
            {
              name: "id",
              resources: {
                invoice_product_purchase: {
                  name: "invoice_product_purchase",
                  description: "Get a invoice_product_purchase for this invoice_product_purchase_discount",
                  get: true
                }
              }
            }
          ]
        },
        "Billing::InvoiceProductPurchase": {
          name: "invoice_product_purchases",
          description: "Returns all invoice_product_purchases",
          create_options: [
            {
              required_relationships: [
                "invoice",
                "product_sku_trait_value"
              ]
            }
          ],
          create_params: {
            requires: {
              quantity: {
                type: "Integer",
                desc: "Quantity of this invoice_product_purchase"
              }
            },
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a invoice_product_purchase",
              get: true
            },
            {
              name: "id",
              description: "Update a invoice_product_purchase",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "invoice",
                    "product_sku_trait_value"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  quantity: {
                    type: "Integer",
                    desc: "Quantity of this invoice_product_purchase"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a invoice_product_purchase",
              delete: true
            },
            {
              name: "id",
              resources: {
                invoice_product_purchase_discounts: {
                  name: "invoice_product_purchase_discounts",
                  description: "List of invoice_product_purchase_discounts for this invoice_product_purchase",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                invoice: {
                  name: "invoice",
                  description: "Get a invoice for this invoice_product_purchase",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                product_sku_trait_value: {
                  name: "product_sku_trait_value",
                  description: "Get a product_sku_trait_value for this invoice_product_purchase",
                  get: true
                }
              }
            }
          ]
        },
        "Billing::InvoiceProductReturn": {
          name: "invoice_product_returns",
          description: "Returns all invoice_product_returns",
          create_options: [
            {
              optional_relationships: [
                "invoice",
                "invoice_product_purchase"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              quantity: {
                type: "Integer",
                desc: "Quantity of this invoice_product_return"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a invoice_product_return",
              get: true
            },
            {
              name: "id",
              description: "Update a invoice_product_return",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "invoice",
                    "invoice_product_purchase"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  quantity: {
                    type: "Integer",
                    desc: "Quantity of this invoice_product_return"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a invoice_product_return",
              delete: true
            },
            {
              name: "id",
              resources: {
                invoice: {
                  name: "invoice",
                  description: "Get a invoice for this invoice_product_return",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                invoice_product_purchase: {
                  name: "invoice_product_purchase",
                  description: "Get a invoice_product_purchase for this invoice_product_return",
                  get: true
                }
              }
            }
          ]
        },
        "Billing::InvoiceSubscriptionPrepayment": {
          name: "invoice_subscription_prepayments",
          description: "Returns all invoice_subscription_prepayments",
          create_options: [
            {
              optional_relationships: [
                "invoice",
                "subscription"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              amount: {
                type: "BigDecimal",
                coerce_with: "APICoercions::MoneyToBigDecimal",
                desc: "Amount of this invoice_subscription_prepayment"
              },
              refundable: {
                type: "Virtus::Attribute::Boolean",
                desc: "Is this prepayment refundable"
              },
              description: {
                type: "String",
                desc: "Description of why this repayment was made. For example a promotion or a deposit paid."
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a invoice_subscription_prepayment",
              get: true
            },
            {
              name: "id",
              description: "Update a invoice_subscription_prepayment",
              update_params: {
                requires: {},
                optional: {
                  amount: {
                    type: "BigDecimal",
                    coerce_with: "APICoercions::MoneyToBigDecimal",
                    desc: "Amount of this invoice_subscription_prepayment"
                  },
                  refundable: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Is this prepayment refundable"
                  },
                  description: {
                    type: "String",
                    desc: "Description of why this repayment was made. For example a promotion or a deposit paid."
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a invoice_subscription_prepayment",
              delete: true
            },
            {
              name: "id",
              resources: {
                invoice: {
                  name: "invoice",
                  description: "Get a invoice for this invoice_subscription_prepayment",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                subscription: {
                  name: "subscription",
                  description: "Get a subscription for this invoice_subscription_prepayment",
                  get: true
                }
              }
            }
          ]
        },
        "Billing::InvoiceVoucher": {
          name: "invoice_vouchers",
          description: "Returns all invoice_vouchers",
          create_options: [
            {
              optional_relationships: [
                "invoice",
                "voucher"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              code: {
                type: "String",
                desc: "Code of this invoice_voucher"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a invoice_voucher",
              get: true
            },
            {
              name: "id",
              description: "Update a invoice_voucher",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "invoice",
                    "voucher"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  code: {
                    type: "String",
                    desc: "Code of this invoice_voucher"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a invoice_voucher",
              delete: true
            },
            {
              name: "id",
              resources: {
                invoice: {
                  name: "invoice",
                  description: "Get a invoice for this invoice_voucher",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                voucher: {
                  name: "voucher",
                  description: "Get a voucher for this invoice_voucher",
                  get: true
                }
              }
            }
          ]
        },
        "Projects::Execution": {
          name: "executions",
          description: "Record executions which occur while working on a project",
          create_options: [
            {
              required_relationships: [
                "project"
              ],
              optional_relationships: [
                "user",
                "step"
              ]
            }
          ],
          create_params: {
            requires: {
              initiator: {
                type: "Symbol",
                values: [
                  "keyboard_shortcut",
                  "enter",
                  "button",
                  "step_complete"
                ],
                desc: "keyboard_shortcut, enter, button or step_complete"
              }
            },
            optional: {}
          },
          post: true
        },
        "Projects::Mistake": {
          name: "mistakes",
          description: "Record errors which occur while working on a project",
          create_options: [
            {
              required_relationships: [
                "project"
              ],
              optional_relationships: [
                "user",
                "step"
              ]
            }
          ],
          create_params: {
            requires: {
              code: {
                type: "Symbol",
                values: [
                  "unknown_method",
                  "invalid_parameter"
                ],
                desc: "unknown_method and invalid_parameter"
              }
            },
            optional: {}
          },
          post: true
        },
        "Projects::Minute": {
          name: "minutes",
          description: "To summarize the users activity while editing this project in the last minute",
          create_options: [
            {
              required_relationships: [
                "project"
              ],
              optional_relationships: [
                "step"
              ]
            }
          ],
          create_params: {
            requires: {
              minute: {
                type: "Integer",
                desc: "the current minute, should start with 1 and be incremented by the client with each subsequent request. This should be set back to one when the project or step changes."
              },
              seconds: {
                type: "Integer",
                desc: "the number of seconds in this period (because the client creates all the data, we do not want to assume an exact minute)"
              }
            },
            optional: {
              key_presses: {
                type: "Integer",
                default: 0,
                desc: "the number of key presses in the preceding minute"
              },
              mouse_distance: {
                type: "Integer",
                default: 0,
                desc: "the number of mouse distance in the preceding minute"
              },
              taps_and_clicks: {
                type: "Integer",
                default: 0,
                desc: "the number of taps and clicks which occured in the preceding minute"
              },
              characters_added: {
                type: "Integer",
                default: 0,
                desc: "the number of characters added in the preceding minute"
              },
              characters_removed: {
                type: "Integer",
                default: 0,
                desc: "the number of characters removed in the preceding minute"
              }
            }
          },
          post: true
        },
        "Leads::Lead": {
          name: "leads",
          description: "Get a list of leads",
          create_options: [
            {
              optional_relationships: [
                "public_session",
                "location",
                {
                  name: "owner",
                  as: "user"
                }
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              source_code: {
                type: "Symbol",
                desc: "left here for compatibility, use source_codes instead"
              },
              source_codes: {
                type: "Array"
              },
              email: {
                type: "String",
                desc: "the user provided email address"
              },
              name: {
                type: "String",
                desc: "the user provided name"
              },
              phone: {
                type: "String",
                desc: "the user provided phone"
              },
              address1: {
                type: "String",
                desc: "the user provided address1 of this lead"
              },
              address2: {
                type: "String",
                desc: "the user provided address2 of this lead"
              },
              city: {
                type: "String",
                desc: "the user provided city of this lead"
              },
              region: {
                type: "String",
                desc: "the user provided state of this lead"
              },
              zip_code: {
                type: "String",
                desc: "the user provided zip code of this lead"
              },
              country_code: {
                type: "String",
                desc: "the user provided country of this lead"
              },
              referral_code: {
                type: "String",
                desc: "optional referral code if this organization was referred"
              },
              comments: {
                type: "String",
                desc: "optional message relevant to this lead"
              },
              first_journey: {
                type: "String",
                desc: "optional message relevant to this lead"
              }
            }
          },
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search the leads"
              },
              location_id: {
                type: "String",
                desc: "get leads for location"
              },
              location_ids: {
                type: "Array",
                desc: "get leads for multiple locations"
              },
              stage: {
                type: "String",
                desc: "a single stage"
              },
              stages: {
                type: "Array",
                desc: "array of stages"
              },
              source_code: {
                type: "Symbol",
                values: [
                  "facebook",
                  "instagram",
                  "snapchat",
                  "twitter",
                  "google",
                  "bing",
                  "yahoo",
                  "baidu",
                  "referral_program",
                  "event",
                  "partner",
                  "magazine_or_newspaper",
                  "online_video",
                  "tv",
                  "radio",
                  "podcast",
                  "billboard",
                  "word_of_mouth",
                  "drop_in",
                  "other",
                  "studio_event",
                  "external_event",
                  "field_trip",
                  "birthday_party",
                  "school_partnership"
                ],
                desc: "a single source code"
              },
              source_codes: {
                type: "Array",
                desc: "array of source codes"
              },
              owner_id: {
                type: "String",
                desc: "leads owned by a certain user"
              },
              owner_ids: {
                type: "Array",
                desc: "leads owned by certain users"
              },
              interest: {
                type: "String",
                desc: "a single interest"
              },
              interests: {
                type: "Array",
                desc: "array of interests"
              },
              revisit_after: {
                type: "Date",
                desc: "revisit at date to consider"
              },
              all_leads: {
                type: "Virtus::Attribute::Boolean",
                desc: "show all leads"
              },
              most_recent: {
                type: "Virtus::Attribute::Boolean",
                desc: "order by created_at desc"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "priority",
            "revisit_at",
            "latest_inbound_communication_at",
            "latest_outbound_communication_at"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a specific lead",
              get: true
            },
            {
              name: "id",
              description: "Update a lead",
              update_options: [
                {
                  require_comment: true,
                  optional_relationships: [
                    "location",
                    {
                      name: "owner",
                      as: "user"
                    }
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  email: {
                    type: "String",
                    desc: "the user provided email address"
                  },
                  name: {
                    type: "String",
                    desc: "the user provided name"
                  },
                  phone: {
                    type: "String",
                    desc: "the user provided phone"
                  },
                  zip_code: {
                    type: "String",
                    desc: "the user provided zip code"
                  },
                  source_code: {
                    type: "Symbol",
                    desc: "left here for compatibility, use source_codes instead"
                  },
                  source_codes: {
                    type: "Array"
                  },
                  lost_code: {
                    type: "Symbol",
                    values: [
                      "not_interested",
                      "wrong_age",
                      "distance",
                      "price",
                      "schedule",
                      "unsatisfied_with_trial",
                      "unreachable",
                      "not_needed",
                      "other"
                    ],
                    desc: "can be null, not_interested, wrong_age, distance, price, schedule, unsatisfied_with_trial, unreachable, not_needed or other"
                  },
                  stage: {
                    type: "Symbol",
                    desc: "can be not_valid, active, negotiating, won, waiting or lost"
                  },
                  revisit_at: {
                    type: "Time",
                    desc: "when to sleep this lead until"
                  },
                  referral_code: {
                    type: "String",
                    desc: "optional referral code if this organization was referred"
                  },
                  comments: {
                    type: "String",
                    desc: "optional message relevant to this lead"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                organization: {
                  name: "organization",
                  description: "Get a organization for this lead",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                lead_interests: {
                  name: "lead_interests",
                  description: "List of lead_interests for this lead",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Leads::Task": {
          name: "lead_tasks",
          description: "Returns all lead_tasks",
          create_options: [
            {
              required_relationships: [
                "organization"
              ],
              optional_relationships: [
                "staff_team",
                {
                  name: "assignee",
                  as: "user"
                }
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              instruction: {
                type: "String",
                desc: "Instruction of this lead_task"
              },
              priority: {
                type: "Symbol",
                values: [
                  "low",
                  "medium",
                  "high"
                ],
                desc: "low, medium or high"
              },
              due_at: {
                type: "Time",
                desc: "Due At of this lead_task"
              }
            }
          },
          filter_options: [
            {
              deletable: true,
              completable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search by string"
              },
              ids: {
                type: "Array"
              },
              location_id: {
                type: "String",
                desc: "get leads for location"
              },
              author_id: {
                type: "UUID"
              },
              assignor_id: {
                type: "UUID"
              },
              assignee_id: {
                type: "UUID"
              },
              staff_team_id: {
                type: "UUID"
              },
              due_after: {
                type: "Date",
                desc: "filter by due date"
              },
              due_before: {
                type: "Date",
                desc: "filter by due date"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "due_at",
            "completed_at",
            "updated_at"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a task",
              get: true
            },
            {
              name: "id",
              description: "Update a lead_task",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "staff_team",
                    {
                      name: "assignee",
                      as: "user"
                    }
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  instruction: {
                    type: "String",
                    desc: "Instruction of this task"
                  },
                  due_at: {
                    type: "Time",
                    desc: "Due At of this task"
                  },
                  completed: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Set to true when this task is completed"
                  },
                  priority: {
                    type: "Symbol",
                    values: [
                      "low",
                      "medium",
                      "high"
                    ],
                    desc: "low, medium or high"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a lead_task",
              delete: true
            }
          ]
        },
        "Leads::LeadInterest": {
          name: "lead_interests",
          description: "Returns all lead_interests",
          create_options: [
            {
              required_relationships: [
                "lead",
                "interest"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {}
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a lead_interest",
              get: true
            },
            {
              name: "id",
              description: "Delete a lead interest",
              delete: true
            }
          ]
        },
        "Library::Category": {
          name: "library_categories",
          description: "Returns all library_categories",
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this category"
              },
              icon_name: {
                type: "String",
                desc: "Icon for this category"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a library_category",
              delete: true
            },
            {
              name: "id",
              description: "Get a category",
              get: true
            },
            {
              name: "id",
              description: "Update a library_category",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this library_category"
                  },
                  icon_name: {
                    type: "String",
                    desc: "Icon for this category"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                library_objects: {
                  name: "library_objects",
                  description: "List of objects for this category",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search the object name"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Library::EngineConfigurationOption": {
          name: "library_engine_configuration_options",
          description: "Returns all library_engine_configuration_options",
          create_options: [
            {
              required_relationships: [
                "library_engine_configuration_template"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this engine_configuration_option"
              },
              description: {
                type: "String",
                desc: "Description of this engine_configuration_option_version"
              },
              default_value: {
                type: "String",
                desc: "Optional default value for this configuration option"
              },
              is_array: {
                type: "Virtus::Attribute::Boolean",
                desc: "Is Array of this engine_configuration_option_version"
              },
              is_required: {
                type: "Virtus::Attribute::Boolean",
                desc: "Is Array of this engine_configuration_option_version"
              },
              validation_regex: {
                type: "String",
                desc: "Validation Regex of this engine_configuration_option_version"
              },
              attachment_mime_types: {
                type: "Array",
                desc: "Attachment Mime Types of this engine_configuration_option_version"
              },
              attachment_max_kilobytes: {
                type: "Integer",
                desc: "Attachment Max Kilobytes of this engine_configuration_option_version"
              },
              number_format: {
                type: "String",
                desc: "Number Format of this engine_configuration_option_version"
              },
              validate_greater_than: {
                type: "Integer",
                desc: "Validate Greater Than of this engine_configuration_option_version"
              },
              validate_greater_than_or_equal: {
                type: "Integer",
                desc: "Validate Greater Than Or Equal of this engine_configuration_option_version"
              },
              validate_less_than: {
                type: "Integer",
                desc: "Validate Less Than of this engine_configuration_option_version"
              },
              validate_less_than_or_equal: {
                type: "Integer",
                desc: "Validate Less Than Or Equal of this engine_configuration_option_version"
              },
              expected_type: {
                type: "Symbol",
                values: [
                  "string",
                  "integer",
                  "float",
                  "boolean",
                  "attachment",
                  "svg"
                ],
                desc: "string, integer, float, boolean, attachment or svg"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a engine_configuration_option",
              get: true
            },
            {
              name: "id",
              description: "Delete a library_engine_configuration_option",
              delete: true
            },
            {
              name: "id",
              description: "Update a library_engine_configuration_option",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  description: {
                    type: "String",
                    desc: "Description of this engine_configuration_option_version"
                  },
                  default_value: {
                    type: "String",
                    desc: "Optional default value for this configuration option"
                  },
                  is_array: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Is Array of this engine_configuration_option_version"
                  },
                  is_required: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Is Array of this engine_configuration_option_version"
                  },
                  validation_regex: {
                    type: "String",
                    desc: "Validation Regex of this engine_configuration_option_version"
                  },
                  attachment_mime_types: {
                    type: "Array",
                    desc: "Attachment Mime Types of this engine_configuration_option_version"
                  },
                  attachment_max_kilobytes: {
                    type: "Integer",
                    desc: "Attachment Max Kilobytes of this engine_configuration_option_version"
                  },
                  number_format: {
                    type: "String",
                    desc: "Number Format of this engine_configuration_option_version"
                  },
                  validate_greater_than: {
                    type: "Integer",
                    desc: "Validate Greater Than of this engine_configuration_option_version"
                  },
                  validate_greater_than_or_equal: {
                    type: "Integer",
                    desc: "Validate Greater Than Or Equal of this engine_configuration_option_version"
                  },
                  validate_less_than: {
                    type: "Integer",
                    desc: "Validate Less Than of this engine_configuration_option_version"
                  },
                  validate_less_than_or_equal: {
                    type: "Integer",
                    desc: "Validate Less Than Or Equal of this engine_configuration_option_version"
                  },
                  expected_type: {
                    type: "Symbol",
                    values: [
                      "string",
                      "integer",
                      "float",
                      "boolean",
                      "attachment",
                      "svg"
                    ],
                    desc: "string, integer, float, boolean, attachment or svg"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Library::EngineConfigurationTemplate": {
          name: "library_engine_configuration_templates",
          description: "Returns all library_engine_configuration_templates",
          create_options: [
            {
              required_relationships: [
                "library_engine"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this engine_configuration_template"
              },
              is_unique: {
                type: "Virtus::Attribute::Boolean",
                desc: "Is Unique of this engine_configuration_template_version"
              },
              is_required: {
                type: "Virtus::Attribute::Boolean",
                desc: "Is Required of this engine_configuration_template_version"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a engine_configuration_template",
              get: true
            },
            {
              name: "id",
              description: "Delete a library_engine_configuration_template",
              delete: true
            },
            {
              name: "id",
              description: "Update a library_engine_configuration_template",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  is_unique: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Is Unique of this engine_configuration_template_version"
                  },
                  is_required: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Is Required of this engine_configuration_template_version"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                library_engine_configuration_options: {
                  name: "library_engine_configuration_options",
                  description: "List of engine_configuration_options for this engine_configuration_template",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search by name"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Library::EngineModule": {
          name: "library_engine_modules",
          description: "Returns all library_engine_modules",
          create_options: [
            {
              required_relationships: [
                "library_engine"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this engine_module"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a engine_module",
              get: true
            },
            {
              name: "id",
              description: "Delete a library_engine_module",
              delete: true
            },
            {
              name: "id",
              description: "Update a library_engine_module",
              update_options: [
                {
                  deletable: true
                }
              ],
              put: true
            }
          ]
        },
        "Library::EngineEventModule": {
          name: "library_engine_event_modules",
          description: "Returns all library_engine_event_modules",
          create_options: [
            {
              required_relationships: [
                "library_engine_event",
                "library_engine_module"
              ]
            }
          ],
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a library_engine_event_module",
              delete: true
            },
            {
              name: "id",
              description: "Get a engine_event_module",
              get: true
            },
            {
              name: "id",
              description: "Update a library_engine_event_module",
              update_options: [
                {
                  deletable: true
                }
              ],
              put: true
            }
          ]
        },
        "Library::EngineEventTip": {
          name: "library_engine_event_tips",
          description: "Returns all library_engine_event_tips",
          create_options: [
            {
              required_relationships: [
                "library_engine_event"
              ]
            }
          ],
          create_params: {
            requires: {
              tip: {
                type: "String",
                desc: "The tip"
              }
            },
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a library_engine_event_tip",
              delete: true
            },
            {
              name: "id",
              description: "Get a engine_event_tip",
              get: true
            },
            {
              name: "id",
              description: "Update a library_engine_event_tip",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  tip: {
                    type: "String",
                    desc: "The tip"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Library::EngineEventParameter": {
          name: "library_engine_event_parameters",
          description: "Returns all library_engine_event_parameters",
          create_options: [
            {
              required_relationships: [
                "library_engine_event"
              ],
              optional_relationships: [
                "library_widget"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this engine_event_parameter"
              },
              description: {
                type: "String",
                desc: "Description of this library_engine_event_parameter_version"
              },
              default_value: {
                type: "String",
                desc: "An optional default value for this paramater. This value is used when this parameter is locked"
              },
              example_value: {
                type: "String",
                desc: "An optional example value for this paramater. This value is used when highlighting methods or providing examples on trading cards and in the library"
              },
              validate_greater_than: {
                type: "Integer",
                desc: "Validate Greater Than of this library_engine_event_parameter_version"
              },
              validate_greater_than_or_equal: {
                type: "Integer",
                desc: "Validate Greater Than Or Equal of this library_engine_event_parameter_version"
              },
              validate_less_than: {
                type: "Integer",
                desc: "Validate Less Than of this library_engine_event_parameter_version"
              },
              validate_less_than_or_equal: {
                type: "Integer",
                desc: "Validate Less Than Or Equal of this library_engine_event_parameter_version"
              },
              validate_whole_number: {
                type: "Virtus::Attribute::Boolean",
                desc: "Validate Whole Number of this library_engine_event_parameter_version"
              },
              position: {
                type: "Integer",
                desc: "Position of this library_engine_event_parameter_version"
              },
              class_name: {
                type: "Symbol",
                values: [
                  "Text",
                  "Number",
                  "List",
                  "TrueFalse",
                  "any"
                ],
                desc: "Text, Number, List, TrueFalse or any"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a engine_event_parameter",
              get: true
            },
            {
              name: "id",
              description: "Delete a library_engine_event_parameter",
              delete: true
            },
            {
              name: "id",
              description: "Update a library_engine_event_parameter",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  description: {
                    type: "String",
                    desc: "Description of this library_engine_event_parameter_version"
                  },
                  default_value: {
                    type: "String",
                    desc: "An optional default value for this paramater. This value is used when this parameter is locked"
                  },
                  example_value: {
                    type: "String",
                    desc: "An optional example value for this paramater. This value is used when highlighting methods or providing examples on trading cards and in the library"
                  },
                  validate_greater_than: {
                    type: "Integer",
                    desc: "Validate Greater Than of this library_engine_event_parameter_version"
                  },
                  validate_greater_than_or_equal: {
                    type: "Integer",
                    desc: "Validate Greater Than Or Equal of this library_engine_event_parameter_version"
                  },
                  validate_less_than: {
                    type: "Integer",
                    desc: "Validate Less Than of this library_engine_event_parameter_version"
                  },
                  validate_less_than_or_equal: {
                    type: "Integer",
                    desc: "Validate Less Than Or Equal of this library_engine_event_parameter_version"
                  },
                  validate_whole_number: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Validate Whole Number of this library_engine_event_parameter_version"
                  },
                  position: {
                    type: "Integer",
                    desc: "Position of this library_engine_event_parameter_version"
                  },
                  class_name: {
                    type: "Symbol",
                    values: [
                      "Text",
                      "Number",
                      "List",
                      "TrueFalse",
                      "any"
                    ],
                    desc: "Text, Number, List, TrueFalse or any"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Library::EngineEvent": {
          name: "library_engine_events",
          description: "Returns all library_engine_events",
          create_options: [
            {
              optional_relationships: [
                "library_engine"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this engine_event"
              },
              description: {
                type: "String",
                desc: "Description of this library_engine_event_version"
              },
              javascript: {
                type: "String",
                desc: "Javascript of this library_engine_event_version"
              },
              key: {
                type: "String",
                desc: "Key of this library_engine_event_version"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a engine_event",
              get: true
            },
            {
              name: "id",
              description: "Delete a library_engine_event",
              delete: true
            },
            {
              name: "id",
              description: "Update a library_engine_event",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  description: {
                    type: "String",
                    desc: "Description of this library_engine_event_version"
                  },
                  javascript: {
                    type: "String",
                    desc: "Javascript of this library_engine_event_version"
                  },
                  key: {
                    type: "String",
                    desc: "Key of this library_engine_event_version"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                library_engine_event_modules: {
                  name: "library_engine_event_modules",
                  description: "List of engine_event_modules for this engine_event",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_engine_event_tips: {
                  name: "library_engine_event_tips",
                  description: "List of engine_event_tips for this engine_event",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_engine_event_parameters: {
                  name: "library_engine_event_parameters",
                  description: "List of engine_event_parameters for this engine_event",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Library::EngineMethodModule": {
          name: "library_engine_method_modules",
          description: "Returns all library_engine_method_modules",
          create_options: [
            {
              required_relationships: [
                "library_engine_method",
                "library_engine_module"
              ]
            }
          ],
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a library_engine_method_module",
              delete: true
            },
            {
              name: "id",
              description: "Get a engine_method_module",
              get: true
            },
            {
              name: "id",
              description: "Update a library_engine_method_module",
              update_options: [
                {
                  deletable: true
                }
              ],
              put: true
            }
          ]
        },
        "Library::EngineMethodTip": {
          name: "library_engine_method_tips",
          description: "Returns all library_engine_method_tips",
          create_options: [
            {
              required_relationships: [
                "library_engine_method"
              ]
            }
          ],
          create_params: {
            requires: {
              tip: {
                type: "String",
                desc: "The tip"
              }
            },
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a library_engine_method_tip",
              delete: true
            },
            {
              name: "id",
              description: "Get a engine_method_tip",
              get: true
            },
            {
              name: "id",
              description: "Update a library_engine_method_tip",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  tip: {
                    type: "String",
                    desc: "The tip"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Library::EngineMethodParameter": {
          name: "library_engine_method_parameters",
          description: "Returns all library_engine_method_parameters",
          create_options: [
            {
              required_relationships: [
                "library_engine_method"
              ],
              optional_relationships: [
                "library_widget",
                "library_engine_configuration_option"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this engine_method_parameter"
              },
              description: {
                type: "String",
                desc: "Description of this library_engine_method_parameter_version"
              },
              default_value: {
                type: "String",
                desc: "An optional default value for this paramater. This value is used when this parameter is locked"
              },
              example_value: {
                type: "String",
                desc: "An optional example value for this paramater. This value is used when highlighting methods or providing examples on trading cards and in the library"
              },
              validate_greater_than: {
                type: "Integer",
                desc: "Validate Greater Than of this library_engine_method_parameter_version"
              },
              validate_greater_than_or_equal: {
                type: "Integer",
                desc: "Validate Greater Than Or Equal of this library_engine_method_parameter_version"
              },
              validate_less_than: {
                type: "Integer",
                desc: "Validate Less Than of this library_engine_method_parameter_version"
              },
              validate_less_than_or_equal: {
                type: "Integer",
                desc: "Validate Less Than Or Equal of this library_engine_method_parameter_version"
              },
              validate_whole_number: {
                type: "Virtus::Attribute::Boolean",
                desc: "Validate Whole Number of this library_engine_method_parameter_version"
              },
              position: {
                type: "Integer",
                desc: "Position of this library_engine_method_parameter_version"
              },
              class_name: {
                type: "Symbol",
                values: [
                  "Text",
                  "Number",
                  "List",
                  "TrueFalse",
                  "any"
                ],
                desc: "Text, Number, List, TrueFalse or any"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a engine_method_parameter",
              get: true
            },
            {
              name: "id",
              description: "Delete a library_engine_method_parameter",
              delete: true
            },
            {
              name: "id",
              description: "Update a library_engine_method_parameter",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "library_widget",
                    "library_engine_configuration_option"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  description: {
                    type: "String",
                    desc: "Description of this library_engine_method_parameter_version"
                  },
                  default_value: {
                    type: "String",
                    desc: "An optional default value for this paramater. This value is used when this parameter is locked"
                  },
                  example_value: {
                    type: "String",
                    desc: "An optional example value for this paramater. This value is used when highlighting methods or providing examples on trading cards and in the library"
                  },
                  validate_greater_than: {
                    type: "Integer",
                    desc: "Validate Greater Than of this library_engine_method_parameter_version"
                  },
                  validate_greater_than_or_equal: {
                    type: "Integer",
                    desc: "Validate Greater Than Or Equal of this library_engine_method_parameter_version"
                  },
                  validate_less_than: {
                    type: "Integer",
                    desc: "Validate Less Than of this library_engine_method_parameter_version"
                  },
                  validate_less_than_or_equal: {
                    type: "Integer",
                    desc: "Validate Less Than Or Equal of this library_engine_method_parameter_version"
                  },
                  validate_whole_number: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Validate Whole Number of this library_engine_method_parameter_version"
                  },
                  position: {
                    type: "Integer",
                    desc: "Position of this library_engine_method_parameter_version"
                  },
                  class_name: {
                    type: "Symbol",
                    values: [
                      "Text",
                      "Number",
                      "List",
                      "TrueFalse",
                      "any"
                    ],
                    desc: "Text, Number, List, TrueFalse or any"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Library::EngineMethod": {
          name: "library_engine_methods",
          description: "Returns all library_engine_methods",
          create_options: [
            {
              required_relationships: [
                "library_engine"
              ],
              optional_relationships: [
                "library_engine_configuration_option"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this engine_method"
              },
              internal: {
                type: "Virtus::Attribute::Boolean",
                desc: "Internal of this library_engine_method"
              },
              description: {
                type: "String",
                desc: "Description of this library_engine_method_version"
              },
              javascript: {
                type: "String",
                desc: "Javascript of this library_engine_method_version"
              },
              return_type: {
                type: "Symbol",
                values: [
                  "Text",
                  "Number",
                  "List",
                  "TrueFalse",
                  "promise",
                  "any",
                  "self"
                ],
                desc: "Text, Number, List, TrueFalse, promise, any or self"
              },
              engine_configuration_option_value: {
                type: "String",
                desc: "A value this method can set for the coresponding engine_configuration_option_id"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              ids: {
                type: "Array"
              },
              q: {
                type: "String",
                desc: "search the method name"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a engine_method",
              get: true
            },
            {
              name: "id",
              description: "Delete a library_engine_method",
              delete: true
            },
            {
              name: "id",
              description: "Update a library_engine_method",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "library_engine_configuration_option"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  description: {
                    type: "String",
                    desc: "Description of this library_engine_method_version"
                  },
                  javascript: {
                    type: "String",
                    desc: "Javascript of this library_engine_method_version"
                  },
                  return_type: {
                    type: "Symbol",
                    values: [
                      "Text",
                      "Number",
                      "List",
                      "TrueFalse",
                      "promise",
                      "any",
                      "self"
                    ],
                    desc: "Text, Number, List, TrueFalse, promise, any or self"
                  },
                  engine_configuration_option_value: {
                    type: "String",
                    desc: "A value this method can set for the coresponding engine_configuration_option_id"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                library_engine_method_modules: {
                  name: "library_engine_method_modules",
                  description: "List of engine_method_modules for this engine_method",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_engine_method_tips: {
                  name: "library_engine_method_tips",
                  description: "List of engine_method_tips for this engine_method",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_engine_method_parameters: {
                  name: "library_engine_method_parameters",
                  description: "List of engine_method_parameters for this engine_method",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Library::Engine": {
          name: "library_engines",
          description: "Returns all library_engines",
          create_options: [
            {
              optional_relationships: [
                {
                  name: "library_extends_engine",
                  as: "library_engine"
                }
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this engine"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              ids: {
                type: "Array"
              },
              q: {
                type: "String",
                desc: "search the engine name"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a engine",
              get: true
            },
            {
              name: "id",
              resources: {
                library_engine_versions: {
                  name: "library_engine_versions",
                  description: "List of engine_versions for this engine",
                  filter_options: [
                    {
                      deletable: true,
                      publishable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              description: "Delete a library_engine",
              delete: true
            },
            {
              name: "id",
              description: "Update a library_engine",
              update_options: [
                {
                  deletable: true,
                  publishable: true,
                  optional_relationships: [
                    {
                      name: "library_extends_engine_version",
                      as: "library_engine_version"
                    }
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  changelog: {
                    type: "String",
                    desc: "Changelog of this library_engine_version"
                  },
                  significance: {
                    type: "Symbol",
                    values: [
                      "major",
                      "minor"
                    ],
                    desc: "major and minor"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                library_engine_configuration_options: {
                  name: "library_engine_configuration_options",
                  description: "List of engine_configuration_options for this engine",
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search by string"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_engine_configuration_templates: {
                  name: "library_engine_configuration_templates",
                  description: "List of engine_configuration_templates for this engine",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_engine_events: {
                  name: "library_engine_events",
                  description: "List of engine_events for this engine",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search the event name"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_engine_methods: {
                  name: "library_engine_methods",
                  description: "List of engine_methods for this engine",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search the method name"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_engine_modules: {
                  name: "library_engine_modules",
                  description: "List of engine_modules for this engine",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search the module name"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_objects: {
                  name: "library_objects",
                  description: "List of objects for this engine",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Library::ObjectConfigurationTemplate": {
          name: "library_object_configuration_templates",
          description: "Returns all library_object_configuration_templates",
          create_options: [
            {
              required_relationships: [
                "library_engine_configuration_template",
                "library_object"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this template (for templates which are not unique)"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a library_object_configuration_template",
              delete: true
            },
            {
              name: "id",
              description: "Get a object_configuration_template",
              get: true
            },
            {
              name: "id",
              description: "Update a library_object_configuration_template",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this template (for templates which are not unique)"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                library_engine_configuration_options: {
                  name: "library_engine_configuration_options",
                  description: "List of engine_configuration_options for this object_configuration_template",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search by name"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_object_configuration_values: {
                  name: "library_object_configuration_values",
                  description: "List of object_configuration_values for this object_configuration_template",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Library::ObjectConfigurationValue": {
          name: "library_object_configuration_values",
          description: "Returns all library_object_configuration_values",
          create_options: [
            {
              optional_relationships: [
                "library_object_constant"
              ],
              required_relationships: [
                "library_engine_configuration_option",
                "library_object_configuration_template"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              attachment: {
                type: "String",
                desc: "Should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              },
              value: {
                type: "String",
                desc: "Value of this configuration_value"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a library_object_configuration_value",
              delete: true
            },
            {
              name: "id",
              description: "Get a configuration_value",
              get: true
            },
            {
              name: "id",
              description: "Update a library_object_configuration_value",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "library_object_constant"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  attachment: {
                    type: "String",
                    desc: "Should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  },
                  value: {
                    type: "String",
                    desc: "Value of this configuration_value"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Library::ObjectEventModule": {
          name: "library_object_event_modules",
          description: "Returns all library_object_event_modules",
          create_options: [
            {
              required_relationships: [
                "library_object_event",
                "library_engine_module"
              ]
            }
          ],
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a library_object_event_module",
              delete: true
            },
            {
              name: "id",
              description: "Get a object_event_module",
              get: true
            },
            {
              name: "id",
              description: "Update a library_object_event_module",
              update_options: [
                {
                  deletable: true
                }
              ],
              put: true
            }
          ]
        },
        "Library::ObjectEventTip": {
          name: "library_object_event_tips",
          description: "Returns all library_object_event_tips",
          create_options: [
            {
              required_relationships: [
                "library_object_event"
              ]
            }
          ],
          create_params: {
            requires: {
              tip: {
                type: "String",
                desc: "The tip"
              }
            },
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a library_object_event_tip",
              delete: true
            },
            {
              name: "id",
              description: "Get a object_event_tip",
              get: true
            },
            {
              name: "id",
              description: "Update a library_object_event_tip",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  tip: {
                    type: "String",
                    desc: "The tip"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Library::ObjectEventParameter": {
          name: "library_object_event_parameters",
          description: "Returns all library_object_event_parameters",
          create_options: [
            {
              required_relationships: [
                "library_object_event"
              ],
              optional_relationships: [
                "library_widget",
                "library_object_constant",
                "library_keyring"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this object_event_parameter"
              },
              description: {
                type: "String",
                desc: "Description of this library_object_event_parameter_version"
              },
              default_value: {
                type: "String",
                desc: "An optional default value for this paramater. This value is used when this parameter is locked"
              },
              example_value: {
                type: "String",
                desc: "An optional example value for this paramater. This value is used when highlighting methods or providing examples on trading cards and in the library"
              },
              validate_greater_than: {
                type: "Integer",
                desc: "Validate Greater Than of this library_object_event_parameter_version"
              },
              validate_greater_than_or_equal: {
                type: "Integer",
                desc: "Validate Greater Than Or Equal of this library_object_event_parameter_version"
              },
              validate_less_than: {
                type: "Integer",
                desc: "Validate Less Than of this library_object_event_parameter_version"
              },
              validate_less_than_or_equal: {
                type: "Integer",
                desc: "Validate Less Than Or Equal of this library_object_event_parameter_version"
              },
              validate_whole_number: {
                type: "Virtus::Attribute::Boolean",
                desc: "Validate Whole Number of this library_object_event_parameter_version"
              },
              position: {
                type: "Integer",
                desc: "Position of this library_object_event_parameter_version"
              },
              class_name: {
                type: "Symbol",
                values: [
                  "Text",
                  "Number",
                  "List",
                  "TrueFalse",
                  "any"
                ],
                desc: "Text, Number, List, TrueFalse or any"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a object_event_parameter",
              get: true
            },
            {
              name: "id",
              description: "Delete a library_object_event_parameter",
              delete: true
            },
            {
              name: "id",
              description: "Update a library_object_event_parameter",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "library_widget",
                    "library_object_constant",
                    "library_keyring"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  description: {
                    type: "String",
                    desc: "Description of this library_object_event_parameter_version"
                  },
                  default_value: {
                    type: "String",
                    desc: "An optional default value for this paramater. This value is used when this parameter is locked"
                  },
                  example_value: {
                    type: "String",
                    desc: "An optional example value for this paramater. This value is used when highlighting methods or providing examples on trading cards and in the library"
                  },
                  validate_greater_than: {
                    type: "Integer",
                    desc: "Validate Greater Than of this library_object_event_parameter_version"
                  },
                  validate_greater_than_or_equal: {
                    type: "Integer",
                    desc: "Validate Greater Than Or Equal of this library_object_event_parameter_version"
                  },
                  validate_less_than: {
                    type: "Integer",
                    desc: "Validate Less Than of this library_object_event_parameter_version"
                  },
                  validate_less_than_or_equal: {
                    type: "Integer",
                    desc: "Validate Less Than Or Equal of this library_object_event_parameter_version"
                  },
                  validate_whole_number: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Validate Whole Number of this library_object_event_parameter_version"
                  },
                  position: {
                    type: "Integer",
                    desc: "Position of this library_object_event_parameter_version"
                  },
                  class_name: {
                    type: "Symbol",
                    values: [
                      "Text",
                      "Number",
                      "List",
                      "TrueFalse",
                      "any"
                    ],
                    desc: "Text, Number, List, TrueFalse or any"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Library::ObjectEvent": {
          name: "library_object_events",
          description: "Returns all library_object_events",
          create_options: [
            {
              required_relationships: [
                "library_object"
              ],
              optional_relationships: [
                "library_keyring"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this object_event"
              },
              super_power: {
                type: "Virtus::Attribute::Boolean",
                desc: "Is this event flagged as a super_power"
              },
              description: {
                type: "String",
                desc: "Description of this library_object_event_version"
              },
              javascript: {
                type: "String",
                desc: "Javascript of this library_object_event_version"
              },
              key: {
                type: "String",
                desc: "Key of this library_object_event_version"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              ids: {
                type: "Array"
              },
              q: {
                type: "String",
                desc: "search the event name"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a object_event",
              get: true
            },
            {
              name: "id",
              description: "Update a library_object_event",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "library_keyring"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  super_power: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Is this event flagged as a super_power"
                  },
                  description: {
                    type: "String",
                    desc: "Description of this library_object_event_version"
                  },
                  javascript: {
                    type: "String",
                    desc: "Javascript of this library_object_event_version"
                  },
                  key: {
                    type: "String",
                    desc: "Key of this library_object_event_version"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a library_object_event",
              delete: true
            },
            {
              name: "id",
              resources: {
                library_object_event_modules: {
                  name: "library_object_event_modules",
                  description: "List of object_event_modules for this object_event",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_object_event_tips: {
                  name: "library_object_event_tips",
                  description: "List of object_event_tips for this object_event",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_object_event_parameters: {
                  name: "library_object_event_parameters",
                  description: "List of object_event_parameters for this object_event",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Library::ObjectMethodModule": {
          name: "library_object_method_modules",
          description: "Returns all library_object_method_modules",
          create_options: [
            {
              required_relationships: [
                "library_object_method",
                "library_engine_module"
              ]
            }
          ],
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a library_object_method_module",
              delete: true
            },
            {
              name: "id",
              description: "Get a object_method_module",
              get: true
            },
            {
              name: "id",
              description: "Update a library_object_method_module",
              update_options: [
                {
                  deletable: true
                }
              ],
              put: true
            }
          ]
        },
        "Library::ObjectMethodTip": {
          name: "library_object_method_tips",
          description: "Returns all library_object_method_tips",
          create_options: [
            {
              required_relationships: [
                "library_object_method"
              ]
            }
          ],
          create_params: {
            requires: {
              tip: {
                type: "String",
                desc: "The tip"
              }
            },
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a library_object_method_tip",
              delete: true
            },
            {
              name: "id",
              description: "Get a object_method_tip",
              get: true
            },
            {
              name: "id",
              description: "Update a library_object_method_tip",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  tip: {
                    type: "String",
                    desc: "The tip"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Library::ObjectMethodParameter": {
          name: "library_object_method_parameters",
          description: "Returns all library_object_method_parameters",
          create_options: [
            {
              required_relationships: [
                "library_object_method"
              ],
              optional_relationships: [
                "library_widget",
                "library_object_configuration_value",
                "library_object_constant",
                "library_keyring"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this object_method_parameter"
              },
              description: {
                type: "String",
                desc: "Description of this library_object_method_parameter_version"
              },
              default_value: {
                type: "String",
                desc: "An optional default value for this paramater. This value is used when this parameter is locked"
              },
              example_value: {
                type: "String",
                desc: "An optional example value for this paramater. This value is used when highlighting methods or providing examples on trading cards and in the library"
              },
              validate_greater_than: {
                type: "Integer",
                desc: "Validate Greater Than of this library_object_method_parameter_version"
              },
              validate_greater_than_or_equal: {
                type: "Integer",
                desc: "Validate Greater Than Or Equal of this library_object_method_parameter_version"
              },
              validate_less_than: {
                type: "Integer",
                desc: "Validate Less Than of this library_object_method_parameter_version"
              },
              validate_less_than_or_equal: {
                type: "Integer",
                desc: "Validate Less Than Or Equal of this library_object_method_parameter_version"
              },
              validate_whole_number: {
                type: "Virtus::Attribute::Boolean",
                desc: "Validate Whole Number of this library_object_method_parameter_version"
              },
              position: {
                type: "Integer",
                desc: "Position of this library_object_method_parameter_version"
              },
              class_name: {
                type: "Symbol",
                values: [
                  "Text",
                  "Number",
                  "List",
                  "TrueFalse",
                  "any"
                ],
                desc: "Text, Number, List, TrueFalse or any"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a object_method_parameter",
              get: true
            },
            {
              name: "id",
              description: "Delete a library_object_method_parameter",
              delete: true
            },
            {
              name: "id",
              description: "Update a library_object_method_parameter",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "library_widget",
                    "library_object_configuration_value",
                    "library_object_constant",
                    "library_keyring"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  description: {
                    type: "String",
                    desc: "Description of this library_object_method_parameter_version"
                  },
                  default_value: {
                    type: "String",
                    desc: "An optional default value for this paramater. This value is used when this parameter is locked"
                  },
                  example_value: {
                    type: "String",
                    desc: "An optional example value for this paramater. This value is used when highlighting methods or providing examples on trading cards and in the library"
                  },
                  validate_greater_than: {
                    type: "Integer",
                    desc: "Validate Greater Than of this library_object_method_parameter_version"
                  },
                  validate_greater_than_or_equal: {
                    type: "Integer",
                    desc: "Validate Greater Than Or Equal of this library_object_method_parameter_version"
                  },
                  validate_less_than: {
                    type: "Integer",
                    desc: "Validate Less Than of this library_object_method_parameter_version"
                  },
                  validate_less_than_or_equal: {
                    type: "Integer",
                    desc: "Validate Less Than Or Equal of this library_object_method_parameter_version"
                  },
                  validate_whole_number: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Validate Whole Number of this library_object_method_parameter_version"
                  },
                  position: {
                    type: "Integer",
                    desc: "Position of this library_object_method_parameter_version"
                  },
                  class_name: {
                    type: "Symbol",
                    values: [
                      "Text",
                      "Number",
                      "List",
                      "TrueFalse",
                      "any"
                    ],
                    desc: "Text, Number, List, TrueFalse or any"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Library::ObjectMethod": {
          name: "library_object_methods",
          description: "Returns all library_object_methods",
          create_options: [
            {
              required_relationships: [
                "library_object"
              ],
              optional_relationships: [
                "library_object_configuration_value",
                "library_keyring"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this object_method"
              },
              internal: {
                type: "Virtus::Attribute::Boolean",
                desc: "Internal of this library_object_method"
              },
              super_power: {
                type: "Virtus::Attribute::Boolean",
                desc: "Is this method flagged as a super_power"
              },
              description: {
                type: "String",
                desc: "Description of this library_object_method_version"
              },
              javascript: {
                type: "String",
                desc: "Javascript of this library_object_method_version"
              },
              return_type: {
                type: "Symbol",
                values: [
                  "Text",
                  "Number",
                  "List",
                  "TrueFalse",
                  "promise",
                  "any",
                  "self"
                ],
                desc: "Text, Number, List, TrueFalse, promise, any or self"
              },
              object_configuration_value_value: {
                type: "String",
                desc: "A value this method can set for the coresponding object_configuration_value_id"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              ids: {
                type: "Array"
              },
              q: {
                type: "String",
                desc: "search the method name"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a object_method",
              get: true
            },
            {
              name: "id",
              description: "Update a library_object_method",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "library_object_configuration_value",
                    "library_keyring"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  super_power: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Is this method flagged as a super_power"
                  },
                  description: {
                    type: "String",
                    desc: "Description of this library_object_method_version"
                  },
                  javascript: {
                    type: "String",
                    desc: "Javascript of this library_object_method_version"
                  },
                  return_type: {
                    type: "Symbol",
                    values: [
                      "Text",
                      "Number",
                      "List",
                      "TrueFalse",
                      "promise",
                      "any",
                      "self"
                    ],
                    desc: "Text, Number, List, TrueFalse, promise, any or self"
                  },
                  object_configuration_value_value: {
                    type: "String",
                    desc: "A value this method can set for the coresponding object_configuration_value_id"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a library_object_method",
              delete: true
            },
            {
              name: "id",
              resources: {
                library_object_method_modules: {
                  name: "library_object_method_modules",
                  description: "List of object_method_modules for this object_method",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_object_method_tips: {
                  name: "library_object_method_tips",
                  description: "List of object_method_tips for this object_method",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_object_method_parameters: {
                  name: "library_object_method_parameters",
                  description: "List of object_method_parameters for this object_method",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Library::Object": {
          name: "library_objects",
          description: "Returns all library_objects",
          create_options: [
            {
              optional_relationships: [
                "library_engine",
                "library_category",
                "library_keyring"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this object"
              },
              synonyms: {
                type: "Array",
                desc: "Alternative names of this object"
              },
              description: {
                type: "String",
                desc: "Description of this library_object_version"
              },
              icon: {
                type: "String",
                desc: "Icon (string of SVG content)"
              },
              changelog: {
                type: "String",
                desc: "Changelog of this library_object_version"
              },
              significance: {
                type: "Symbol",
                values: [
                  "major",
                  "minor"
                ],
                desc: "major and minor"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              ids: {
                type: "Array"
              },
              q: {
                type: "String",
                desc: "search the object name"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a object",
              get: true
            },
            {
              name: "id",
              description: "Update a library_object",
              update_options: [
                {
                  deletable: true,
                  publishable: true,
                  optional_relationships: [
                    "library_engine_version",
                    "library_category",
                    "library_keyring"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  synonyms: {
                    type: "Array",
                    desc: "Alternative names of this object"
                  },
                  description: {
                    type: "String",
                    desc: "Description of this library_object_version"
                  },
                  icon: {
                    type: "String",
                    desc: "Icon (string of SVG content)"
                  },
                  changelog: {
                    type: "String",
                    desc: "Changelog of this library_object_version"
                  },
                  significance: {
                    type: "Symbol",
                    values: [
                      "major",
                      "minor"
                    ],
                    desc: "major and minor"
                  },
                  engine_method_associations: {
                    type: "Array",
                    desc: "bulk associate engine methods"
                  },
                  engine_event_associations: {
                    type: "Array",
                    desc: "bulk associate engine events"
                  },
                  generator_code: {
                    type: "Hash",
                    desc: "convenient way to generate various configuration and methods"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                library_object_versions: {
                  name: "library_object_versions",
                  description: "List of object_versions for this object",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_engine_configuration_templates: {
                  name: "library_engine_configuration_templates",
                  description: "List of engine_configuration_templates for this object",
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search by name"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_engine_methods: {
                  name: "library_engine_methods",
                  description: "List of engine_methods for this object",
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search the method name"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_engine_events: {
                  name: "library_engine_events",
                  description: "List of engine_events for this object",
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search the event name"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_engine_modules: {
                  name: "library_engine_modules",
                  description: "List of engine_modules for this object",
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search the module name"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_object_configuration_templates: {
                  name: "library_object_configuration_templates",
                  description: "List of object_configuration_templates for this object",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search by name"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_object_configuration_values: {
                  name: "library_object_configuration_values",
                  description: "List of object_configuration_values for this object",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search the value name"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_object_constants: {
                  name: "library_object_constants",
                  description: "List of object_constants for this object",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search by name"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_object_events: {
                  name: "library_object_events",
                  description: "List of object_events for this object",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search the event name"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_object_included_engine_events: {
                  name: "library_object_included_engine_events",
                  description: "List of object_included_engine_events for this object",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_object_included_engine_methods: {
                  name: "library_object_included_engine_methods",
                  description: "List of object_included_engine_methods for this object",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_object_methods: {
                  name: "library_object_methods",
                  description: "List of object_methods for this object",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search the method name"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                library_object_reactions: {
                  name: "library_object_reactions",
                  description: "List of object_reactions for this object",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Library::Widget": {
          name: "library_widgets",
          description: "Returns all library_widgets",
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this widget"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a library_widget",
              delete: true
            },
            {
              name: "id",
              description: "Get a widget",
              get: true
            },
            {
              name: "id",
              description: "Update a library_widget",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this library_widget"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Library::ObjectConstantValue": {
          name: "library_object_constant_values",
          description: "Returns all library_object_constant_values",
          create_options: [
            {
              required_relationships: [
                "library_object_constant"
              ],
              optional_relationships: [
                "library_keyring"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              value: {
                type: "String",
                desc: "Value of this object_constant_value"
              },
              position: {
                type: "Integer",
                desc: "Position of this library_object_constant_value"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a object_constant_value",
              get: true
            },
            {
              name: "id",
              description: "Delete a library_object_constant_value",
              delete: true
            },
            {
              name: "id",
              description: "Update a library_object_constant_value",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "library_keyring"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  position: {
                    type: "Integer",
                    desc: "Position of this library_object_constant_value_version"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                library_object_constant_value_versions: {
                  name: "library_object_constant_value_versions",
                  description: "List of object_constant_value_versions for this object_constant_value",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Library::ObjectConstant": {
          name: "library_object_constants",
          description: "Returns all library_object_constants",
          create_options: [
            {
              optional_relationships: [
                "library_object"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this object_constant"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a object_constant",
              get: true
            },
            {
              name: "id",
              description: "Delete a library_object_constant",
              delete: true
            },
            {
              name: "id",
              description: "Update a library_object_constant",
              update_options: [
                {
                  deletable: true
                }
              ],
              put: true
            },
            {
              name: "id",
              resources: {
                library_object_constant_values: {
                  name: "library_object_constant_values",
                  description: "List of object_constant_values for this object_constant",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search the value"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Studios::Location": {
          name: "locations",
          description: "Get a list of locations",
          create_options: [
            {
              required_relationships: [
                "merchant_account"
              ]
            }
          ],
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                desc: "This locations name"
              },
              hostname: {
                type: "String",
                allow_blank: false,
                desc: "This locations internal hostname. I.e. \"lincoln-park.novanet.codeverse.com\""
              },
              capacity: {
                type: "Integer",
                desc: "The legal capacity of this studio"
              },
              time_zone: {
                type: "String",
                allow_blank: false,
                desc: "This locations time zone, i.e. CST"
              },
              address1: {
                type: "String",
                desc: "This locations address1"
              },
              city: {
                type: "String",
                allow_blank: false,
                desc: "This locations city"
              },
              state: {
                type: "String",
                allow_blank: false,
                desc: "This locations state"
              },
              zip_code: {
                type: "String",
                allow_blank: false,
                desc: "This locations zip_code"
              },
              country_code: {
                type: "String",
                allow_blank: false,
                desc: "This locations country"
              },
              dialing_code: {
                type: "String",
                allow_blank: false,
                values: [
                  "1",
                  "20",
                  "211",
                  "212",
                  "213",
                  "216",
                  "218",
                  "220",
                  "221",
                  "222",
                  "223",
                  "224",
                  "225",
                  "226",
                  "227",
                  "228",
                  "229",
                  "230",
                  "231",
                  "232",
                  "233",
                  "234",
                  "235",
                  "236",
                  "237",
                  "238",
                  "239",
                  "240",
                  "241",
                  "242",
                  "243",
                  "244",
                  "245",
                  "246",
                  "248",
                  "249",
                  "250",
                  "251",
                  "252",
                  "253",
                  "254",
                  "255",
                  "256",
                  "257",
                  "258",
                  "260",
                  "261",
                  "262",
                  "263",
                  "264",
                  "265",
                  "266",
                  "267",
                  "268",
                  "269",
                  "27",
                  "290",
                  "291",
                  "297",
                  "298",
                  "299",
                  "30",
                  "31",
                  "32",
                  "33",
                  "34",
                  "350",
                  "351",
                  "352",
                  "353",
                  "354",
                  "355",
                  "356",
                  "357",
                  "358",
                  "359",
                  "36",
                  "370",
                  "371",
                  "372",
                  "373",
                  "374",
                  "375",
                  "376",
                  "377",
                  "378",
                  "380",
                  "381",
                  "382",
                  "385",
                  "386",
                  "387",
                  "389",
                  "39",
                  "40",
                  "41",
                  "420",
                  "421",
                  "423",
                  "43",
                  "44",
                  "45",
                  "46",
                  "47",
                  "48",
                  "49",
                  "500",
                  "501",
                  "502",
                  "503",
                  "504",
                  "505",
                  "506",
                  "507",
                  "508",
                  "509",
                  "51",
                  "52",
                  "53",
                  "54",
                  "55",
                  "56",
                  "57",
                  "58",
                  "590",
                  "591",
                  "592",
                  "593",
                  "594",
                  "595",
                  "596",
                  "597",
                  "598",
                  "599",
                  "60",
                  "61",
                  "62",
                  "63",
                  "64",
                  "65",
                  "66",
                  "670",
                  "672",
                  "673",
                  "674",
                  "675",
                  "676",
                  "677",
                  "678",
                  "679",
                  "680",
                  "681",
                  "682",
                  "683",
                  "685",
                  "686",
                  "687",
                  "688",
                  "689",
                  "690",
                  "691",
                  "692",
                  "7",
                  "81",
                  "82",
                  "84",
                  "850",
                  "852",
                  "853",
                  "855",
                  "856",
                  "86",
                  "880",
                  "886",
                  "90",
                  "91",
                  "92",
                  "93",
                  "94",
                  "95",
                  "960",
                  "961",
                  "962",
                  "963",
                  "964",
                  "965",
                  "966",
                  "967",
                  "968",
                  "970",
                  "971",
                  "972",
                  "973",
                  "974",
                  "975",
                  "976",
                  "977",
                  "98",
                  "992",
                  "993",
                  "994",
                  "995",
                  "996",
                  "998"
                ],
                desc: "a valid country dialing code, i.e. 1 for the US and 44 for the UK"
              },
              phone_number: {
                type: "String",
                allow_blank: false,
                desc: "Phone Number of this studio"
              }
            },
            optional: {
              address2: {
                type: "String",
                desc: "This locations address2"
              },
              map: {
                type: "String",
                desc: "The map of this location which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              },
              width: {
                type: "Integer",
                desc: "The width in meters of this locations map"
              },
              length: {
                type: "Integer",
                desc: "The length in meters of this locations map"
              },
              height: {
                type: "Integer",
                desc: "The height in meters of this locations map"
              },
              ip_address: {
                type: "String",
                allow_blank: false,
                desc: "Public IP Address of this location"
              },
              subnet: {
                type: "String",
                allow_blank: false,
                desc: "Public subnet of this location"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              ids: {
                type: "Array"
              },
              zip_code: {
                type: "String",
                desc: "find locations near this zip code"
              },
              hostname: {
                type: "String",
                desc: "This locations internal hostname. I.e. \"lincoln-park.novanet.codeverse.com\""
              },
              q: {
                type: "String",
                desc: "search the locations by name"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "hostname"
          ],
          id_param: true,
          resources: {
            current: {
              name: "current",
              description: "Get a location from the current IP address",
              get: true
            }
          },
          route_params: [
            {
              name: "id",
              description: "Get a location",
              get: true,
              resources: {
                next_class: {
                  name: "next_class",
                  description: "When is the next class, and who is attending",
                  get: true
                }
              }
            },
            {
              name: "id",
              description: "Update a location",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "This locations name"
                  },
                  hostname: {
                    type: "String",
                    desc: "This locations internal hostname. I.e. \"linoln-park\". Do not include \".novanet\""
                  },
                  ip_address: {
                    type: "String",
                    desc: "Public IP Address of this location"
                  },
                  subnet: {
                    type: "String",
                    desc: "Public subnet of this location"
                  },
                  capacity: {
                    type: "Integer",
                    desc: "The legal capacity of this studio"
                  },
                  time_zone: {
                    type: "String",
                    desc: "This locations time zone, i.e. CST"
                  },
                  address1: {
                    type: "String",
                    desc: "This locations address1"
                  },
                  address2: {
                    type: "String",
                    desc: "This locations address2"
                  },
                  city: {
                    type: "String",
                    desc: "This locations city"
                  },
                  state: {
                    type: "String",
                    desc: "This locations state"
                  },
                  zip_code: {
                    type: "String",
                    desc: "This locations zip_code"
                  },
                  country_code: {
                    type: "String",
                    desc: "This locations country"
                  },
                  dialing_code: {
                    type: "String",
                    values: [
                      "1",
                      "20",
                      "211",
                      "212",
                      "213",
                      "216",
                      "218",
                      "220",
                      "221",
                      "222",
                      "223",
                      "224",
                      "225",
                      "226",
                      "227",
                      "228",
                      "229",
                      "230",
                      "231",
                      "232",
                      "233",
                      "234",
                      "235",
                      "236",
                      "237",
                      "238",
                      "239",
                      "240",
                      "241",
                      "242",
                      "243",
                      "244",
                      "245",
                      "246",
                      "248",
                      "249",
                      "250",
                      "251",
                      "252",
                      "253",
                      "254",
                      "255",
                      "256",
                      "257",
                      "258",
                      "260",
                      "261",
                      "262",
                      "263",
                      "264",
                      "265",
                      "266",
                      "267",
                      "268",
                      "269",
                      "27",
                      "290",
                      "291",
                      "297",
                      "298",
                      "299",
                      "30",
                      "31",
                      "32",
                      "33",
                      "34",
                      "350",
                      "351",
                      "352",
                      "353",
                      "354",
                      "355",
                      "356",
                      "357",
                      "358",
                      "359",
                      "36",
                      "370",
                      "371",
                      "372",
                      "373",
                      "374",
                      "375",
                      "376",
                      "377",
                      "378",
                      "380",
                      "381",
                      "382",
                      "385",
                      "386",
                      "387",
                      "389",
                      "39",
                      "40",
                      "41",
                      "420",
                      "421",
                      "423",
                      "43",
                      "44",
                      "45",
                      "46",
                      "47",
                      "48",
                      "49",
                      "500",
                      "501",
                      "502",
                      "503",
                      "504",
                      "505",
                      "506",
                      "507",
                      "508",
                      "509",
                      "51",
                      "52",
                      "53",
                      "54",
                      "55",
                      "56",
                      "57",
                      "58",
                      "590",
                      "591",
                      "592",
                      "593",
                      "594",
                      "595",
                      "596",
                      "597",
                      "598",
                      "599",
                      "60",
                      "61",
                      "62",
                      "63",
                      "64",
                      "65",
                      "66",
                      "670",
                      "672",
                      "673",
                      "674",
                      "675",
                      "676",
                      "677",
                      "678",
                      "679",
                      "680",
                      "681",
                      "682",
                      "683",
                      "685",
                      "686",
                      "687",
                      "688",
                      "689",
                      "690",
                      "691",
                      "692",
                      "7",
                      "81",
                      "82",
                      "84",
                      "850",
                      "852",
                      "853",
                      "855",
                      "856",
                      "86",
                      "880",
                      "886",
                      "90",
                      "91",
                      "92",
                      "93",
                      "94",
                      "95",
                      "960",
                      "961",
                      "962",
                      "963",
                      "964",
                      "965",
                      "966",
                      "967",
                      "968",
                      "970",
                      "971",
                      "972",
                      "973",
                      "974",
                      "975",
                      "976",
                      "977",
                      "98",
                      "992",
                      "993",
                      "994",
                      "995",
                      "996",
                      "998"
                    ],
                    desc: "a valid country dialing code, i.e. 1 for the US and 44 for the UK"
                  },
                  phone_number: {
                    type: "String",
                    desc: "Phone Number of this studio"
                  },
                  map: {
                    type: "String",
                    desc: "The map of this location which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  },
                  width: {
                    type: "Integer",
                    desc: "The width in meters of this locations map"
                  },
                  length: {
                    type: "Integer",
                    desc: "The length in meters of this locations map"
                  },
                  height: {
                    type: "Integer",
                    desc: "The height in meters of this locations map"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a location",
              delete: true
            },
            {
              name: "id",
              resources: {
                slots: {
                  name: "slots",
                  description: "List of slots for this location",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      occasion_id: {
                        uuid: true
                      },
                      date: {
                        type: "Date",
                        desc: "the date of a hypothetical booking"
                      },
                      start_hour: {
                        type: "Integer",
                        desc: "the hour of the day that the slot starts"
                      },
                      start_minute: {
                        type: "Integer",
                        desc: "the minute of the day that the slot starts"
                      },
                      end_hour: {
                        type: "Integer",
                        desc: "the hour of the day that the slot ends"
                      },
                      end_minute: {
                        type: "Integer",
                        desc: "the minute of the day that the slot ends"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at",
                    "first_available_at",
                    "last_available_at",
                    "start_hour",
                    "end_hour",
                    "capacity"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                bookings: {
                  name: "bookings",
                  description: "Get a list of bookings for this location",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      date: {
                        type: "Date",
                        desc: "the date of the booking"
                      },
                      start_hour: {
                        type: "Integer",
                        desc: "the hour of the day that the booking starts"
                      },
                      start_minute: {
                        type: "Integer",
                        desc: "the minute of the day that the booking starts"
                      },
                      end_hour: {
                        type: "Integer",
                        desc: "the hour of the day that the booking ends"
                      },
                      end_minute: {
                        type: "Integer",
                        desc: "the minute of the day that the booking ends"
                      },
                      status: {
                        type: "Symbol",
                        values: [
                          "held",
                          "deposit_invoiced",
                          "deposit_invoice_past_due",
                          "invoiced",
                          "invoice_past_due",
                          "attaching_to_subscription",
                          "pending",
                          "active",
                          "completing",
                          "completed"
                        ],
                        desc: "held, deposit_invoiced, deposit_invoice_past_due, invoiced, invoice_past_due, attaching_to_subscription, pending, active, completing or completed"
                      },
                      statuses: {
                        type: "Array",
                        desc: "array of statuses"
                      },
                      exclude_status: {
                        type: "Symbol",
                        values: [
                          "held",
                          "deposit_invoiced",
                          "deposit_invoice_past_due",
                          "invoiced",
                          "invoice_past_due",
                          "attaching_to_subscription",
                          "pending",
                          "active",
                          "completing",
                          "completed"
                        ],
                        desc: "held, deposit_invoiced, deposit_invoice_past_due, invoiced, invoice_past_due, attaching_to_subscription, pending, active, completing or completed"
                      },
                      occasion_id: {
                        type: "UUID",
                        desc: "a single of occasion id"
                      },
                      occasion_ids: {
                        type: "Array",
                        desc: "array of occasion ids"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at",
                    "first_visit_at",
                    "last_visit_at",
                    "start_hour",
                    "end_hour"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                hardware_components: {
                  name: "hardware_components",
                  description: "List of hardware_components for this location",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      driver: {
                        type: "Symbol",
                        values: [
                          "codeverse_module",
                          "display",
                          "door_controller",
                          "estimote_beacon",
                          "imac",
                          "student_ipad",
                          "instructor_ipad",
                          "retail_ipad",
                          "fixed_ipad",
                          "home_pod",
                          "lifx_bulb",
                          "maker_bot",
                          "carvey",
                          "meraki_access_point",
                          "meraki_router",
                          "moving_spot_light",
                          "moving_mini_spot_light",
                          "moving_wash_light",
                          "nova_server",
                          "network_interface",
                          "portal",
                          "phone",
                          "printer",
                          "thermostat",
                          "projector",
                          "speaker",
                          "smart_glass",
                          "power_switch",
                          "power_outlet",
                          "strobe_light",
                          "robot_arm",
                          "ubiquiti_camera",
                          "ubiquiti_switch"
                        ],
                        desc: "codeverse_module, display, door_controller, estimote_beacon, imac, student_ipad, instructor_ipad, retail_ipad, fixed_ipad, home_pod, lifx_bulb, maker_bot, carvey, meraki_access_point, meraki_router, moving_spot_light, moving_mini_spot_light, moving_wash_light, nova_server, network_interface, portal, phone, printer, thermostat, projector, speaker, smart_glass, power_switch, power_outlet, strobe_light, robot_arm, ubiquiti_camera or ubiquiti_switch"
                      },
                      q: {
                        type: "String",
                        desc: "search the hostname"
                      },
                      last_heartbeat_topic: {
                        type: "Symbol",
                        values: [
                          "healthy",
                          "info",
                          "warning",
                          "error"
                        ],
                        desc: "the current health state of this component"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at",
                    "last_seen_at",
                    "hostname",
                    "driver",
                    "status"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                attendances: {
                  name: "attendances",
                  description: "Get a list of attendances for this location",
                  filter_params: {
                    requires: {},
                    optional: {
                      date: {
                        type: "Date",
                        desc: "the date of the attendance"
                      },
                      status: {
                        type: "Symbol",
                        values: [
                          "pending",
                          "late_arrival",
                          "checked_in",
                          "completed",
                          "no_show",
                          "canceled"
                        ],
                        desc: "pending, late_arrival, checked_in, completed, no_show or canceled"
                      },
                      statuses: {
                        type: "Array",
                        desc: "array of statuses"
                      },
                      occasion_id: {
                        type: "UUID",
                        desc: "a single of occasion id"
                      },
                      occasion_ids: {
                        type: "Array",
                        desc: "array of occasion ids"
                      },
                      exclude_status: {
                        type: "Symbol",
                        values: [
                          "pending",
                          "late_arrival",
                          "checked_in",
                          "completed",
                          "no_show",
                          "canceled"
                        ],
                        desc: "pending, late_arrival, checked_in, completed, no_show or canceled"
                      },
                      start_hour: {
                        type: "Integer",
                        desc: "the hour of the day that the booking starts"
                      },
                      start_minute: {
                        type: "Integer",
                        desc: "the minute of the day that the booking starts"
                      },
                      end_hour: {
                        type: "Integer",
                        desc: "the hour of the day that the booking ends"
                      },
                      end_minute: {
                        type: "Integer",
                        desc: "the minute of the day that the booking ends"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at",
                    "check_in_at",
                    "check_out_at"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                incidents: {
                  name: "incidents",
                  description: "List of incidents for this location",
                  filter_options: [
                    {
                      deletable: true,
                      handleable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search by string"
                      },
                      topic: {
                        type: "Symbol",
                        values: [
                          "behavior",
                          "customer_service",
                          "facilities",
                          "health_and_safety",
                          "other",
                          "technology"
                        ],
                        desc: "behavior, customer_service, facilities, health_and_safety, other or technology"
                      },
                      topics: {
                        type: "Array",
                        desc: "array of topics"
                      },
                      author_id: {
                        type: "UUID"
                      },
                      occured_after: {
                        type: "Date",
                        desc: "filter by occured date"
                      },
                      occured_before: {
                        type: "Date",
                        desc: "filter by occured date"
                      },
                      emergency: {
                        type: "Virtus::Attribute::Boolean"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at"
                  ]
                }
              }
            }
          ]
        },
        "Logging::LogEntry": {
          name: "log_entries",
          description: "Returns all log_entries",
          filter_params: {
            requires: {},
            optional: {
              topic: {
                type: "UUID"
              },
              topics: {
                type: "Array"
              },
              referencing_id: {
                type: "UUID"
              },
              organization_id: {
                type: "UUID"
              },
              actor_id: {
                type: "UUID"
              },
              current_user_id: {
                type: "UUID"
              },
              oauth_application_id: {
                type: "UUID"
              },
              created_after: {
                type: "Date",
                desc: "filter by created date"
              },
              created_before: {
                type: "Date",
                desc: "filter by created date"
              }
            }
          },
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a log_entry",
              get: true
            },
            {
              name: "id",
              description: "Update a log_entry",
              update_params: {
                requires: {
                  comment: {
                    type: "String",
                    allow_blank: false,
                    desc: "to update the comment on a log entry"
                  }
                },
                optional: {}
              },
              put: true
            }
          ]
        },
        "Users::Media": {
          name: "media",
          description: "Save media which has been created for this user.",
          create_options: [
            {
              optional_relationships: [
                "user"
              ]
            }
          ],
          create_params: {
            requires: {
              uri: {
                type: "String",
                allow_blank: false,
                desc: "URI to this image"
              },
              content_length: {
                type: "Integer",
                desc: "size in bytes of this media"
              },
              mime_type: {
                type: "String",
                allow_blank: false,
                desc: "what type of file is this"
              },
              medium: {
                type: "String",
                allow_blank: false,
                regexp: "(?-mix:\\A[a-z_]+\\Z)",
                desc: "the medium type for this media, such as photo or analytics_screenshot"
              }
            },
            optional: {}
          },
          post: true,
          authorize: [
            "account"
          ]
        },
        "Organizations::Membership": {
          name: "memberships",
          description: "Associate members to this organization",
          create_options: [
            {
              optional_relationships: [
                "user",
                "organization"
              ]
            }
          ],
          create_params: {
            requires: {
              role: {
                type: "Symbol",
                values: [
                  "ownership",
                  "instructorship",
                  "studentship",
                  "pickupship",
                  "attendship"
                ],
                desc: "the users role (permission level) at this organization, should be either ownership, instructorship, studentship or attendship"
              }
            },
            optional: {
              email: {
                type: "String",
                desc: "If you dont know the members ID then you can find them by email address."
              },
              badge: {
                type: "String",
                desc: "The badge is the unique ID used for this user within the organization, such as s student_id."
              },
              pin: {
                type: "String",
                desc: "Pin number to authenticating with badge id (logging in, picking up kids accessing the account over the phone etc.)."
              },
              accepted: {
                type: "Virtus::Attribute::Boolean",
                desc: "has this been accepted, or is it still an invitation."
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a membership",
              get: true
            },
            {
              name: "id",
              description: "Update a membership",
              update_options: [
                {
                  deletable: true,
                  acceptable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  role: {
                    type: "Symbol",
                    values: [
                      "ownership",
                      "instructorship",
                      "studentship",
                      "pickupship",
                      "attendship"
                    ],
                    desc: "the users role (permission level) at this organization, should be either ownership, instructorship or studentship"
                  },
                  badge: {
                    type: "String",
                    desc: "The badge is the unique ID used for this user within the organization, such as student_id."
                  },
                  pin: {
                    type: "String",
                    desc: "Pin number to authenticating with badge id (logging in, picking up kids accessing the account over the phone etc.)."
                  }
                }
              },
              put: true,
              id_param: true
            },
            {
              name: "id",
              description: "Delete a membership",
              delete: true,
              id_param: true
            },
            {
              name: "id",
              resources: {
                user: {
                  name: "user",
                  description: "Return a user from a membership",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                organization: {
                  name: "organization",
                  description: "Return a organization from a membership",
                  get: true
                }
              }
            }
          ]
        },
        "Billing::MerchantAccount": {
          name: "merchant_accounts",
          description: "Returns all merchant_accounts",
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a merchant_account",
              get: true
            }
          ]
        },
        "Marketing::NewsletterSubscriber": {
          name: "newsletter_subscribers",
          description: "Create a newsletter_subscriber",
          create_options: [
            {
              optional_relationships: [
                "public_session"
              ]
            }
          ],
          create_params: {
            requires: {
              email: {
                type: "String",
                allow_blank: false,
                desc: "the user provided email address"
              }
            },
            optional: {
              referral_code: {
                type: "String",
                desc: "optional referral code if this organization was referred"
              }
            }
          },
          post: true
        },
        "Notes::Note": {
          name: "notes",
          description: "Returns all notes",
          create_options: [
            {
              pinnable: true,
              optional_relationships: [
                "organization",
                "attendance",
                "user",
                "phone_conversation",
                "text_message",
                "email",
                "opportunity",
                "participation"
              ]
            }
          ],
          create_params: {
            requires: {
              heading: {
                type: "String",
                desc: "Heading for this note"
              }
            },
            optional: {
              topic: {
                type: "Symbol",
                values: [
                  "comments",
                  "progress",
                  "goals",
                  "feedback",
                  "concerns",
                  "sales",
                  "learning_styles",
                  "parent_update"
                ],
                desc: "comments, progress, goals, feedback, concerns, sales, learning_styles or parent_update"
              },
              detail: {
                type: "String",
                desc: "Detail for this note"
              }
            }
          },
          filter_options: [
            {
              deletable: true,
              pinnable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a note",
              get: true
            },
            {
              name: "id",
              description: "Update a note",
              update_options: [
                {
                  pinnable: true,
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  topic: {
                    type: "Symbol",
                    values: [
                      "comments",
                      "progress",
                      "goals",
                      "feedback",
                      "concerns",
                      "sales",
                      "learning_styles",
                      "parent_update"
                    ],
                    desc: "comments, progress, goals, feedback, concerns, sales, learning_styles or parent_update"
                  },
                  heading: {
                    type: "String",
                    desc: "Heading for this note"
                  },
                  detail: {
                    type: "String",
                    desc: "Detail for this note"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a note",
              delete: true
            },
            {
              name: "id",
              resources: {
                note_involvements: {
                  name: "note_involvements",
                  description: "List of involvements for this note",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                note_attachments: {
                  name: "note_attachments",
                  description: "List of attachments for this note",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                author: {
                  name: "author",
                  description: "Get a author for this note",
                  get: true
                }
              }
            }
          ]
        },
        "Notes::Attachment": {
          name: "note_attachments",
          description: "Returns all note_attachments",
          create_options: [
            {
              optional_relationships: [
                "note"
              ]
            }
          ],
          create_params: {
            requires: {
              file: {
                type: "String",
                allow_blank: false,
                desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/jpeg;base64,iVBORw0KGgo...\""
              }
            },
            optional: {
              description: {
                type: "String",
                desc: "Description of this note_attachment"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a note_attachment",
              get: true
            },
            {
              name: "id",
              description: "Update a note_attachment",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  description: {
                    type: "String",
                    desc: "Description of this note_attachment"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a note_attachment",
              delete: true
            }
          ]
        },
        "Notes::Involvement": {
          name: "note_involvements",
          description: "Create a note_involvement",
          create_options: [
            {
              optional_relationships: [
                "note",
                "user",
                "attendance"
              ]
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a note_involvement",
              delete: true
            }
          ]
        },
        "Studios::Occasion": {
          name: "occasions",
          description: "Get a list of occasions",
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                desc: ""
              },
              color: {
                type: "String",
                allow_blank: false,
                desc: "hex value representing a color, such as #112233"
              },
              description: {
                type: "String",
                allow_blank: false,
                desc: ""
              },
              total_amount: {
                type: "BigDecimal",
                coerce_with: "APICoercions::MoneyToBigDecimal",
                desc: "if classes are included in a subscription, then this will be the price for additional sessions above and beyond those included in the membership. for something like summer camp, this is the total payment for the session"
              },
              deposit_amount: {
                type: "BigDecimal",
                coerce_with: "APICoercions::MoneyToBigDecimal",
                desc: "if this session requires a deposit to hold it, then this is the deposit amount this will be subtracted automatically from the price above"
              },
              subscription_required: {
                type: "Virtus::Attribute::Boolean",
                desc: "set to true, if accessing this slot type requires a valid subscription this is true for membership and related slots such as flex and emergency but false for one off sessions like summer camps"
              },
              number_of_days: {
                type: "Integer",
                desc: "how many consecutive days does this slot last for. Summer camps are 5, normal sessions are 1 this is used to determine capacity at the studio and what days the users account will be active"
              },
              whole_studio: {
                type: "Virtus::Attribute::Boolean",
                desc: "when at least one person books this slot, does it take over the whole studio and prevent booking types"
              },
              recurring: {
                type: "Virtus::Attribute::Boolean",
                desc: "does this occasion allow recurring bookings - i.e. memberships do, summer camps and trials do not"
              },
              in_person: {
                type: "Virtus::Attribute::Boolean",
                desc: "does this occasion happen in person (requires a location) or is it virtual"
              },
              dynamic_capacity: {
                type: "Virtus::Attribute::Boolean",
                desc: "does this slot accept dynamic capacities"
              },
              students_per_guide: {
                type: "Integer",
                desc: "ideal number of students to each guide"
              },
              advance_bookable_days: {
                type: "Integer",
                desc: "number of days in advance bookings can be made of this occasion type"
              },
              buffer_minutes_before: {
                type: "Integer",
                desc: "buffer size in minutes before a matched booking which a schedule will be blocked off"
              },
              buffer_minutes_after: {
                type: "Integer",
                desc: "buffer size in minutes before a matched booking which a schedule will be blocked off"
              }
            },
            optional: {
              room_type: {
                type: "Symbol",
                values: [
                  "group-small",
                  "group"
                ],
                desc: "null, group-small and group"
              },
              highlight_1: {
                type: "String"
              },
              highlight_1_icon_name: {
                type: "String"
              },
              highlight_2: {
                type: "String"
              },
              highlight_2_icon_name: {
                type: "String"
              },
              highlight_3: {
                type: "String"
              },
              highlight_3_icon_name: {
                type: "String"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              subscription_required: {
                type: "Virtus::Attribute::Boolean"
              },
              whole_studio: {
                type: "Virtus::Attribute::Boolean"
              },
              in_person: {
                type: "Virtus::Attribute::Boolean"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "name",
            "total_amount",
            "deposit_amount",
            "number_of_days"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a specific occasion",
              get: true
            },
            {
              name: "id",
              description: "Update a occasion",
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: ""
                  },
                  color: {
                    type: "String",
                    allow_blank: false,
                    desc: "hex value representing a color, such as #112233"
                  },
                  description: {
                    type: "String",
                    desc: ""
                  },
                  total_amount: {
                    type: "BigDecimal",
                    coerce_with: "APICoercions::MoneyToBigDecimal",
                    desc: "if classes are included in a subscription, then this will be the price for additional sessions above and beyond those included in the membership. for something like summer camp, this is the total payment for the session"
                  },
                  deposit_amount: {
                    type: "BigDecimal",
                    coerce_with: "APICoercions::MoneyToBigDecimal",
                    desc: "if this session requires a deposit to hold it, then this is the deposit amount this will be subtracted automatically from the price above"
                  },
                  subscription_required: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "set to true, if accessing this slot type requires a valid subscription this is true for membership and related slots such as flex and emergency but false for one off sessions like summer camps"
                  },
                  number_of_days: {
                    type: "Integer",
                    desc: "how mnay consecutive days does this slot last for. Summer camps are 5, normal sessions are 1 this is used to determine capacity at the studio and what days the users account will be active"
                  },
                  whole_studio: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "when at least one person books this slot, does it take over the whole studio and prevent booking types"
                  },
                  recurring: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "does this occasion allow recurring bookings - i.e. memberships do, summer camps and trials do not"
                  },
                  dynamic_capacity: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "does this slot accept dynamic capacities"
                  },
                  students_per_guide: {
                    type: "Integer",
                    desc: "ideal number of students to each guide"
                  },
                  advance_bookable_days: {
                    type: "Integer",
                    desc: "number of days in advance bookings can be made of this occasion type"
                  },
                  buffer_minutes_before: {
                    type: "Integer",
                    desc: "buffer size in minutes before a matched booking which a schedule will be blocked off"
                  },
                  buffer_minutes_after: {
                    type: "Integer",
                    desc: "buffer size in minutes before a matched booking which a schedule will be blocked off"
                  },
                  in_person: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "does this occasion happen in person (requires a location) or is it virtual"
                  },
                  room_type: {
                    type: "Symbol",
                    values: [
                      "group-small",
                      "group"
                    ],
                    desc: "null, group-small and group"
                  },
                  highlight_1: {
                    type: "String"
                  },
                  highlight_1_icon_name: {
                    type: "String"
                  },
                  highlight_2: {
                    type: "String"
                  },
                  highlight_2_icon_name: {
                    type: "String"
                  },
                  highlight_3: {
                    type: "String"
                  },
                  highlight_3_icon_name: {
                    type: "String"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a occasion",
              delete: true
            },
            {
              name: "id",
              resources: {
                slots: {
                  name: "slots",
                  description: "List of slots for this occasion",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      location_id: {
                        uuid: true
                      },
                      date: {
                        type: "Date",
                        desc: "the date of a hypothetical booking"
                      },
                      start_hour: {
                        type: "Integer",
                        desc: "the hour of the day that the slot starts"
                      },
                      start_minute: {
                        type: "Integer",
                        desc: "the minute of the day that the slot starts"
                      },
                      end_hour: {
                        type: "Integer",
                        desc: "the hour of the day that the slot ends"
                      },
                      end_minute: {
                        type: "Integer",
                        desc: "the minute of the day that the slot ends"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at",
                    "first_available_at",
                    "last_available_at",
                    "start_hour",
                    "end_hour",
                    "capacity"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                coupons: {
                  name: "coupons",
                  resources: {
                    validate: {
                      name: "validate",
                      params: {
                        requires: {
                          coupon_code: {
                            type: "String",
                            desc: "A coupon code"
                          }
                        },
                        optional: {}
                      },
                      get: true
                    }
                  }
                }
              }
            }
          ]
        },
        "Organizations::MerchantAccount": {
          name: "schools",
          description: "A public method to search for schools which have automatic_account_creation=true",
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search the school name"
              },
              automatic_account_creation: {
                type: "Virtus::Attribute::Boolean",
                desc: "true of false for the value of automatic_account_creation, null for all"
              },
              zip_code: {
                type: "String",
                desc: "zip_code to filter schools by distance"
              }
            }
          },
          get: true,
          paginate_params: true
        },
        "Organizations::Organization": {
          name: "organizations",
          description: "Returns all organizations",
          create_options: [
            {
              optional_relationships: [
                {
                  name: "owner",
                  as: "user"
                },
                "location"
              ]
            }
          ],
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                desc: "This organizations name"
              },
              classification: {
                type: "Symbol",
                values: [
                  "school",
                  "internal",
                  "household",
                  "club",
                  "guide",
                  "influencer"
                ],
                desc: "school, internal, household, club, guide or influencer"
              }
            },
            optional: {
              automatic_account_creation: {
                type: "Virtus::Attribute::Boolean"
              },
              referral_code: {
                type: "String",
                desc: "optional referral code if this organization was referred"
              },
              logo: {
                type: "String",
                desc: "This organizations logo which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              },
              first_journey: {
                type: "String",
                desc: "The first journey this organization will be placed in"
              },
              founding_family: {
                type: "Virtus::Attribute::Boolean",
                desc: "Is this organization enrolled in our founding families program"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              ids: {
                type: "Array"
              },
              classification: {
                type: "Symbol",
                values: [
                  "school",
                  "internal",
                  "household",
                  "club",
                  "guide",
                  "influencer"
                ],
                desc: "should be either household, club, school, guide, or internal"
              },
              status: {
                type: "Symbol",
                values: [
                  "new",
                  "lead",
                  "freemium",
                  "trial",
                  "pending",
                  "active"
                ],
                desc: "should be either lead, freemium, trial, or active"
              },
              q: {
                type: "String",
                desc: "search the organization name and names and email addresses of everyone in the organization"
              },
              email: {
                type: "String",
                desc: "organizations which have members with the provided email address"
              },
              phone_number: {
                type: "String",
                desc: "organizations which have members with the provided phone number"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a organization",
              get: true
            },
            {
              name: "id",
              description: "Update a organization",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    {
                      name: "duplicate_of",
                      as: "organization"
                    },
                    {
                      name: "referred_by",
                      as: "user"
                    },
                    "location"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    allow_blank: false,
                    desc: "This organizations name"
                  },
                  classification: {
                    type: "Symbol",
                    values: [
                      "school",
                      "internal",
                      "household",
                      "club",
                      "guide",
                      "influencer"
                    ],
                    desc: "should be either household, club, school, internal or guide"
                  },
                  automatic_account_creation: {
                    type: "Virtus::Attribute::Boolean"
                  },
                  referral_code: {
                    type: "String",
                    desc: "optional referral code if this organization was referred"
                  },
                  logo: {
                    type: "String",
                    desc: "This organizations logo which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  },
                  status: {
                    type: "Symbol",
                    values: [
                      "new",
                      "lead",
                      "freemium",
                      "trial",
                      "pending",
                      "active"
                    ],
                    desc: "should be either active, freemium or trial"
                  },
                  founding_family: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Is this organization enrolled in our founding families program"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a organization",
              delete: true
            },
            {
              name: "id",
              resources: {
                invoices: {
                  name: "invoices",
                  description: "List of invoices for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                users: {
                  name: "users",
                  description: "List of users for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      name: {
                        type: "String",
                        desc: "search the users by name"
                      },
                      scope: {
                        type: "Symbol",
                        values: [
                          "account",
                          "administrator",
                          "child",
                          "guide"
                        ],
                        desc: "can be either account, administrator or child"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                subscriptions: {
                  name: "subscriptions",
                  description: "List of subscriptions for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      status: {
                        type: "Symbol",
                        desc: "a single status"
                      },
                      statuses: {
                        type: "Array",
                        desc: "array of statuses"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                groups: {
                  name: "groups",
                  description: "List of groups for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                memberships: {
                  name: "memberships",
                  description: "List of memberships for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      role: {
                        type: "Symbol",
                        values: [
                          "ownership",
                          "instructorship",
                          "studentship",
                          "pickupship",
                          "attendship"
                        ],
                        desc: "the users rope (permission level) at this organization, should be either ownership, instructorship or studentship"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  resources: {
                    exists: {
                      name: "exists",
                      params: {
                        requires: {
                          badge: {
                            type: "String",
                            desc: "A badge for a user at this organization"
                          }
                        },
                        optional: {}
                      },
                      get: true
                    }
                  }
                }
              }
            },
            {
              name: "id",
              resources: {
                bookings: {
                  name: "bookings",
                  description: "List of bookings for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      status: {
                        type: "Symbol",
                        desc: "a single status",
                        values: [
                          "held",
                          "deposit_invoiced",
                          "deposit_invoice_past_due",
                          "invoiced",
                          "invoice_past_due",
                          "attaching_to_subscription",
                          "pending",
                          "active",
                          "completing",
                          "completed"
                        ]
                      },
                      statuses: {
                        type: "Array",
                        desc: "array of statuses"
                      },
                      occasion_id: {
                        type: "UUID",
                        desc: "a single of occasion id"
                      },
                      occasion_ids: {
                        type: "Array",
                        desc: "an array of of occasion ids"
                      },
                      user_id: {
                        type: "UUID",
                        desc: "a single user id"
                      },
                      user_ids: {
                        type: "Array",
                        desc: "array of occasion ids"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at",
                    "first_visit_at",
                    "last_visit_at",
                    "start_hour",
                    "end_hour"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                booking_instances: {
                  name: "booking_instances",
                  description: "Returns all booking_instances for this organization",
                  filter_params: {
                    requires: {},
                    optional: {
                      after: {
                        type: "Date",
                        desc: "filter by date"
                      },
                      before: {
                        type: "Date",
                        desc: "filter by date"
                      },
                      start_hour: {
                        type: "Integer",
                        desc: "the hour of the day that the booking starts"
                      },
                      start_minute: {
                        type: "Integer",
                        desc: "the minute of the day that the booking starts"
                      },
                      end_hour: {
                        type: "Integer",
                        desc: "the hour of the day that the booking ends"
                      },
                      end_minute: {
                        type: "Integer",
                        desc: "the minute of the day that the booking ends"
                      },
                      location_id: {
                        type: "UUID"
                      },
                      location_ids: {
                        type: "Array"
                      },
                      user_id: {
                        type: "UUID"
                      },
                      user_ids: {
                        type: "Array"
                      },
                      occasion_id: {
                        type: "UUID"
                      },
                      occasion_ids: {
                        type: "Array"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at",
                    "date",
                    "start_hour"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                referred_by: {
                  name: "referred_by",
                  description: "List of referred users for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                notes: {
                  name: "notes",
                  description: "List of notes for this organization",
                  filter_options: [
                    {
                      deletable: true,
                      pinnable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      topic: {
                        type: "Symbol",
                        values: [
                          "comments",
                          "progress",
                          "goals",
                          "feedback",
                          "concerns",
                          "sales",
                          "learning_styles",
                          "parent_update"
                        ],
                        desc: "comments, progress, goals, feedback, concerns, sales, learning_styles or parent_update"
                      },
                      topics: {
                        type: "Array",
                        desc: "array of topics"
                      },
                      q: {
                        type: "String",
                        desc: "search the notes"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at",
                    "pinned_at"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                leads: {
                  name: "leads",
                  description: "List of leads for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                lead_tasks: {
                  name: "lead_tasks",
                  description: "List of lead_tasks for this organization",
                  filter_options: [
                    {
                      deletable: true,
                      completable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search by string"
                      },
                      ids: {
                        type: "Array"
                      },
                      author_id: {
                        type: "UUID"
                      },
                      assignor_id: {
                        type: "UUID"
                      },
                      assignee_id: {
                        type: "UUID"
                      },
                      staff_team_id: {
                        type: "UUID"
                      },
                      due_after: {
                        type: "Date",
                        desc: "filter by due date"
                      },
                      due_before: {
                        type: "Date",
                        desc: "filter by due date"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at",
                    "due_at",
                    "completed_at",
                    "updated_at"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                emails: {
                  name: "emails",
                  description: "List of emails for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                text_messages: {
                  name: "text_messages",
                  description: "List of text_messages for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                phone_conversations: {
                  name: "phone_conversations",
                  description: "List of phone_conversations for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                phone_calls: {
                  name: "phone_calls",
                  description: "List of phone_calls for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                phone_numbers: {
                  name: "phone_numbers",
                  description: "List of phone_numbers for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                payment_methods: {
                  name: "payment_methods",
                  description: "List of payment_methods for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                health_records: {
                  name: "health_records",
                  description: "List of health_records for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                learning_styles: {
                  name: "learning_styles",
                  description: "List of learning_styles for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                organization_addresses: {
                  name: "organization_addresses",
                  description: "List of addresses for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                user_addresses: {
                  name: "user_addresses",
                  description: "List of user_addresses for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                contract_executions: {
                  name: "contract_executions",
                  description: "List of contract_executions for this organization",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                credits: {
                  name: "credits",
                  description: "List of credits for this organization",
                  filter_options: [
                    {
                      deletable: true,
                      usable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      source: {
                        type: "Symbol",
                        values: [
                          "subscription",
                          "promotion",
                          "loyalty",
                          "adjustment",
                          "overage"
                        ],
                        desc: "subscription, promotion, loyalty, adjustment or overage"
                      },
                      sources: {
                        type: "Array",
                        desc: "array of sources"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at",
                    "used_at"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                opportunities: {
                  name: "opportunities",
                  description: "List of opportunities for this organization",
                  filter_options: [
                    {
                      completable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      journey: {
                        type: "Symbol",
                        values: [
                          "virtual_classes_lead",
                          "virtual_classes_prospect",
                          "gift_of_code",
                          "kid_player",
                          "adult_player_high_intent",
                          "adult_player_low_intent",
                          "influencer_program_lead",
                          "collect_learning_styles",
                          "missed_trial_session",
                          "virtual_trial_booked",
                          "virtual_trial_follow_up",
                          "virtual_trial_period",
                          "canceled_member",
                          "missed_member_session",
                          "past_due_subscription",
                          "unhappy_survey",
                          "unused_credits",
                          "guide_certification",
                          "guide_contractor_agreement_signed",
                          "guide_onboarding",
                          "ussc_virtual_camp_booked",
                          "ussc_virtual_camp_follow_up",
                          "partner_group_class_booked",
                          "partner_group_class_follow_up",
                          "conversion_stream_registered",
                          "conversion_stream_follow_up",
                          "acquisition_stream_registered",
                          "acquisition_stream_follow_up",
                          "on_demand_stream_registered",
                          "on_demand_stream_follow_up"
                        ],
                        desc: "the journey"
                      },
                      journeys: {
                        type: "Array",
                        desc: "array of journeys"
                      },
                      owner_id: {
                        type: "UUID"
                      },
                      staff_team_id: {
                        type: "UUID"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at",
                    "updated_at",
                    "completed_at"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                assignments: {
                  name: "assignments",
                  description: "List of assignments for this organization",
                  filter_options: [
                    {
                      resolvable: true,
                      cancelable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search by string"
                      },
                      ids: {
                        type: "Array"
                      },
                      assignor_id: {
                        type: "UUID"
                      },
                      owner_id: {
                        type: "UUID"
                      },
                      staff_team_id: {
                        type: "UUID"
                      },
                      due_after: {
                        type: "Date",
                        desc: "filter by due date"
                      },
                      due_before: {
                        type: "Date",
                        desc: "filter by due date"
                      },
                      topic: {
                        type: "Symbol",
                        values: [
                          "virtual_classes_lead/phone_call",
                          "virtual_classes_lead/inbound_communication",
                          "virtual_classes_prospect/phone_call",
                          "virtual_classes_prospect/inbound_communication",
                          "influencer_program_lead/phone_call",
                          "influencer_program_lead/inbound_communication",
                          "conversion_stream_follow_up/phone_call",
                          "conversion_stream_follow_up/inbound_communication",
                          "acquisition_stream_follow_up/phone_call",
                          "acquisition_stream_follow_up/inbound_communication",
                          "on_demand_stream_follow_up/phone_call",
                          "on_demand_stream_follow_up/inbound_communication",
                          "collect_learning_styles/phone_call",
                          "collect_learning_styles/inbound_communication",
                          "missed_trial_session/phone_call",
                          "virtual_trial_period/inbound_communication",
                          "virtual_trial_follow_up/phone_call",
                          "canceled_member/account_review",
                          "canceled_member/phone_call",
                          "missed_member_session/phone_call",
                          "past_due_subscription/phone_call",
                          "unhappy_survey/review",
                          "unhappy_survey/escalated_review",
                          "unhappy_survey/phone_call",
                          "unused_credits/phone_call",
                          "guide_certification/training_review",
                          "guide_contractor_agreement_signed/renewal_review",
                          "guide_contractor_agreement_signed/termination_follow_up",
                          "guide_onboarding/training_review",
                          "guide_onboarding/checkout_review",
                          "partner_group_class_follow_up/phone_call",
                          "ussc_virtual_camp_follow_up/phone_call"
                        ],
                        desc: "the topic"
                      },
                      topics: {
                        type: "Array",
                        desc: "array of topics"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at",
                    "due_at",
                    "resolved_at",
                    "canceled_at",
                    "updated_at"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                participations: {
                  name: "participations",
                  description: "List of participations for this user",
                  filter_params: {
                    requires: {},
                    optional: {
                      include_abandoned: {
                        type: "Virtus::Attribute::Boolean",
                        desc: "include participations which have been abandoned"
                      },
                      include_past: {
                        type: "Virtus::Attribute::Boolean",
                        desc: "include participations for meetings which ended in the past"
                      },
                      status: {
                        type: "Symbol",
                        values: [
                          "new",
                          "joined",
                          "left",
                          "ended",
                          "abandoned",
                          "illegal_abandoned",
                          "no_show",
                          "guide_abandoned",
                          "guide_no_show"
                        ],
                        desc: [
                          "new",
                          "joined",
                          "left",
                          "ended",
                          "abandoned",
                          "illegal_abandoned",
                          "no_show",
                          "guide_abandoned",
                          "guide_no_show"
                        ]
                      },
                      statuses: {
                        type: "Array",
                        desc: "array of statuses"
                      },
                      user_id: {
                        type: "UUID"
                      },
                      user_ids: {
                        type: "Array"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                streaming_registrations: {
                  name: "streaming_registrations",
                  description: "List of registrations for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      stream_id: {
                        type: "UUID",
                        desc: "a single stream_id"
                      },
                      stream_ids: {
                        type: "Array",
                        desc: "an array of stream_ids"
                      },
                      registrant_id: {
                        type: "UUID",
                        desc: "a single registrant id"
                      },
                      registrant_ids: {
                        type: "Array",
                        desc: "an array of registrant ids"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                streaming_viewers: {
                  name: "streaming_viewers",
                  description: "List of viewers for this organization",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      stream_id: {
                        type: "UUID",
                        desc: "a single stream_id"
                      },
                      stream_ids: {
                        type: "Array",
                        desc: "an array of stream_ids"
                      },
                      user_id: {
                        type: "UUID",
                        desc: "a single user id"
                      },
                      user_ids: {
                        type: "Array",
                        desc: "an array of user ids"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at"
                  ]
                }
              }
            }
          ]
        },
        "Billing::PaymentMethod": {
          name: "payment_methods",
          description: "Returns all payment_methods",
          create_options: [
            {
              optional_relationships: [
                "user"
              ]
            }
          ],
          create_params: {
            requires: {
              payment_method_nonce: {
                type: "String",
                allow_blank: false,
                desc: "The braintree nonce representing this credit card"
              }
            },
            optional: {
              default: {
                type: "Virtus::Attribute::Boolean",
                default: false
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              ids: {
                type: "Array"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a payment_method",
              get: true
            }
          ]
        },
        "Communication::Phone": {
          name: "phones",
          description: "Returns all phones",
          create_options: [
            {
              optional_relationships: [
                "user",
                "location",
                {
                  name: "failover_phone_number",
                  as: "phone_number"
                }
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              username: {
                type: "String",
                desc: "Username of this phone"
              },
              extension: {
                type: "Integer",
                desc: "Extension of this phone"
              },
              description: {
                type: "String",
                desc: "Description of this phone"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search the phones by name"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a phone",
              get: true
            },
            {
              name: "id",
              description: "Update a phone",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    {
                      name: "failover_phone_number",
                      as: "phone_number"
                    }
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  username: {
                    type: "String",
                    desc: "Username of this phone"
                  },
                  extension: {
                    type: "Integer",
                    desc: "Extension of this phone"
                  },
                  description: {
                    type: "String",
                    desc: "Description of this phone"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a phone",
              delete: true
            },
            {
              name: "id",
              resources: {
                user: {
                  name: "user",
                  description: "Get a user for this phone",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                location: {
                  name: "location",
                  description: "Get a location for this phone",
                  get: true
                }
              }
            }
          ]
        },
        "Communication::PhoneCalls::PhoneCall": {
          name: "phone_calls",
          description: "Returns all phone_calls",
          create_params: {
            requires: {
              comment: {
                type: "String",
                allow_blank: false,
                desc: "Comment of this phone_call"
              },
              to_dialing_code: {
                type: "String",
                allow_blank: false,
                values: [
                  "1",
                  "20",
                  "211",
                  "212",
                  "213",
                  "216",
                  "218",
                  "220",
                  "221",
                  "222",
                  "223",
                  "224",
                  "225",
                  "226",
                  "227",
                  "228",
                  "229",
                  "230",
                  "231",
                  "232",
                  "233",
                  "234",
                  "235",
                  "236",
                  "237",
                  "238",
                  "239",
                  "240",
                  "241",
                  "242",
                  "243",
                  "244",
                  "245",
                  "246",
                  "248",
                  "249",
                  "250",
                  "251",
                  "252",
                  "253",
                  "254",
                  "255",
                  "256",
                  "257",
                  "258",
                  "260",
                  "261",
                  "262",
                  "263",
                  "264",
                  "265",
                  "266",
                  "267",
                  "268",
                  "269",
                  "27",
                  "290",
                  "291",
                  "297",
                  "298",
                  "299",
                  "30",
                  "31",
                  "32",
                  "33",
                  "34",
                  "350",
                  "351",
                  "352",
                  "353",
                  "354",
                  "355",
                  "356",
                  "357",
                  "358",
                  "359",
                  "36",
                  "370",
                  "371",
                  "372",
                  "373",
                  "374",
                  "375",
                  "376",
                  "377",
                  "378",
                  "380",
                  "381",
                  "382",
                  "385",
                  "386",
                  "387",
                  "389",
                  "39",
                  "40",
                  "41",
                  "420",
                  "421",
                  "423",
                  "43",
                  "44",
                  "45",
                  "46",
                  "47",
                  "48",
                  "49",
                  "500",
                  "501",
                  "502",
                  "503",
                  "504",
                  "505",
                  "506",
                  "507",
                  "508",
                  "509",
                  "51",
                  "52",
                  "53",
                  "54",
                  "55",
                  "56",
                  "57",
                  "58",
                  "590",
                  "591",
                  "592",
                  "593",
                  "594",
                  "595",
                  "596",
                  "597",
                  "598",
                  "599",
                  "60",
                  "61",
                  "62",
                  "63",
                  "64",
                  "65",
                  "66",
                  "670",
                  "672",
                  "673",
                  "674",
                  "675",
                  "676",
                  "677",
                  "678",
                  "679",
                  "680",
                  "681",
                  "682",
                  "683",
                  "685",
                  "686",
                  "687",
                  "688",
                  "689",
                  "690",
                  "691",
                  "692",
                  "7",
                  "81",
                  "82",
                  "84",
                  "850",
                  "852",
                  "853",
                  "855",
                  "856",
                  "86",
                  "880",
                  "886",
                  "90",
                  "91",
                  "92",
                  "93",
                  "94",
                  "95",
                  "960",
                  "961",
                  "962",
                  "963",
                  "964",
                  "965",
                  "966",
                  "967",
                  "968",
                  "970",
                  "971",
                  "972",
                  "973",
                  "974",
                  "975",
                  "976",
                  "977",
                  "98",
                  "992",
                  "993",
                  "994",
                  "995",
                  "996",
                  "998"
                ],
                desc: "a valid country dialing code, i.e. 1 for the US and 44 for the UK"
              },
              to_phone_number: {
                type: "String",
                allow_blank: false,
                desc: "To Phone Number of this phone_call"
              }
            },
            optional: {}
          },
          filter_options: [
            {
              handleable: true,
              claimable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              leg: {
                type: "Symbol",
                values: [
                  "inbound",
                  "outbound",
                  "queue_invitation",
                  "click_to_dial",
                  "studio_invitation"
                ],
                desc: "a phone call leg"
              },
              legs: {
                type: "Array",
                desc: "array of legs"
              },
              status: {
                type: "Symbol",
                values: [
                  "new",
                  "skipped",
                  "queued",
                  "recieved",
                  "in_call_queue",
                  "answered",
                  "sent_to_voicemail",
                  "completed",
                  "failed"
                ],
                desc: "a phone call status"
              },
              statuses: {
                type: "Array",
                desc: "array of statuses"
              },
              answered_by: {
                type: "Symbol",
                values: [
                  "human",
                  "machine"
                ],
                desc: ""
              },
              termination_status: {
                type: "Symbol",
                values: [
                  "busy",
                  "canceled",
                  "completed",
                  "failed",
                  "no_answer"
                ],
                desc: ""
              },
              staff_team_id: {
                type: "UUID"
              },
              claimed_by_id: {
                type: "UUID"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "handled_at"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a phone_call",
              get: true
            },
            {
              name: "id",
              description: "Update a phone_call",
              update_options: [
                {
                  handleable: true,
                  claimable: true,
                  optional_relationships: [
                    "staff_team"
                  ]
                }
              ],
              put: true
            },
            {
              name: "id",
              resources: {
                organizations: {
                  name: "organizations",
                  description: "List of organizations for this phone_call",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                notes: {
                  name: "notes",
                  description: "List of notes for this phone_call",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Communication::PhoneConversation": {
          name: "phone_conversations",
          description: "Returns all phone_conversations",
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a phone_conversation",
              get: true
            }
          ]
        },
        "Users::PhoneNumber": {
          name: "phone_numbers",
          description: "Returns all phone_numbers",
          create_options: [
            {
              optional_relationships: [
                "organization",
                "user"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              dialing_code: {
                type: "String",
                values: [
                  "1",
                  "20",
                  "211",
                  "212",
                  "213",
                  "216",
                  "218",
                  "220",
                  "221",
                  "222",
                  "223",
                  "224",
                  "225",
                  "226",
                  "227",
                  "228",
                  "229",
                  "230",
                  "231",
                  "232",
                  "233",
                  "234",
                  "235",
                  "236",
                  "237",
                  "238",
                  "239",
                  "240",
                  "241",
                  "242",
                  "243",
                  "244",
                  "245",
                  "246",
                  "248",
                  "249",
                  "250",
                  "251",
                  "252",
                  "253",
                  "254",
                  "255",
                  "256",
                  "257",
                  "258",
                  "260",
                  "261",
                  "262",
                  "263",
                  "264",
                  "265",
                  "266",
                  "267",
                  "268",
                  "269",
                  "27",
                  "290",
                  "291",
                  "297",
                  "298",
                  "299",
                  "30",
                  "31",
                  "32",
                  "33",
                  "34",
                  "350",
                  "351",
                  "352",
                  "353",
                  "354",
                  "355",
                  "356",
                  "357",
                  "358",
                  "359",
                  "36",
                  "370",
                  "371",
                  "372",
                  "373",
                  "374",
                  "375",
                  "376",
                  "377",
                  "378",
                  "380",
                  "381",
                  "382",
                  "385",
                  "386",
                  "387",
                  "389",
                  "39",
                  "40",
                  "41",
                  "420",
                  "421",
                  "423",
                  "43",
                  "44",
                  "45",
                  "46",
                  "47",
                  "48",
                  "49",
                  "500",
                  "501",
                  "502",
                  "503",
                  "504",
                  "505",
                  "506",
                  "507",
                  "508",
                  "509",
                  "51",
                  "52",
                  "53",
                  "54",
                  "55",
                  "56",
                  "57",
                  "58",
                  "590",
                  "591",
                  "592",
                  "593",
                  "594",
                  "595",
                  "596",
                  "597",
                  "598",
                  "599",
                  "60",
                  "61",
                  "62",
                  "63",
                  "64",
                  "65",
                  "66",
                  "670",
                  "672",
                  "673",
                  "674",
                  "675",
                  "676",
                  "677",
                  "678",
                  "679",
                  "680",
                  "681",
                  "682",
                  "683",
                  "685",
                  "686",
                  "687",
                  "688",
                  "689",
                  "690",
                  "691",
                  "692",
                  "7",
                  "81",
                  "82",
                  "84",
                  "850",
                  "852",
                  "853",
                  "855",
                  "856",
                  "86",
                  "880",
                  "886",
                  "90",
                  "91",
                  "92",
                  "93",
                  "94",
                  "95",
                  "960",
                  "961",
                  "962",
                  "963",
                  "964",
                  "965",
                  "966",
                  "967",
                  "968",
                  "970",
                  "971",
                  "972",
                  "973",
                  "974",
                  "975",
                  "976",
                  "977",
                  "98",
                  "992",
                  "993",
                  "994",
                  "995",
                  "996",
                  "998"
                ],
                desc: "a valid country dialing code, i.e. 1 for the US and 44 for the UK"
              },
              phone_number: {
                type: "String",
                desc: "Phone Number of this phone_number"
              },
              default: {
                type: "Virtus::Attribute::Boolean",
                desc: "Is this the users default preferred number"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a phone_number",
              get: true
            },
            {
              name: "id",
              description: "Update a phone_number",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  dialing_code: {
                    type: "String",
                    values: [
                      "1",
                      "20",
                      "211",
                      "212",
                      "213",
                      "216",
                      "218",
                      "220",
                      "221",
                      "222",
                      "223",
                      "224",
                      "225",
                      "226",
                      "227",
                      "228",
                      "229",
                      "230",
                      "231",
                      "232",
                      "233",
                      "234",
                      "235",
                      "236",
                      "237",
                      "238",
                      "239",
                      "240",
                      "241",
                      "242",
                      "243",
                      "244",
                      "245",
                      "246",
                      "248",
                      "249",
                      "250",
                      "251",
                      "252",
                      "253",
                      "254",
                      "255",
                      "256",
                      "257",
                      "258",
                      "260",
                      "261",
                      "262",
                      "263",
                      "264",
                      "265",
                      "266",
                      "267",
                      "268",
                      "269",
                      "27",
                      "290",
                      "291",
                      "297",
                      "298",
                      "299",
                      "30",
                      "31",
                      "32",
                      "33",
                      "34",
                      "350",
                      "351",
                      "352",
                      "353",
                      "354",
                      "355",
                      "356",
                      "357",
                      "358",
                      "359",
                      "36",
                      "370",
                      "371",
                      "372",
                      "373",
                      "374",
                      "375",
                      "376",
                      "377",
                      "378",
                      "380",
                      "381",
                      "382",
                      "385",
                      "386",
                      "387",
                      "389",
                      "39",
                      "40",
                      "41",
                      "420",
                      "421",
                      "423",
                      "43",
                      "44",
                      "45",
                      "46",
                      "47",
                      "48",
                      "49",
                      "500",
                      "501",
                      "502",
                      "503",
                      "504",
                      "505",
                      "506",
                      "507",
                      "508",
                      "509",
                      "51",
                      "52",
                      "53",
                      "54",
                      "55",
                      "56",
                      "57",
                      "58",
                      "590",
                      "591",
                      "592",
                      "593",
                      "594",
                      "595",
                      "596",
                      "597",
                      "598",
                      "599",
                      "60",
                      "61",
                      "62",
                      "63",
                      "64",
                      "65",
                      "66",
                      "670",
                      "672",
                      "673",
                      "674",
                      "675",
                      "676",
                      "677",
                      "678",
                      "679",
                      "680",
                      "681",
                      "682",
                      "683",
                      "685",
                      "686",
                      "687",
                      "688",
                      "689",
                      "690",
                      "691",
                      "692",
                      "7",
                      "81",
                      "82",
                      "84",
                      "850",
                      "852",
                      "853",
                      "855",
                      "856",
                      "86",
                      "880",
                      "886",
                      "90",
                      "91",
                      "92",
                      "93",
                      "94",
                      "95",
                      "960",
                      "961",
                      "962",
                      "963",
                      "964",
                      "965",
                      "966",
                      "967",
                      "968",
                      "970",
                      "971",
                      "972",
                      "973",
                      "974",
                      "975",
                      "976",
                      "977",
                      "98",
                      "992",
                      "993",
                      "994",
                      "995",
                      "996",
                      "998"
                    ],
                    desc: "a valid country dialing code, i.e. 1 for the US and 44 for the UK"
                  },
                  phone_number: {
                    type: "String",
                    desc: "Phone Number of this phone_number"
                  },
                  default: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Default of this phone_number"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a phone_number",
              delete: true
            }
          ]
        },
        "Studios::Photo": {
          name: "photos",
          description: "Returns all photos",
          create_options: [
            {
              required_relationships: [
                "location"
              ]
            }
          ],
          create_params: {
            requires: {
              file: {
                type: "String",
                allow_blank: false,
                desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/jpeg;base64,iVBORw0KGgo...\""
              }
            },
            optional: {
              caption: {
                type: "String",
                desc: "Caption of this product_photo"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account",
            "photos"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a photo",
              get: true
            },
            {
              name: "id",
              description: "Update a photo",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  caption: {
                    type: "String",
                    desc: "Caption for this photo"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a photo",
              delete: true
            }
          ]
        },
        "Studios::PhotoInvolvement": {
          name: "photo_involvements",
          description: "Returns all photo_involvements",
          create_options: [
            {
              required_relationships: [
                "photo",
                "attendance"
              ]
            }
          ],
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a photo_involvement",
              get: true
            },
            {
              name: "id",
              description: "Delete a photo_involvement",
              delete: true
            }
          ]
        },
        "Curriculum::Progress": {
          name: "progresses",
          description: "Returns all progresses",
          create_options: [
            {
              optional_relationships: [
                "user"
              ],
              required_relationships: [
                "tutorial"
              ]
            }
          ],
          filter_options: [
            {
              publishable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              user_id: {
                uuid: true,
                desc: "The user the results will be scoped to"
              },
              tutorial_id: {
                uuid: true,
                desc: "Optionally, a tutorial_id to scope the resuls to"
              },
              step_id: {
                uuid: true,
                desc: "Optionally, a step_id to scope the resuls to"
              },
              project_id: {
                uuid: true,
                desc: "Optionally, a project_id to scope the resuls to"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a progress",
              get: true
            },
            {
              name: "id",
              description: "Update a progress",
              update_options: [
                {
                  required_relationships: [
                    "step"
                  ]
                }
              ],
              put: true
            },
            {
              name: "id",
              resources: {
                project: {
                  name: "project",
                  description: "Get a project for this progress",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                step: {
                  name: "step",
                  description: "Get a step for this progress",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                tutorial: {
                  name: "tutorial",
                  description: "Get a tutorial for this progress",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                user: {
                  name: "user",
                  description: "Get a user for this progress",
                  get: true
                }
              }
            }
          ]
        },
        "Marketing::PublicSession": {
          name: "public_sessions",
          description: "Create a session.",
          create_options: [
            {
              optional_relationships: [
                "version"
              ]
            }
          ],
          create_params: {
            requires: {
              id: {
                uuid: true,
                desc: "A client generated UUID to represent this session"
              },
              client_token: {
                uuid: true,
                desc: "A client generated UUID to represent this device across multiple session"
              }
            },
            optional: {
              user_agent: {
                type: "String",
                desc: "The user_agent string from the client"
              },
              previous_http_referer: {
                type: "String",
                desc: "The referer string from the client (not the current page)"
              },
              landing_page: {
                type: "String",
                desc: "The landing_page string from the client"
              },
              referring_domain: {
                type: "String",
                desc: "The referring_domain string from the client"
              },
              search_keyword: {
                type: "String",
                desc: "The search_keyword string from the client"
              },
              browser: {
                type: "String",
                desc: "The browser string from the client"
              },
              os: {
                type: "String",
                desc: "The os string from the client"
              },
              os_version: {
                type: "String",
                desc: "The os_version string from the client"
              },
              device_type: {
                type: "String",
                desc: "The device_type string from the client"
              },
              screen_height: {
                type: "Integer",
                desc: "The screen_height string from the client"
              },
              screen_width: {
                type: "Integer",
                desc: "The screen_width string from the client"
              },
              utm_source: {
                type: "String",
                desc: "The utm_source string from the client"
              },
              utm_medium: {
                type: "String",
                desc: "The utm_medium string from the client"
              },
              utm_term: {
                type: "String",
                desc: "The utm_term string from the client"
              },
              utm_content: {
                type: "String",
                desc: "The utm_content string from the client"
              },
              utm_campaign: {
                type: "String",
                desc: "The utm_campaign string from the client"
              },
              fbclid: {
                type: "String",
                desc: "The facebook ad id"
              },
              gclid: {
                type: "String",
                desc: "The google ad id"
              },
              test_version: {
                type: "String",
                desc: "The test_version string from the client"
              },
              platform: {
                type: "String",
                desc: "The platform string from the client"
              },
              app_version: {
                type: "String",
                desc: "The app_version string from the client"
              }
            }
          },
          post: true
        },
        "Products::TraitValue": {
          name: "product_trait_values",
          description: "Returns all product_trait_values",
          create_options: [
            {
              required_relationships: [
                "product_trait"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              value: {
                type: "String",
                desc: "Value of this product_trait_value"
              },
              sku_code: {
                type: "String",
                desc: "Sku Code of this product_trait_value"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a product_trait_value",
              get: true
            },
            {
              name: "id",
              description: "Update a product_trait_value",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  value: {
                    type: "String",
                    desc: "Value of this product_trait_value"
                  },
                  sku_code: {
                    type: "String",
                    desc: "Sku Code of this product_trait_value"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a product_trait_value",
              delete: true
            },
            {
              name: "id",
              resources: {
                product_trait: {
                  name: "product_trait",
                  description: "Get a trait for this product_trait_value",
                  get: true
                }
              }
            }
          ]
        },
        "Products::Trait": {
          name: "product_traits",
          description: "Returns all product_traits",
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                desc: "Name of this product_trait"
              },
              sku_code: {
                type: "String",
                allow_blank: false,
                desc: "Sku Code of this product_trait"
              }
            },
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a product_trait",
              get: true
            },
            {
              name: "id",
              description: "Update a product_trait",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this product_trait"
                  },
                  sku_code: {
                    type: "String",
                    desc: "Sku Code of this product_trait"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a product_trait",
              delete: true
            },
            {
              name: "id",
              resources: {
                product_trait_values: {
                  name: "product_trait_values",
                  description: "List of trait_values for this product_trait",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Products::Inventory": {
          name: "product_inventories",
          description: "Returns all product_inventories",
          create_options: [
            {
              required_relationships: [
                "location",
                "product_sku_trait_value"
              ]
            }
          ],
          create_params: {
            requires: {
              quantity: {
                type: "Integer",
                desc: "Quantity of this product_inventory"
              }
            },
            optional: {
              details: {
                type: "String",
                desc: "Details of this product_inventory"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a product_inventory",
              get: true
            },
            {
              name: "id",
              description: "Update a product_inventory",
              update_params: {
                requires: {},
                optional: {
                  quantity: {
                    type: "Integer",
                    desc: "Quantity of this product_inventory"
                  },
                  details: {
                    type: "String",
                    desc: "Details of this product_inventory"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                location: {
                  name: "location",
                  description: "Get a location for this product_inventory",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                product_sku_trait_value: {
                  name: "product_sku_trait_value",
                  description: "Get a sku_trait_value for this product_inventory",
                  get: true
                }
              }
            }
          ]
        },
        "Products::Photo": {
          name: "product_photos",
          description: "Returns all product_photos",
          create_options: [
            {
              optional_relationships: [
                "product"
              ]
            }
          ],
          create_params: {
            requires: {
              file: {
                type: "String",
                allow_blank: false,
                desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/jpeg;base64,iVBORw0KGgo...\""
              }
            },
            optional: {
              position: {
                type: "Integer",
                desc: "The sort order for photos of this product."
              },
              caption: {
                type: "String",
                desc: "Caption of this product_photo"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a product_photo",
              get: true
            },
            {
              name: "id",
              description: "Update a product_photo",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "product"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  position: {
                    type: "Integer",
                    desc: "The sort order for photos of this product."
                  },
                  caption: {
                    type: "String",
                    desc: "Caption of this product_photo"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a product_photo",
              delete: true
            },
            {
              name: "id",
              resources: {
                product: {
                  name: "product",
                  description: "Get a product for this product_photo",
                  get: true
                }
              }
            }
          ]
        },
        "Products::SkuTraitValue": {
          name: "product_sku_trait_values",
          description: "Returns all product_sku_trait_values",
          create_options: [
            {
              required_relationships: [
                "product_trait_value",
                "product_sku"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a product_sku_trait_value",
              get: true
            },
            {
              name: "id",
              description: "Delete a product_sku_trait_value",
              delete: true
            },
            {
              name: "id",
              resources: {
                product_sku: {
                  name: "product_sku",
                  description: "Get a sku for this product_sku_trait_value",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                product_trait_value: {
                  name: "product_trait_value",
                  description: "Get a trait_value for this product_sku_trait_value",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                product_inventories: {
                  name: "product_inventories",
                  description: "List of inventories for this product_sku_trait_value",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Products::Sku": {
          name: "product_skus",
          description: "Returns all product_skus",
          create_options: [
            {
              required_relationships: [
                "product"
              ]
            }
          ],
          create_params: {
            requires: {
              price: {
                type: "BigDecimal",
                coerce_with: "APICoercions::MoneyToBigDecimal",
                desc: "Price of this product_sku"
              },
              sku_code: {
                type: "String",
                allow_blank: false,
                desc: "Unique code for this product sku"
              }
            },
            optional: {
              image: {
                type: "String",
                desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a product_sku",
              get: true
            },
            {
              name: "id",
              description: "Update a product_sku",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  price: {
                    type: "BigDecimal",
                    coerce_with: "APICoercions::MoneyToBigDecimal",
                    desc: "Price of this product_sku"
                  },
                  sku_code: {
                    type: "String",
                    desc: "Unique code for this product sku"
                  },
                  image: {
                    type: "String",
                    desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a product_sku",
              delete: true
            },
            {
              name: "id",
              resources: {
                product: {
                  name: "product",
                  description: "Get a product for this product_sku",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                product_sku_trait_values: {
                  name: "product_sku_trait_values",
                  description: "List of sku_trait_values for this product_sku",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Products::Product": {
          name: "products",
          description: "Returns all products",
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                desc: "Name of this product"
              },
              description: {
                type: "String",
                allow_blank: false,
                desc: "Description of this product"
              }
            },
            optional: {
              tax_code: {
                type: "String",
                desc: "Tax Code of this product"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search the product name and description"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a product",
              get: true
            },
            {
              name: "id",
              description: "Update a product",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this product"
                  },
                  description: {
                    type: "String",
                    desc: "Description of this product"
                  },
                  tax_code: {
                    type: "String",
                    desc: "Tax Code of this product"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a product",
              delete: true
            },
            {
              name: "id",
              resources: {
                product_skus: {
                  name: "product_skus",
                  description: "List of skus for this product",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                product_photos: {
                  name: "product_photos",
                  description: "List of photos for this product",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Projects::Project": {
          name: "projects",
          description: "Get a list of projects",
          create_options: [
            {
              optional_relationships: [
                "user",
                "project_category"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "the name of this project"
              },
              description: {
                type: "String",
                desc: "the name of this project"
              },
              screenshot: {
                type: "String",
                desc: "A screenshot of this project which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              },
              initial_kidscript_version: {
                type: "String",
                desc: "the version of kidscript which this project was made with, such as 1.0.0",
                default: "2.0.0"
              }
            }
          },
          filter_options: [
            {
              deletable: true,
              archivable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              ids: {
                type: "Array"
              },
              q: {
                type: "String",
                desc: "search the projects"
              },
              include_courses: {
                type: "Virtus::Attribute::Boolean",
                default: false,
                desc: "include projects which are associated to courses"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a project",
              get: true
            },
            {
              name: "id",
              description: "Update a project",
              update_options: [
                {
                  deletable: true,
                  archivable: true,
                  optional_relationships: [
                    "version",
                    "project_category"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "the name of this project"
                  },
                  description: {
                    type: "String",
                    desc: "the name of this project"
                  },
                  screenshot: {
                    type: "String",
                    desc: "A screenshot of this project which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  },
                  visibility: {
                    type: "Symbol",
                    values: [
                      "private",
                      "friends",
                      "public"
                    ],
                    desc: "private, friends or public"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a project",
              delete: true
            },
            {
              name: "id",
              resources: {
                documents: {
                  name: "documents",
                  description: "Get a projects documents",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                statistics: {
                  name: "statistics",
                  description: "Get statistics summaries describing this project",
                  filter_params: {
                    requires: {},
                    optional: {
                      user_id: {
                        uuid: true,
                        desc: "The user the statistics summaries will be scoped to"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                versions: {
                  name: "versions",
                  description: "Get previous versions of this project",
                  filter_params: {
                    requires: {},
                    optional: {
                      step_id: {
                        uuid: true,
                        desc: "the versions of this project which relate to a specific step, only relevant when in the context of tutorials"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                leaderboard_scores: {
                  name: "leaderboard_scores",
                  description: "List of leaderboard_scores for this project",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                version_stars: {
                  name: "version_stars",
                  description: "List of version_stars for this project",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                version_flags: {
                  name: "version_flags",
                  description: "List of version_flags for this project",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                version_emojis: {
                  name: "version_emojis",
                  description: "List of version_emojis for this project",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                version_comments: {
                  name: "version_comments",
                  description: "List of version_comments for this project",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Auth::Session": {
          name: "sessions",
          description: "Returns all sessions",
          create_options: [
            {
              optional_relationships: [
                "organization"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              email: {
                type: "String",
                desc: "email of the user"
              },
              username: {
                type: "String",
                desc: "username of the user"
              },
              password: {
                type: "String",
                desc: "password of the user"
              },
              name: {
                type: "String",
                desc: "is creating a new user automatically, then the name to use (defaults to the badge)"
              },
              badge: {
                type: "String",
                desc: "badge for this user at this org"
              },
              pin: {
                type: "String",
                desc: "four digit pin for this user at this org"
              },
              slt: {
                type: "String",
                desc: "soft login token from an email"
              },
              expires_in: {
                type: "Integer",
                desc: "number of seconds that this access token should last for"
              },
              nrdy_params: {
                type: "Hash",
                description: "all nrdy_* parameters (we need all of them so that we can recreate the signature to validate the request)"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a session",
              get: true
            }
          ]
        },
        "Curriculum::Skill": {
          name: "skills",
          description: "Returns all skills",
          create_options: [
            {
              required_relationships: [
                "learning_path"
              ]
            }
          ],
          create_params: {
            requires: {
              name: {
                type: "String",
                desc: "Name of this skill"
              }
            },
            optional: {
              description: {
                type: "String",
                desc: "Description of this skill"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search the skills by name"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a skill",
              get: true
            },
            {
              name: "id",
              description: "Update a skill",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this skill"
                  },
                  description: {
                    type: "String",
                    desc: "Description of this skill"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a skill",
              delete: true
            },
            {
              name: "id",
              resources: {
                skill_levels: {
                  name: "skill_levels",
                  description: "List of skill_levels for this skill",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Studios::Slot": {
          name: "slots",
          description: "Returns all slots",
          create_options: [
            {
              optional_relationships: [
                "location"
              ],
              required_relationships: [
                "occasion"
              ]
            }
          ],
          create_params: {
            requires: {
              start_hour: {
                type: "Integer",
                desc: "the hour of the day that this slot starts"
              },
              start_minute: {
                type: "Integer",
                desc: "the minute of the day that this slot starts"
              },
              end_hour: {
                type: "Integer",
                desc: "the hour of the day that this slot ends"
              },
              end_minute: {
                type: "Integer",
                desc: "the minute of the day that this slot ends"
              },
              capacity: {
                type: "Integer",
                desc: "the number of spaces available in this slot for each day it is active"
              },
              first_available_at: {
                type: "Date",
                desc: "the date when this slot first becomes active"
              }
            },
            optional: {
              last_available_at: {
                type: "Date",
                desc: "the date when this slot will be deactivated, can be null for perpetually active"
              },
              excluded_dates: {
                type: "Array",
                desc: "An array of dates where this slot will not be available"
              },
              monday: {
                type: "Virtus::Attribute::Boolean",
                desc: "is this slot active on a Monday"
              },
              tuesday: {
                type: "Virtus::Attribute::Boolean",
                desc: "is this slot active on a Tuesday"
              },
              wednesday: {
                type: "Virtus::Attribute::Boolean",
                desc: "is this slot active on a Wednesday"
              },
              thursday: {
                type: "Virtus::Attribute::Boolean",
                desc: "is this slot active on a Thursday"
              },
              friday: {
                type: "Virtus::Attribute::Boolean",
                desc: "is this slot active on a Friday"
              },
              saturday: {
                type: "Virtus::Attribute::Boolean",
                desc: "is this slot active on a Saturday"
              },
              sunday: {
                type: "Virtus::Attribute::Boolean",
                desc: "is this slot active on a Sunday"
              },
              description: {
                type: "String",
                desc: "optional description"
              },
              notes: {
                type: "String",
                desc: "optional notes"
              },
              header: {
                type: "String",
                desc: "optional description"
              },
              image: {
                type: "String",
                desc: "A image of this project which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              },
              time_zone: {
                type: "String",
                desc: "This slots time zone, i.e. America/Chicago",
                default: "America/Chicago"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              location_id: {
                uuid: true
              },
              occasion_id: {
                uuid: true
              },
              date: {
                type: "Date",
                desc: "the date of a hypothetical booking"
              },
              start_hour: {
                type: "Integer",
                desc: "the hour of the day that the slot starts"
              },
              start_minute: {
                type: "Integer",
                desc: "the minute of the day that the slot starts"
              },
              end_hour: {
                type: "Integer",
                desc: "the hour of the day that the slot ends"
              },
              end_minute: {
                type: "Integer",
                desc: "the minute of the day that the slot ends"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "first_available_at",
            "last_available_at",
            "start_hour",
            "end_hour",
            "capacity"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a slot",
              get: true
            },
            {
              name: "id",
              description: "Update a slot",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  last_available_at: {
                    type: "Date",
                    desc: "the date when this slot will be deactivated, can be null for perpetually active"
                  },
                  excluded_dates: {
                    type: "Array",
                    desc: "An array of dates where this slot will not be available"
                  },
                  capacity: {
                    type: "Integer",
                    desc: "the number of spaces available in this slot for each day it is active"
                  },
                  description: {
                    type: "String",
                    desc: "optional description"
                  },
                  notes: {
                    type: "String",
                    desc: "optional notes"
                  },
                  header: {
                    type: "String",
                    desc: "optional description"
                  },
                  image: {
                    type: "String",
                    desc: "A image of this project which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a slot",
              delete: true
            },
            {
              name: "id",
              filter_options: [
                {
                  deletable: true
                }
              ],
              resources: {
                location: {
                  name: "location",
                  description: "Get a location for this slot",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                occasion: {
                  name: "occasion",
                  description: "Get a occasion for this slot",
                  get: true
                }
              }
            }
          ]
        },
        "Studios::SlotInstance": {
          name: "slot_instances",
          description: "Returns all slot_instances",
          filter_params: {
            requires: {},
            optional: {
              date: {
                type: "Date",
                desc: "filter by specific date"
              },
              after: {
                type: "Date",
                desc: "filter by date"
              },
              before: {
                type: "Date",
                desc: "filter by date"
              },
              location_id: {
                type: "UUID"
              },
              location_ids: {
                type: "Array"
              },
              occasion_id: {
                type: "UUID"
              },
              occasion_ids: {
                type: "Array"
              },
              guide_id: {
                type: "UUID"
              },
              guide_ids: {
                type: "Array"
              },
              include_my_guides: {
                type: "Virtus::Attribute::Boolean"
              }
            }
          },
          get: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a slot_instance",
              get: true
            }
          ]
        },
        "Projects::Share": {
          name: "shares",
          description: "Share a project.",
          create_options: [
            {
              optional_relationships: [
                "user",
                "version",
                "project"
              ]
            }
          ],
          create_params: {
            requires: {
              phone_number: {
                type: "String",
                allow_blank: false,
                desc: "phone number to send an SMS to"
              }
            },
            optional: {}
          },
          post: true
        },
        "Curriculum::Steps::Step": {
          name: "steps",
          description: "Create a step",
          create_options: [
            {
              required_relationships: [
                "tutorial"
              ]
            }
          ],
          create_params: {
            requires: {
              boilerplate: {
                type: "Symbol",
                values: [
                  "code",
                  "info",
                  "write",
                  "slide"
                ],
                desc: "code, info, write or slide"
              },
              position: {
                type: "Integer",
                desc: "The sort order for steps within each difficulty."
              }
            },
            optional: {
              header: {
                type: "String",
                desc: "A small header which is required for all step types except step."
              },
              content: {
                type: "String",
                desc: "The primary content for this step which is a block of markdown which can also contain symbols such as %RUN% for our run button or %HillFriend% for objects."
              },
              image: {
                type: "String",
                desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              },
              hint: {
                type: "String",
                desc: "An optional block of content, represented in markdown and available in all step types except step."
              },
              button_type: {
                type: "String",
                values: [
                  "next",
                  "run",
                  "both",
                  "none"
                ],
                desc: "If set to 'run' then the primary button for the step will run the current KidScript and moving to the next step will occur when an event matching the validation rules is detected. This is required for Info or Write steps."
              },
              success_header: {
                type: "String",
                desc: "An optional header which can be displayed after completing either a Code or Write step."
              },
              success_message: {
                type: "String",
                desc: "An optional block of content, represented in markdown which can be displayed after completing either a Code or Write step."
              },
              kidscript_head: {
                type: "String",
                desc: "KidScript which will be placed into the Stage.KS tab. If not provided, then the previous steps KidScript will be used. If the first Step does not declare KidScript then the value from the Difficulty will be used."
              },
              kidscript_head_strategy: {
                type: "String",
                values: [
                  "append",
                  "prepend",
                  "inherit",
                  "replace"
                ],
                desc: "How should the client treat the KidScript in this step with respect to the KidScript in the previous step. Either 'append' to add this KidScript to the end of the previous step, 'prepend' to add it before the previous steps KidScript, 'inherit' to ignore KidScript in this step and use the previous steps KidScript or 'replace' to replace the previous steps KidScript."
              },
              kidscript_body: {
                type: "String",
                desc: "KidScript which will be placed into the Main.KS tab. If not provided, then the previous steps KidScript will be used. If the first Step does not declare KidScript then the value from the Difficulty will be used."
              },
              kidscript_body_strategy: {
                type: "String",
                values: [
                  "append",
                  "prepend",
                  "inherit",
                  "replace"
                ],
                desc: "How should the client treat the KidScript in this step with respect to the KidScript in the previous step. Either 'append' to add this KidScript to the end of the previous step, 'prepend' to add it before the previous steps KidScript, 'inherit' to ignore KidScript in this step and use the previous steps KidScript or 'replace' to replace the previous steps KidScript."
              },
              editor_options: {
                type: "Hash",
                description: "An object representing other configuration options which can be passed to the editor"
              },
              cursor: {
                type: "Hash",
                description: ""
              },
              highlight: {
                type: "Hash",
                description: "Instructions to the Editor to highlight lines or symbols"
              },
              editable_symbols: {
                type: "Hash",
                description: "the Editable Symbols feature will lock the editor in a way which allows only specific symbols to be edited"
              },
              validation_rules: {
                type: "Hash",
                description: "validation rules, the JSON format is from the json-logic-js (http://jsonlogic.com/) library"
              },
              meta: {
                type: "Hash",
                description: "other presentation logic which the client would like to add, particularly useful for the slides type"
              },
              library: {
                type: "Hash",
                description: "the objects, colors and other library items which can be used within code editing on this step"
              },
              test_instructions: {
                type: "Hash",
                description: "instructions used for automated testing on this step"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a step",
              get: true
            },
            {
              name: "id",
              description: "Update a step",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  boilerplate: {
                    type: "Symbol",
                    values: [
                      "code",
                      "info",
                      "write",
                      "slide"
                    ],
                    desc: "code, info, write or slide"
                  },
                  position: {
                    type: "Integer",
                    desc: "The sort order for steps within each tutorial."
                  },
                  header: {
                    type: "String",
                    desc: "A small header which is required for all step types except step."
                  },
                  content: {
                    type: "String",
                    desc: "The primary content for this step which is a block of markdown which can also contain symbols such as %RUN% for our run button or %HillFriend% for objects."
                  },
                  image: {
                    type: "String",
                    desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  },
                  hint: {
                    type: "String",
                    desc: "An optional block of content, represented in markdown and available in all step types except step."
                  },
                  button_type: {
                    type: "String",
                    values: [
                      "next",
                      "run",
                      "both",
                      "none"
                    ],
                    desc: "If set to 'run' then the primary button for the step will run the current KidScript and moving to the next step will occur when an event matching the validation rules is detected. This is required for Info or Write steps."
                  },
                  success_header: {
                    type: "String",
                    desc: "An optional header which can be displayed after completing either a Code or Write step."
                  },
                  success_message: {
                    type: "String",
                    desc: "An optional block of content, represented in markdown which can be displayed after completing either a Code or Write step."
                  },
                  kidscript_head: {
                    type: "String",
                    desc: "KidScript which will be placed into the Stage.KS tab. If not provided, then the previous steps KidScript will be used. If the first Step does not declare KidScript then the value from the Difficulty will be used."
                  },
                  kidscript_head_strategy: {
                    type: "String",
                    values: [
                      "append",
                      "prepend",
                      "inherit",
                      "replace"
                    ],
                    desc: "How should the client treat the KidScript in this step with respect to the KidScript in the previous step. Either 'append' to add this KidScript to the end of the previous step, 'prepend' to add it before the previous steps KidScript, 'inherit' to ignore KidScript in this step and use the previous steps KidScript or 'replace' to replace the previous steps KidScript."
                  },
                  kidscript_body: {
                    type: "String",
                    desc: "KidScript which will be placed into the Main.KS tab. If not provided, then the previous steps KidScript will be used. If the first Step does not declare KidScript then the value from the Difficulty will be used."
                  },
                  kidscript_body_strategy: {
                    type: "String",
                    values: [
                      "append",
                      "prepend",
                      "inherit",
                      "replace"
                    ],
                    desc: "How should the client treat the KidScript in this step with respect to the KidScript in the previous step. Either 'append' to add this KidScript to the end of the previous step, 'prepend' to add it before the previous steps KidScript, 'inherit' to ignore KidScript in this step and use the previous steps KidScript or 'replace' to replace the previous steps KidScript."
                  },
                  editor_options: {
                    type: "Hash",
                    description: "An object representing other configuration options which can be passed to the editor"
                  },
                  cursor: {
                    type: "Hash",
                    description: ""
                  },
                  highlight: {
                    type: "Hash",
                    description: "Instructions to the Editor to highlight lines or symbols"
                  },
                  editable_symbols: {
                    type: "Hash",
                    description: "the Editable Symbols feature will lock the editor in a way which allows only specific symbols to be edited"
                  },
                  validation_rules: {
                    type: "Hash",
                    description: "validation rules, the JSON format is from the json-logic-js (http://jsonlogic.com/) library"
                  },
                  meta: {
                    type: "Hash",
                    description: "other presentation logic which the client would like to add, particularly useful for the slides type"
                  },
                  library: {
                    type: "Hash",
                    description: "the objects, colors and other library items which can be used within code editing on this step"
                  },
                  test_instructions: {
                    type: "Hash",
                    description: "instructions used for automated testing on this step"
                  }
                }
              },
              put: true,
              id_param: true
            },
            {
              name: "id",
              description: "Delete a step",
              delete: true
            },
            {
              name: "id",
              resources: {
                statistics: {
                  name: "statistics",
                  description: "Get the statistics for this step",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                tutorial: {
                  name: "tutorial",
                  description: "Get the tutorial for this step",
                  get: true
                }
              }
            }
          ]
        },
        "Billing::Subscription": {
          name: "subscriptions",
          description: "Returns all subscriptions",
          create_options: [
            {
              required_relationships: [
                "organization",
                "merchant_account"
              ],
              optional_relationships: [
                "payment_method",
                "location"
              ]
            }
          ],
          create_params: {
            requires: {
              cadence: {
                type: "Symbol",
                values: [
                  "monthly",
                  "quarterly",
                  "annually"
                ],
                desc: "can be monthly, quarterly or annually, how frequently this subscription will be billed.",
                default: "monthly"
              }
            },
            optional: {
              start_at: {
                type: "Date",
                desc: "date that this subscription should start (in the organizations time zone)"
              },
              trial_period: {
                type: "Virtus::Attribute::Boolean",
                desc: "If set, then subscription will begin with a trial period."
              },
              first_add_on: {
                type: "Symbol",
                values: [
                  "nova",
                  "supernova_starter",
                  "supernova_lite",
                  "supernova",
                  "supernova_pro"
                ]
              },
              initial_member_count: {
                type: "Integer",
                desc: "The number of members to add to the first addon"
              },
              coupon_code: {
                type: "String",
                coerce_with: "APICoercions::Uppercase",
                desc: "Any coupons to apply to this order"
              },
              enable: {
                type: "Virtus::Attribute::Boolean",
                desc: "Enable the subscription right away (requires payment method, first_add_on and initial_member_count)",
                default: false
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Return a subscription",
              get: true
            },
            {
              name: "id",
              description: "Update a subscription",
              update_options: [
                {
                  optional_relationships: [
                    "payment_method"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  start_at: {
                    type: "Date",
                    desc: "date that this subscription should start, once set can not be changed"
                  },
                  cancel_at: {
                    type: "Date",
                    desc: "Must be today or in the future. If blank and a cancellation code is provided then the subscription will cancel at the end of the current billing period."
                  },
                  cancellation_code: {
                    type: "Symbol",
                    values: [
                      "human_error",
                      "requested_change",
                      "delinquent",
                      "price",
                      "schedule",
                      "finished",
                      "child_unhappy",
                      "product_experience",
                      "technical_issues",
                      "learning_growth",
                      "business_operations",
                      "guide",
                      "test_data"
                    ],
                    desc: "can be null, human_error, requested_change, delinquent, price, schedule, finished, child_unhappy, product_experience, technical_issues, learning_growth, business_operations, guide or test_data, setting this will permanently cancel the subscription."
                  },
                  cadence: {
                    type: "Symbol",
                    values: [
                      "monthly",
                      "quarterly",
                      "annually"
                    ],
                    desc: "can be monthly, quarterly or annually, how frequently this subscription will be billed."
                  },
                  trial_period: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "If set, then subscription will begin with a trial period."
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a subscription",
              delete: true
            },
            {
              name: "id",
              resources: {
                organization: {
                  name: "organization",
                  description: "Return an organization from a subscription",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                invoice_subscription_prepayments: {
                  name: "invoice_subscription_prepayments",
                  description: "Return invoice_subscription_prepayments from a subscription",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                subscription_discounts: {
                  name: "subscription_discounts",
                  description: "List of subscription_discounts for this subscription",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                subscription_add_ons: {
                  name: "subscription_add_ons",
                  description: "List of subscription_add_ons for this subscription",
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Billing::SubscriptionDiscounts::SubscriptionDiscount": {
          name: "subscription_discounts",
          description: "Returns all subscription_discounts",
          create_options: [
            {
              optional_relationships: [
                "subscription"
              ]
            }
          ],
          create_params: {
            requires: {
              description: {
                type: "String",
                allow_blank: false,
                desc: "Description of this subscription_discount"
              },
              reason: {
                type: "Symbol",
                values: [
                  "saas_sign_up_incentive",
                  "saas_retention_incentive",
                  "saas_referral_credit",
                  "saas_commitment_incentive",
                  "explorer_sign_up_incentive",
                  "explorer_retention_incentive",
                  "explorer_referral_credit",
                  "explorer_commitment_incentive",
                  "studio_sign_up_incentive",
                  "studio_retention_incentive",
                  "studio_referral_credit",
                  "studio_commitment_incentive",
                  "studio_manager_credit",
                  "studio_manager_incentive",
                  "studio_paused_incentive",
                  "nova_sign_up_incentive",
                  "nova_retention_incentive",
                  "nova_referral_credit",
                  "nova_loyalty_incentive",
                  "supernova_starter_sign_up_incentive",
                  "supernova_starter_retention_incentive",
                  "supernova_starter_referral_credit",
                  "supernova_starter_loyalty_incentive",
                  "supernova_lite_sign_up_incentive",
                  "supernova_lite_retention_incentive",
                  "supernova_lite_referral_credit",
                  "supernova_lite_loyalty_incentive",
                  "supernova_sign_up_incentive",
                  "supernova_retention_incentive",
                  "supernova_referral_credit",
                  "supernova_loyalty_incentive",
                  "supernova_pro_sign_up_incentive",
                  "supernova_pro_retention_incentive",
                  "supernova_pro_referral_credit",
                  "supernova_pro_loyalty_incentive"
                ],
                desc: "saas_sign_up_incentive, saas_retention_incentive, saas_referral_credit, saas_commitment_incentive, explorer_sign_up_incentive, explorer_retention_incentive, explorer_referral_credit, explorer_commitment_incentive, studio_sign_up_incentive, studio_retention_incentive, studio_referral_credit, studio_commitment_incentive, studio_manager_credit, studio_manager_incentive, studio_paused_incentive, nova_sign_up_incentive, nova_retention_incentive, nova_referral_credit, nova_loyalty_incentive, supernova_starter_sign_up_incentive, supernova_starter_retention_incentive, supernova_starter_referral_credit, supernova_starter_loyalty_incentive, supernova_lite_sign_up_incentive, supernova_lite_retention_incentive, supernova_lite_referral_credit, supernova_lite_loyalty_incentive, supernova_sign_up_incentive, supernova_retention_incentive, supernova_referral_credit, supernova_loyalty_incentive, supernova_pro_sign_up_incentive, supernova_pro_retention_incentive, supernova_pro_referral_credit or supernova_pro_loyalty_incentive"
              },
              amount: {
                type: "BigDecimal",
                coerce_with: "APICoercions::MoneyToBigDecimal",
                desc: "The discount which will be applied to the first member"
              },
              activate_at: {
                type: "Date",
                desc: "the date when this discount should be applied"
              }
            },
            optional: {
              additional_member_amount: {
                type: "BigDecimal",
                coerce_with: "APICoercions::MoneyToBigDecimal",
                desc: "The discount which will be applied to each additional member"
              },
              quantity: {
                type: "Integer",
                desc: "for discounts which are not applied proportionally to the member count"
              },
              number_of_billing_cycles: {
                type: "Integer",
                desc: "how many months this discount will go into effect for"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a subscription_discount",
              get: true
            },
            {
              name: "id",
              description: "Update a subscription_discount",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "subscription"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  description: {
                    type: "String",
                    desc: "Description of this subscription_discount"
                  },
                  amount: {
                    type: "BigDecimal",
                    coerce_with: "APICoercions::MoneyToBigDecimal",
                    desc: "The discount which will be applied to the first member"
                  },
                  activate_at: {
                    type: "Date",
                    desc: "the date when this discount should be applied"
                  },
                  additional_member_amount: {
                    type: "BigDecimal",
                    coerce_with: "APICoercions::MoneyToBigDecimal",
                    desc: "The discount which will be applied to each additional member"
                  },
                  quantity: {
                    type: "Integer",
                    desc: "for discounts which are not applied proportionally to the member count"
                  },
                  number_of_billing_cycles: {
                    type: "Integer",
                    default: 0,
                    desc: "how many months this discount will go into effect for"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a subscription_discount",
              delete: true
            },
            {
              name: "id",
              resources: {
                subscription: {
                  name: "subscription",
                  description: "Get a subscription for this subscription_discount",
                  get: true
                }
              }
            }
          ]
        },
        "Communication::TextMessages::TextMessage": {
          name: "text_messages",
          description: "Returns all text_messages",
          create_options: [
            {
              optional_relationships: [
                "booking"
              ]
            }
          ],
          create_params: {
            requires: {
              to_dialing_code: {
                type: "String",
                allow_blank: false,
                values: [
                  "1",
                  "20",
                  "211",
                  "212",
                  "213",
                  "216",
                  "218",
                  "220",
                  "221",
                  "222",
                  "223",
                  "224",
                  "225",
                  "226",
                  "227",
                  "228",
                  "229",
                  "230",
                  "231",
                  "232",
                  "233",
                  "234",
                  "235",
                  "236",
                  "237",
                  "238",
                  "239",
                  "240",
                  "241",
                  "242",
                  "243",
                  "244",
                  "245",
                  "246",
                  "248",
                  "249",
                  "250",
                  "251",
                  "252",
                  "253",
                  "254",
                  "255",
                  "256",
                  "257",
                  "258",
                  "260",
                  "261",
                  "262",
                  "263",
                  "264",
                  "265",
                  "266",
                  "267",
                  "268",
                  "269",
                  "27",
                  "290",
                  "291",
                  "297",
                  "298",
                  "299",
                  "30",
                  "31",
                  "32",
                  "33",
                  "34",
                  "350",
                  "351",
                  "352",
                  "353",
                  "354",
                  "355",
                  "356",
                  "357",
                  "358",
                  "359",
                  "36",
                  "370",
                  "371",
                  "372",
                  "373",
                  "374",
                  "375",
                  "376",
                  "377",
                  "378",
                  "380",
                  "381",
                  "382",
                  "385",
                  "386",
                  "387",
                  "389",
                  "39",
                  "40",
                  "41",
                  "420",
                  "421",
                  "423",
                  "43",
                  "44",
                  "45",
                  "46",
                  "47",
                  "48",
                  "49",
                  "500",
                  "501",
                  "502",
                  "503",
                  "504",
                  "505",
                  "506",
                  "507",
                  "508",
                  "509",
                  "51",
                  "52",
                  "53",
                  "54",
                  "55",
                  "56",
                  "57",
                  "58",
                  "590",
                  "591",
                  "592",
                  "593",
                  "594",
                  "595",
                  "596",
                  "597",
                  "598",
                  "599",
                  "60",
                  "61",
                  "62",
                  "63",
                  "64",
                  "65",
                  "66",
                  "670",
                  "672",
                  "673",
                  "674",
                  "675",
                  "676",
                  "677",
                  "678",
                  "679",
                  "680",
                  "681",
                  "682",
                  "683",
                  "685",
                  "686",
                  "687",
                  "688",
                  "689",
                  "690",
                  "691",
                  "692",
                  "7",
                  "81",
                  "82",
                  "84",
                  "850",
                  "852",
                  "853",
                  "855",
                  "856",
                  "86",
                  "880",
                  "886",
                  "90",
                  "91",
                  "92",
                  "93",
                  "94",
                  "95",
                  "960",
                  "961",
                  "962",
                  "963",
                  "964",
                  "965",
                  "966",
                  "967",
                  "968",
                  "970",
                  "971",
                  "972",
                  "973",
                  "974",
                  "975",
                  "976",
                  "977",
                  "98",
                  "992",
                  "993",
                  "994",
                  "995",
                  "996",
                  "998"
                ],
                desc: "a valid country dialing code, i.e. 1 for the US and 44 for the UK"
              },
              to_phone_number: {
                type: "String",
                allow_blank: false,
                desc: "To Phone Number of this text_message"
              },
              template: {
                type: "Symbol",
                values: [
                  "outbound"
                ],
                desc: "must be set outbound"
              }
            },
            optional: {
              body: {
                type: "String",
                desc: "Body of this text_message"
              }
            }
          },
          filter_options: [
            {
              handleable: true,
              claimable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search the text messages"
              },
              template: {
                type: "Symbol",
                values: [
                  "abandoned_guide",
                  "attached_guide",
                  "guide_schedule_summary",
                  "inbound",
                  "outbound",
                  "parent_survey",
                  "parent_update",
                  "share",
                  "virtual_expedition_reminder1",
                  "virtual_expedition_reminder2",
                  "influencer_class_one_hour_reminder",
                  "influencer_class_twenty_four_hour_reminder",
                  "partner_group_class_one_hour_reminder",
                  "partner_group_class_twenty_four_hour_reminder",
                  "acquisition_stream_follow_up/attended",
                  "acquisition_stream_follow_up/expressed_interest",
                  "acquisition_stream_follow_up/follow_up1",
                  "acquisition_stream_follow_up/follow_up2",
                  "acquisition_stream_follow_up/left_voicemail",
                  "acquisition_stream_follow_up/phone_call_no_answer",
                  "acquisition_stream_follow_up/trial_information",
                  "acquisition_stream_registered/one_hour_reminder",
                  "acquisition_stream_registered/registration_created",
                  "acquisition_stream_registered/twenty_four_hour_reminder",
                  "acquisition_stream_registered/ten_minute_reminder",
                  "canceled_member/check_in",
                  "canceled_member/left_voicemail",
                  "canceled_member/phone_call_no_answer",
                  "collect_learning_styles/fallback",
                  "collect_learning_styles/fallback_reminder",
                  "collect_learning_styles/left_voicemail",
                  "collect_learning_styles/phone_call_no_answer",
                  "conversion_stream_follow_up/attended",
                  "conversion_stream_follow_up/expressed_interest",
                  "conversion_stream_follow_up/follow_up1",
                  "conversion_stream_follow_up/follow_up2",
                  "conversion_stream_follow_up/left_voicemail",
                  "conversion_stream_follow_up/phone_call_no_answer",
                  "conversion_stream_follow_up/trial_information",
                  "conversion_stream_registered/one_hour_reminder",
                  "conversion_stream_registered/registration_created",
                  "conversion_stream_registered/twenty_four_hour_reminder",
                  "conversion_stream_registered/ten_minute_reminder",
                  "gift_of_code/welcome",
                  "influencer_program_lead/account_setup",
                  "influencer_program_lead/follow_up1",
                  "influencer_program_lead/follow_up2",
                  "influencer_program_lead/follow_up3",
                  "influencer_program_lead/follow_up4",
                  "missed_member_session/left_voicemail",
                  "missed_member_session/phone_call_no_answer",
                  "missed_member_session/we_missed_you",
                  "missed_trial_session/expressed_interest",
                  "missed_trial_session/left_voicemail",
                  "missed_trial_session/phone_call_no_answer",
                  "missed_trial_session/we_missed_you",
                  "on_demand_stream_follow_up/attended",
                  "on_demand_stream_follow_up/expressed_interest",
                  "on_demand_stream_follow_up/follow_up1",
                  "on_demand_stream_follow_up/follow_up2",
                  "on_demand_stream_follow_up/left_voicemail",
                  "on_demand_stream_follow_up/phone_call_no_answer",
                  "on_demand_stream_registered/registration_created",
                  "past_due_subscription/bookings_canceled",
                  "past_due_subscription/left_voicemail",
                  "past_due_subscription/phone_call_no_answer",
                  "past_due_subscription/update_payment_info",
                  "partner_group_class_follow_up/expressed_interest",
                  "partner_group_class_follow_up/left_voicemail",
                  "partner_group_class_follow_up/membership_information",
                  "partner_group_class_follow_up/phone_call_no_answer",
                  "unhappy_survey/left_voicemail",
                  "unhappy_survey/phone_call_no_answer",
                  "unused_credits/end_of_cycle_reminder",
                  "unused_credits/new_credits",
                  "unused_credits/one_week_reminder",
                  "ussc_virtual_camp_booked/two_day_reminder",
                  "ussc_virtual_camp_follow_up/expressed_interest",
                  "ussc_virtual_camp_follow_up/left_voicemail",
                  "ussc_virtual_camp_follow_up/phone_call_no_answer",
                  "virtual_classes_lead/expressed_interest",
                  "virtual_classes_lead/left_voicemail1",
                  "virtual_classes_lead/left_voicemail2",
                  "virtual_classes_lead/phone_call_no_answer1",
                  "virtual_classes_lead/phone_call_no_answer2",
                  "virtual_classes_lead/suggest_times",
                  "virtual_classes_lead/share_games",
                  "virtual_classes_lead/share_videos",
                  "virtual_classes_lead/share_events",
                  "virtual_classes_lead/checking_in1",
                  "virtual_classes_lead/checking_in2",
                  "virtual_classes_prospect/expressed_interest",
                  "virtual_classes_prospect/left_voicemail1",
                  "virtual_classes_prospect/left_voicemail2",
                  "virtual_classes_prospect/phone_call_no_answer1",
                  "virtual_classes_prospect/phone_call_no_answer2",
                  "virtual_classes_prospect/suggest_times",
                  "virtual_classes_prospect/share_games",
                  "virtual_classes_prospect/share_videos",
                  "virtual_classes_prospect/share_events",
                  "virtual_classes_prospect/checking_in1",
                  "virtual_classes_prospect/checking_in2",
                  "virtual_trial_booked/evening_before_reminder",
                  "virtual_trial_booked/one_hour_reminder",
                  "virtual_trial_follow_up/attended",
                  "virtual_trial_follow_up/expressed_interest1",
                  "virtual_trial_follow_up/expressed_interest2",
                  "virtual_trial_follow_up/left_voicemail1",
                  "virtual_trial_follow_up/left_voicemail2",
                  "virtual_trial_follow_up/phone_call_no_answer1",
                  "virtual_trial_follow_up/phone_call_no_answer2",
                  "virtual_trial_period/day5",
                  "virtual_trial_period/day7",
                  "virtual_trial_period/trial_created"
                ],
                desc: "a text message template"
              },
              templates: {
                type: "Array",
                desc: "array of templates"
              },
              status: {
                type: "Symbol",
                values: [
                  "new",
                  "received",
                  "queued",
                  "delivered",
                  "undelivered",
                  "failed"
                ],
                desc: "a text message status"
              },
              statuses: {
                type: "Array",
                desc: "array of statuses"
              },
              staff_team_id: {
                type: "UUID"
              },
              claimed_by_id: {
                type: "UUID"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "handled_at"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a text_message",
              get: true
            },
            {
              name: "id",
              description: "Update a text_message",
              update_options: [
                {
                  handleable: true,
                  claimable: true,
                  optional_relationships: [
                    "staff_team"
                  ]
                }
              ],
              put: true
            },
            {
              name: "id",
              resources: {
                organizations: {
                  name: "organizations",
                  description: "List of organizations for this text_message",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                notes: {
                  name: "notes",
                  description: "List of notes for this text_message",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Curriculum::Tutorial": {
          name: "tutorials",
          description: "Create a tutorial",
          create_options: [
            {
              required_relationships: [
                "difficulty"
              ]
            }
          ],
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                desc: "Name of this tutorial"
              },
              description: {
                type: "String",
                allow_blank: false,
                desc: "Description of this tutorial"
              }
            },
            optional: {
              position: {
                type: "Integer",
                desc: "The sort order for steps within each difficulty."
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a tutorial",
              get: true
            },
            {
              name: "id",
              description: "Update a tutorial",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this tutorial"
                  },
                  description: {
                    type: "String",
                    desc: "Description of this tutorial"
                  },
                  position: {
                    type: "Integer",
                    desc: "The sort order for steps within each difficulty."
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a tutorial",
              delete: true
            },
            {
              name: "id",
              resources: {
                difficulty: {
                  name: "difficulty",
                  description: "Get the difficulty for this tutorial",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                steps: {
                  name: "steps",
                  description: "Get the steps for this tutorial",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Users::User": {
          name: "users",
          description: "Returns all users",
          create_options: [
            {
              optional_relationships: [
                "avatar"
              ]
            }
          ],
          create_params: {
            requires: {
              name: {
                type: "String",
                desc: "name of the user"
              }
            },
            optional: {
              scope: {
                type: "Symbol",
                values: [
                  "account",
                  "administrator",
                  "child",
                  "guide"
                ],
                desc: "can be either account, administrator or child",
                default: "account"
              },
              email: {
                type: "String",
                desc: "email of the user"
              },
              gender: {
                type: "Symbol",
                values: [
                  "male",
                  "female",
                  "prefer_not_to_say",
                  "non_binary_or_third_gender",
                  "other"
                ],
                desc: "null, male, female, prefer_not_to_say, non_binary_or_third_gender or other"
              },
              gender_other: {
                type: "String",
                desc: "user entered value for gender, if they selected other"
              },
              prefered_pronoun: {
                type: "Symbol",
                values: [
                  "she/her/hers",
                  "he/him/his",
                  "they/them/their",
                  "e/em/eir",
                  "ey/em/eir",
                  "fae/faer/faers",
                  "hu/hu/humes",
                  "sie/hir/hirs",
                  "tey/ter/ters",
                  "tey/tem/ters",
                  "ve/ver/vers",
                  "xe/xem/xyrs",
                  "ze/hir/hirs",
                  "ze/zir/zirs",
                  "zie/zim/zis"
                ],
                desc: "null, she/her/hers, he/him/his, they/them/their, e/em/eir, ey/em/eir, fae/faer/faers, hu/hu/humes, sie/hir/hirs, tey/ter/ters, tey/tem/ters, ve/ver/vers, xe/xem/xyrs, ze/hir/hirs, ze/zir/zirs or zie/zim/zis"
              },
              difficulty_level: {
                type: "Symbol",
                values: [
                  "beginner",
                  "intermediate",
                  "advanced",
                  "expert",
                  "pro"
                ],
                desc: "beginner, intermediate, advanced, expert or pro"
              },
              grade: {
                type: "Integer",
                desc: "the grade of the user, for Kindergarten provide a grade of 0"
              },
              date_of_birth: {
                type: "Date",
                desc: "date of birth of the user"
              },
              photo: {
                type: "String",
                desc: "This users photo which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              },
              password: {
                type: "String",
                desc: "password for the user"
              },
              time_zone: {
                type: "String",
                values: [
                  "Africa/Algiers",
                  "Africa/Cairo",
                  "Africa/Casablanca",
                  "Africa/Harare",
                  "Africa/Johannesburg",
                  "Africa/Monrovia",
                  "Africa/Nairobi",
                  "America/Argentina/Buenos_Aires",
                  "America/Bogota",
                  "America/Caracas",
                  "America/Chicago",
                  "America/Chihuahua",
                  "America/Denver",
                  "America/Godthab",
                  "America/Guatemala",
                  "America/Guyana",
                  "America/Halifax",
                  "America/Indiana/Indianapolis",
                  "America/Juneau",
                  "America/La_Paz",
                  "America/Lima",
                  "America/Los_Angeles",
                  "America/Mazatlan",
                  "America/Mexico_City",
                  "America/Monterrey",
                  "America/Montevideo",
                  "America/New_York",
                  "America/Phoenix",
                  "America/Regina",
                  "America/Santiago",
                  "America/Sao_Paulo",
                  "America/St_Johns",
                  "America/Tijuana",
                  "Asia/Almaty",
                  "Asia/Baghdad",
                  "Asia/Baku",
                  "Asia/Bangkok",
                  "Asia/Chongqing",
                  "Asia/Colombo",
                  "Asia/Dhaka",
                  "Asia/Hong_Kong",
                  "Asia/Irkutsk",
                  "Asia/Jakarta",
                  "Asia/Jerusalem",
                  "Asia/Kabul",
                  "Asia/Kamchatka",
                  "Asia/Karachi",
                  "Asia/Kathmandu",
                  "Asia/Kolkata",
                  "Asia/Krasnoyarsk",
                  "Asia/Kuala_Lumpur",
                  "Asia/Kuwait",
                  "Asia/Magadan",
                  "Asia/Muscat",
                  "Asia/Novosibirsk",
                  "Asia/Rangoon",
                  "Asia/Riyadh",
                  "Asia/Seoul",
                  "Asia/Shanghai",
                  "Asia/Singapore",
                  "Asia/Srednekolymsk",
                  "Asia/Taipei",
                  "Asia/Tashkent",
                  "Asia/Tbilisi",
                  "Asia/Tehran",
                  "Asia/Tokyo",
                  "Asia/Ulaanbaatar",
                  "Asia/Urumqi",
                  "Asia/Vladivostok",
                  "Asia/Yakutsk",
                  "Asia/Yekaterinburg",
                  "Asia/Yerevan",
                  "Atlantic/Azores",
                  "Atlantic/Cape_Verde",
                  "Atlantic/South_Georgia",
                  "Australia/Adelaide",
                  "Australia/Brisbane",
                  "Australia/Darwin",
                  "Australia/Hobart",
                  "Australia/Melbourne",
                  "Australia/Perth",
                  "Australia/Sydney",
                  "Europe/Amsterdam",
                  "Europe/Athens",
                  "Europe/Belgrade",
                  "Europe/Berlin",
                  "Europe/Bratislava",
                  "Europe/Brussels",
                  "Europe/Bucharest",
                  "Europe/Budapest",
                  "Europe/Copenhagen",
                  "Europe/Dublin",
                  "Europe/Helsinki",
                  "Europe/Istanbul",
                  "Europe/Kaliningrad",
                  "Europe/Kiev",
                  "Europe/Lisbon",
                  "Europe/Ljubljana",
                  "Europe/London",
                  "Europe/Madrid",
                  "Europe/Minsk",
                  "Europe/Moscow",
                  "Europe/Paris",
                  "Europe/Prague",
                  "Europe/Riga",
                  "Europe/Rome",
                  "Europe/Samara",
                  "Europe/Sarajevo",
                  "Europe/Skopje",
                  "Europe/Sofia",
                  "Europe/Stockholm",
                  "Europe/Tallinn",
                  "Europe/Vienna",
                  "Europe/Vilnius",
                  "Europe/Volgograd",
                  "Europe/Warsaw",
                  "Europe/Zagreb",
                  "Europe/Zurich",
                  "Pacific/Apia",
                  "Pacific/Auckland",
                  "Pacific/Chatham",
                  "Pacific/Fakaofo",
                  "Pacific/Fiji",
                  "Pacific/Guadalcanal",
                  "Pacific/Guam",
                  "Pacific/Honolulu",
                  "Pacific/Majuro",
                  "Pacific/Midway",
                  "Pacific/Noumea",
                  "Pacific/Pago_Pago",
                  "Pacific/Port_Moresby",
                  "Pacific/Tongatapu"
                ],
                desc: "name of the users current time zone, defaults to \"America/Chicago\""
              },
              ambassador: {
                type: "Virtus::Attribute::Boolean",
                desc: "Is this user part of the ambassador program"
              },
              t_shirt_size: {
                type: "Symbol",
                values: [
                  "xs",
                  "s",
                  "m",
                  "l",
                  "xl",
                  "xxl"
                ],
                desc: "null, xs, s, m, l, xl or xxl"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              ids: {
                type: "Array"
              },
              q: {
                type: "String",
                desc: "search the users by name or email"
              },
              name: {
                type: "String",
                desc: "search the users by name"
              },
              email: {
                type: "String",
                desc: "search the users by email"
              },
              has_email: {
                type: "Virtus::Attribute::Boolean"
              },
              scope: {
                type: "Symbol",
                values: [
                  "account",
                  "administrator",
                  "child",
                  "guide"
                ],
                desc: "can be either account, administrator or child"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "email"
          ],
          id_param: true,
          id_or_username_param: true,
          resources: {
            exists: {
              name: "exists",
              params: {
                requires: {},
                optional: {
                  email: {
                    type: "String",
                    desc: "The users email address"
                  },
                  username: {
                    type: "String",
                    desc: "The username of the user"
                  }
                }
              },
              get: true
            }
          },
          route_params: [
            {
              name: "id",
              description: "Get a user",
              get: true,
              resources: {
                levels: {
                  name: "levels",
                  get: true
                },
                public: {
                  name: "public",
                  get: true
                }
              }
            },
            {
              name: "id",
              description: "Update a user",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "how_heard_about",
                    "avatar",
                    {
                      name: "duplicate_of",
                      as: "user"
                    }
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  email: {
                    type: "String",
                    desc: "email of the user"
                  },
                  name: {
                    type: "String",
                    desc: "name of the user"
                  },
                  homeschool: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "set to true if this user is homeschooled (will clear out this users school_id if present)"
                  },
                  scope: {
                    type: "Symbol",
                    values: [
                      "account",
                      "administrator",
                      "child",
                      "guide"
                    ],
                    desc: "can be either account, administrator, child or lead"
                  },
                  gender: {
                    type: "Symbol",
                    values: [
                      "male",
                      "female",
                      "prefer_not_to_say",
                      "non_binary_or_third_gender",
                      "other"
                    ],
                    desc: "null, male, female, prefer_not_to_say, non_binary_or_third_gender or other"
                  },
                  gender_other: {
                    type: "String",
                    desc: "user entered value for gender, if they selected other"
                  },
                  prefered_pronoun: {
                    type: "Symbol",
                    values: [
                      "she/her/hers",
                      "he/him/his",
                      "they/them/their",
                      "e/em/eir",
                      "ey/em/eir",
                      "fae/faer/faers",
                      "hu/hu/humes",
                      "sie/hir/hirs",
                      "tey/ter/ters",
                      "tey/tem/ters",
                      "ve/ver/vers",
                      "xe/xem/xyrs",
                      "ze/hir/hirs",
                      "ze/zir/zirs",
                      "zie/zim/zis"
                    ],
                    desc: "null, she/her/hers, he/him/his, they/them/their, e/em/eir, ey/em/eir, fae/faer/faers, hu/hu/humes, sie/hir/hirs, tey/ter/ters, tey/tem/ters, ve/ver/vers, xe/xem/xyrs, ze/hir/hirs, ze/zir/zirs or zie/zim/zis"
                  },
                  difficulty_level: {
                    type: "Symbol",
                    values: [
                      "beginner",
                      "intermediate",
                      "advanced",
                      "expert",
                      "pro"
                    ],
                    desc: "beginner, intermediate, advanced, expert or pro"
                  },
                  grade: {
                    type: "Integer",
                    desc: "the grade of the user, for Kindergarten provide a grade of 0"
                  },
                  date_of_birth: {
                    type: "Date",
                    desc: "date of birth of the user"
                  },
                  photo: {
                    type: "String",
                    desc: "This users photo which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  },
                  password: {
                    type: "String",
                    desc: "password for the user"
                  },
                  time_zone: {
                    type: "String",
                    values: [
                      "Africa/Algiers",
                      "Africa/Cairo",
                      "Africa/Casablanca",
                      "Africa/Harare",
                      "Africa/Johannesburg",
                      "Africa/Monrovia",
                      "Africa/Nairobi",
                      "America/Argentina/Buenos_Aires",
                      "America/Bogota",
                      "America/Caracas",
                      "America/Chicago",
                      "America/Chihuahua",
                      "America/Denver",
                      "America/Godthab",
                      "America/Guatemala",
                      "America/Guyana",
                      "America/Halifax",
                      "America/Indiana/Indianapolis",
                      "America/Juneau",
                      "America/La_Paz",
                      "America/Lima",
                      "America/Los_Angeles",
                      "America/Mazatlan",
                      "America/Mexico_City",
                      "America/Monterrey",
                      "America/Montevideo",
                      "America/New_York",
                      "America/Phoenix",
                      "America/Regina",
                      "America/Santiago",
                      "America/Sao_Paulo",
                      "America/St_Johns",
                      "America/Tijuana",
                      "Asia/Almaty",
                      "Asia/Baghdad",
                      "Asia/Baku",
                      "Asia/Bangkok",
                      "Asia/Chongqing",
                      "Asia/Colombo",
                      "Asia/Dhaka",
                      "Asia/Hong_Kong",
                      "Asia/Irkutsk",
                      "Asia/Jakarta",
                      "Asia/Jerusalem",
                      "Asia/Kabul",
                      "Asia/Kamchatka",
                      "Asia/Karachi",
                      "Asia/Kathmandu",
                      "Asia/Kolkata",
                      "Asia/Krasnoyarsk",
                      "Asia/Kuala_Lumpur",
                      "Asia/Kuwait",
                      "Asia/Magadan",
                      "Asia/Muscat",
                      "Asia/Novosibirsk",
                      "Asia/Rangoon",
                      "Asia/Riyadh",
                      "Asia/Seoul",
                      "Asia/Shanghai",
                      "Asia/Singapore",
                      "Asia/Srednekolymsk",
                      "Asia/Taipei",
                      "Asia/Tashkent",
                      "Asia/Tbilisi",
                      "Asia/Tehran",
                      "Asia/Tokyo",
                      "Asia/Ulaanbaatar",
                      "Asia/Urumqi",
                      "Asia/Vladivostok",
                      "Asia/Yakutsk",
                      "Asia/Yekaterinburg",
                      "Asia/Yerevan",
                      "Atlantic/Azores",
                      "Atlantic/Cape_Verde",
                      "Atlantic/South_Georgia",
                      "Australia/Adelaide",
                      "Australia/Brisbane",
                      "Australia/Darwin",
                      "Australia/Hobart",
                      "Australia/Melbourne",
                      "Australia/Perth",
                      "Australia/Sydney",
                      "Europe/Amsterdam",
                      "Europe/Athens",
                      "Europe/Belgrade",
                      "Europe/Berlin",
                      "Europe/Bratislava",
                      "Europe/Brussels",
                      "Europe/Bucharest",
                      "Europe/Budapest",
                      "Europe/Copenhagen",
                      "Europe/Dublin",
                      "Europe/Helsinki",
                      "Europe/Istanbul",
                      "Europe/Kaliningrad",
                      "Europe/Kiev",
                      "Europe/Lisbon",
                      "Europe/Ljubljana",
                      "Europe/London",
                      "Europe/Madrid",
                      "Europe/Minsk",
                      "Europe/Moscow",
                      "Europe/Paris",
                      "Europe/Prague",
                      "Europe/Riga",
                      "Europe/Rome",
                      "Europe/Samara",
                      "Europe/Sarajevo",
                      "Europe/Skopje",
                      "Europe/Sofia",
                      "Europe/Stockholm",
                      "Europe/Tallinn",
                      "Europe/Vienna",
                      "Europe/Vilnius",
                      "Europe/Volgograd",
                      "Europe/Warsaw",
                      "Europe/Zagreb",
                      "Europe/Zurich",
                      "Pacific/Apia",
                      "Pacific/Auckland",
                      "Pacific/Chatham",
                      "Pacific/Fakaofo",
                      "Pacific/Fiji",
                      "Pacific/Guadalcanal",
                      "Pacific/Guam",
                      "Pacific/Honolulu",
                      "Pacific/Majuro",
                      "Pacific/Midway",
                      "Pacific/Noumea",
                      "Pacific/Pago_Pago",
                      "Pacific/Port_Moresby",
                      "Pacific/Tongatapu"
                    ],
                    desc: "name of the users current time zone, defaults to \"America/Chicago\""
                  },
                  ambassador: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Is this user part of the ambassador program"
                  },
                  do_not_email: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Set to true if this user asks to unsubscribe from this type of communication"
                  },
                  do_not_phone_call: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Set to true if this user asks to unsubscribe from this type of communication"
                  },
                  do_not_text_message: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Set to true if this user asks to unsubscribe from this type of communication"
                  },
                  private_profile: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Set to true to make this profile private"
                  },
                  verified: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Set to true to make this profile verified"
                  },
                  t_shirt_size: {
                    type: "Symbol",
                    values: [
                      "xs",
                      "s",
                      "m",
                      "l",
                      "xl",
                      "xxl"
                    ],
                    desc: "null, xs, s, m, l, xl or xxl"
                  },
                  nrdy_params: {
                    type: "Hash",
                    description: "all nrdy_* parameters (we need all of them so that we can recreate the signature to validate the request)"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a user",
              delete: true
            },
            {
              name: "id",
              resources: {
                organizations: {
                  name: "organizations",
                  description: "Get a list of organizations for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  authorize: [
                    "account"
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                statistics: {
                  name: "statistics",
                  description: "Get the statistics for this user",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                health_records: {
                  name: "health_records",
                  description: "Get a health_records for this user",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                learning_styles: {
                  name: "learning_styles",
                  description: "Get a learning_styles for this user",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                employee_reviews: {
                  name: "employee_reviews",
                  description: "List of employee_reviews for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                incidents: {
                  name: "incidents",
                  description: "List of incidents for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                invitations: {
                  name: "invitations",
                  description: "Get a list of invitations for this users",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                memberships: {
                  name: "memberships",
                  description: "Get a list of memberships for this users",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      role: {
                        type: "Symbol",
                        values: [
                          "ownership",
                          "instructorship",
                          "studentship",
                          "pickupship",
                          "attendship"
                        ],
                        desc: "the users role (permission level) at this organization, should be either ownership, instructorship or studentship"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                oauth_applications: {
                  name: "oauth_applications",
                  description: "Get a list of oauth_applications for this users",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                payment_methods: {
                  name: "payment_methods",
                  description: "Get a list of payment_methods for this user",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                phone_numbers: {
                  name: "phone_numbers",
                  description: "List of phone_numbers for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                progresses: {
                  name: "progresses",
                  description: "Get a list of progresses for this user",
                  filter_options: [
                    {
                      publishable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      tutorial_id: {
                        uuid: true,
                        desc: "Optionally, a tutorial_id to scope the resuls to"
                      },
                      step_id: {
                        uuid: true,
                        desc: "Optionally, a step_id to scope the resuls to"
                      },
                      project_id: {
                        uuid: true,
                        desc: "Optionally, a project_id to scope the resuls to"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                projects: {
                  name: "projects",
                  description: "Get a list of projects for this users",
                  filter_options: [
                    {
                      deletable: true,
                      archivable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      q: {
                        type: "String",
                        desc: "search the projects"
                      }
                    }
                  },
                  authorize: [
                    "account"
                  ],
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at",
                    "name"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                photos: {
                  name: "photos",
                  description: "List of photos for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                notes: {
                  name: "notes",
                  description: "List of notes for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                checklist_submissions: {
                  name: "checklist_submissions",
                  description: "List of checklist_submissions for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      version_id: {
                        uuid: true,
                        desc: "the checklist version"
                      },
                      status: {
                        type: "Symbol",
                        values: [
                          "new",
                          "submitted",
                          "approved",
                          "denied"
                        ],
                        desc: "new, submitted, approved or denied"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                user_addresses: {
                  name: "user_addresses",
                  description: "List of addresses for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                how_heard_about: {
                  name: "how_heard_about",
                  description: "Get the how_heard_about for this user",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                badge_achievements: {
                  name: "badge_achievements",
                  description: "List of badge_achievements for this user",
                  params: {
                    requires: {},
                    optional: {
                      recalculate: {
                        type: "Virtus::Attribute::Boolean",
                        desc: "if true, will recalculate all projects"
                      },
                      project_id: {
                        uuid: true,
                        desc: "if provided, will process this project before returning badges"
                      }
                    }
                  },
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                curriculum_accomplishments: {
                  name: "curriculum_accomplishments",
                  description: "List of accomplishments for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                mission_achievements: {
                  name: "mission_achievements",
                  description: "List of mission_achievements for this user",
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                curriculum_scores: {
                  name: "curriculum_scores",
                  description: "List of scores for this user",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                user_rank: {
                  name: "user_rank",
                  description: "Get a user_rank for this user",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                meetings: {
                  name: "meetings",
                  description: "List of meetings for this user",
                  filter_params: {
                    requires: {},
                    optional: {
                      after: {
                        type: "Date",
                        desc: "filter by date"
                      },
                      before: {
                        type: "Date",
                        desc: "filter by date"
                      },
                      include_past: {
                        type: "Virtus::Attribute::Boolean",
                        desc: "include meetings which ended in the past"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "start_at"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                public_apps: {
                  name: "public_apps",
                  description: "Get a list of public_apps for this user",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                participations: {
                  name: "participations",
                  description: "List of participations for this user",
                  filter_params: {
                    requires: {},
                    optional: {
                      include_abandoned: {
                        type: "Virtus::Attribute::Boolean",
                        desc: "include participations which have been abandoned"
                      },
                      include_past: {
                        type: "Virtus::Attribute::Boolean",
                        desc: "include participations for meetings which ended in the past"
                      },
                      status: {
                        type: "Symbol",
                        values: [
                          "new",
                          "joined",
                          "left",
                          "ended",
                          "abandoned",
                          "illegal_abandoned",
                          "no_show",
                          "guide_abandoned",
                          "guide_no_show"
                        ],
                        desc: [
                          "new",
                          "joined",
                          "left",
                          "ended",
                          "abandoned",
                          "illegal_abandoned",
                          "no_show",
                          "guide_abandoned",
                          "guide_no_show"
                        ]
                      },
                      statuses: {
                        type: "Array",
                        desc: "array of statuses"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                guide_availabilities: {
                  name: "guide_availabilities",
                  description: "List of availabilities for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      location_id: {
                        uuid: true
                      },
                      location_ids: {
                        type: "Array"
                      },
                      occasion_id: {
                        uuid: true
                      },
                      occasion_ids: {
                        type: "Array"
                      },
                      date: {
                        type: "Date",
                        desc: "the date of a hypothetical booking"
                      },
                      start_hour: {
                        type: "Integer",
                        desc: "the hour of the day that the slot starts"
                      },
                      start_minute: {
                        type: "Integer",
                        desc: "the minute of the day that the slot starts"
                      },
                      end_hour: {
                        type: "Integer",
                        desc: "the hour of the day that the slot ends"
                      },
                      end_minute: {
                        type: "Integer",
                        desc: "the minute of the day that the slot ends"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at",
                    "first_available_at",
                    "last_available_at",
                    "start_hour",
                    "end_hour"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                booking_instances: {
                  name: "booking_instances",
                  description: "List of booking_instances for this user",
                  filter_params: {
                    requires: {},
                    optional: {
                      location_id: {
                        uuid: true
                      },
                      location_ids: {
                        type: "Array"
                      },
                      occasion_id: {
                        uuid: true
                      },
                      occasion_ids: {
                        type: "Array"
                      },
                      date: {
                        type: "Date",
                        desc: "the date of a hypothetical booking"
                      },
                      start_hour: {
                        type: "Integer",
                        desc: "the hour of the day that the slot starts"
                      },
                      start_minute: {
                        type: "Integer",
                        desc: "the minute of the day that the slot starts"
                      },
                      end_hour: {
                        type: "Integer",
                        desc: "the hour of the day that the slot ends"
                      },
                      end_minute: {
                        type: "Integer",
                        desc: "the minute of the day that the slot ends"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at",
                    "first_available_at",
                    "last_available_at",
                    "start_hour",
                    "end_hour"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                guide_blocks: {
                  name: "guide_blocks",
                  description: "List of blocks for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                guide_preferences: {
                  name: "guide_preferences",
                  description: "List of preferences for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                guide_schedulables: {
                  name: "guide_schedulables",
                  description: "List of schedulables for this user",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                guide_rating: {
                  name: "guide_rating",
                  description: "Get a guide_rating for this user",
                  get: true
                },
                guide_ratings: {
                  name: "guide_ratings",
                  description: "Get a guide_rating for this user, but return as a collection",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                guide_profile: {
                  name: "guide_profile",
                  description: "Get a guide_profile for this user",
                  get: true
                },
                guide_profiles: {
                  name: "guide_profiles",
                  description: "Get a guide_profile for this user, but return as a collection",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                stripe_account: {
                  name: "stripe_account",
                  description: "Get a stripe_account for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  filter_params: {
                    requires: {},
                    optional: {
                      include_account_link: {
                        type: "Virtus::Attribute::Boolean",
                        default: false
                      }
                    }
                  },
                  get: true
                },
                stripe_accounts: {
                  name: "stripe_accounts",
                  description: "Get a stripe_account for this user, but return as a collection",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                earnings: {
                  name: "earnings",
                  description: "List of earnings for this user",
                  filter_params: {
                    requires: {},
                    optional: {}
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                checkr_account: {
                  name: "checkr_account",
                  description: "Get a checkr_account for this user",
                  get: true
                },
                checkr_accounts: {
                  name: "checkr_accounts",
                  description: "Get a checkr_account for this user, but return as a collection",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                friend_requests: {
                  name: "friend_requests",
                  description: "List of friend_requests for this user",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                friendships: {
                  name: "friendships",
                  description: "List of friendships for this user",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                version_stars: {
                  name: "version_stars",
                  description: "List of version_stars for this user",
                  filter_params: {
                    requires: {},
                    optional: {
                      project_id: {
                        uuid: true,
                        desc: "the project that was flagged"
                      },
                      version_id: {
                        uuid: true,
                        desc: "the version that was flagged"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                followings: {
                  name: "followings",
                  description: "List of followings for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                followers: {
                  name: "followers",
                  description: "List of followers for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                version_flags: {
                  name: "version_flags",
                  description: "List of version_flags for this user",
                  filter_params: {
                    requires: {},
                    optional: {
                      project_id: {
                        uuid: true,
                        desc: "the project that was flagged"
                      },
                      version_id: {
                        uuid: true,
                        desc: "the version that was flagged"
                      }
                    }
                  },
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                keyring_purchases: {
                  name: "keyring_purchases",
                  description: "List of keyring_purchases for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                bank_balance: {
                  name: "bank_balance",
                  description: "Get a bank_balance for this user",
                  get: true
                },
                bank_balances: {
                  name: "bank_balances",
                  description: "Get a bank_balance for this user, but return as a collection",
                  get: true
                }
              }
            },
            {
              name: "id",
              resources: {
                keyring_grants: {
                  name: "keyring_grants",
                  description: "List of keyring_grants for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                bank_balance_adjustments: {
                  name: "bank_balance_adjustments",
                  description: "List of bank_balance_adjustments for this user",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                economy_ledgers: {
                  name: "economy_ledgers",
                  description: "List of ledgers for this user",
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Users::Address": {
          name: "user_addresses",
          description: "Returns all user_addresses",
          create_options: [
            {
              optional_relationships: [
                "organization"
              ],
              required_relationships: [
                "user"
              ]
            }
          ],
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                desc: "Person name or business name"
              },
              address1: {
                type: "String",
                desc: "Address1 of this user_address"
              },
              city: {
                type: "String",
                allow_blank: false,
                desc: "City of this user_address"
              },
              state: {
                type: "String",
                allow_blank: false,
                desc: "State of this user_address"
              },
              zip_code: {
                type: "String",
                allow_blank: false,
                desc: "Zip Code of this user_address"
              },
              country_code: {
                type: "String",
                allow_blank: false,
                desc: "Country of this user_address"
              }
            },
            optional: {
              default: {
                type: "Virtus::Attribute::Boolean",
                default: false,
                desc: "Pass true to make this the default address"
              },
              address2: {
                type: "String",
                desc: "Address2 of this user_address"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a user_address",
              get: true
            },
            {
              name: "id",
              description: "Update a user_address",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  default: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Pass true to set this as the default address"
                  },
                  name: {
                    type: "String",
                    desc: "Person name or business name"
                  },
                  address1: {
                    type: "String",
                    desc: "Address1 of this user_address"
                  },
                  address2: {
                    type: "String",
                    desc: "Address2 of this user_address"
                  },
                  city: {
                    type: "String",
                    desc: "City of this user_address"
                  },
                  state: {
                    type: "String",
                    desc: "State of this user_address"
                  },
                  zip_code: {
                    type: "String",
                    desc: "Zip Code of this user_address"
                  },
                  country_code: {
                    type: "String",
                    desc: "Country of this user_address"
                  },
                  latitude: {
                    type: "BigDecimal",
                    desc: "Latitude of this user_address"
                  },
                  longitude: {
                    type: "BigDecimal",
                    desc: "Longitude of this user_address"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a user_address",
              delete: true
            }
          ]
        },
        "Projects::Version": {
          name: "versions",
          description: "Create a version",
          create_options: [
            {
              required_relationships: [
                "project"
              ]
            }
          ],
          create_params: {
            requires: {
              significance: {
                type: "Symbol",
                values: [
                  "major",
                  "minor",
                  "patch"
                ],
                desc: "major, minor or patch"
              }
            },
            optional: {
              kidscript_version: {
                type: "String",
                allow_blank: false
              },
              screenshot: {
                type: "String",
                desc: "A screenshot of this project which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              },
              status: {
                type: "Symbol",
                values: [
                  "is_private",
                  "is_public",
                  "submitted",
                  "needs_changes",
                  "launched"
                ],
                desc: "is_private, is_public, submitted, needs_changes or launched"
              },
              status_comments: {
                type: "String",
                desc: "Comments for this change"
              }
            }
          },
          filter_options: [
            {
              publishable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              ids: {
                type: "Array"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a specific version",
              get: true,
              id_param: true
            },
            {
              name: "id",
              resources: {
                project: {
                  name: "project",
                  description: "Get a project for this version",
                  get: true
                }
              }
            },
            {
              name: "id",
              description: "Update a version",
              update_options: [
                {
                  optional_relationships: [
                    "project_category"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name for the published version of this app"
                  },
                  description: {
                    type: "String",
                    desc: "Description of this app"
                  },
                  screenshot: {
                    type: "String",
                    desc: "A screenshot of this project which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  },
                  status: {
                    type: "Symbol",
                    values: [
                      "is_private",
                      "is_public",
                      "submitted",
                      "needs_changes",
                      "launched"
                    ],
                    desc: "is_private, is_public, submitted, needs_changes or launched"
                  },
                  status_comments: {
                    type: "String",
                    desc: "Comments for this change"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                version_status_changes: {
                  name: "version_status_changes",
                  description: "List of version_status_changes for this version",
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "changed_at"
                  ]
                }
              }
            }
          ]
        },
        "Billing::Voucher": {
          name: "vouchers",
          description: "Returns all vouchers",
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this voucher"
              },
              description: {
                type: "String",
                desc: "Description of this voucher"
              },
              quantity: {
                type: "Integer",
                desc: "Quantity of this voucher"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a voucher",
              get: true
            },
            {
              name: "id",
              description: "Update a voucher",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this voucher"
                  },
                  description: {
                    type: "String",
                    desc: "Description of this voucher"
                  },
                  quantity: {
                    type: "Integer",
                    desc: "Quantity of this voucher"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a voucher",
              delete: true
            }
          ]
        },
        "Curriculum::BadgeAchievement": {
          name: "badge_achievements",
          description: "Returns all badge_achievements",
          create_options: [
            {
              required_relationships: [
                "user",
                "badge"
              ]
            }
          ],
          create_params: {
            requires: {
              notes: {
                type: "String",
                allow_blank: false,
                desc: "why this badge was added manually"
              }
            },
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a badge_achievement",
              delete: true
            },
            {
              name: "id",
              description: "Get a badge_achievement",
              get: true
            },
            {
              name: "id",
              description: "Update a badge_achievement",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  notes: {
                    type: "String",
                    allow_blank: false,
                    desc: "why this badge was added manually"
                  },
                  viewed: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "has this badge achievement been viewed"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Curriculum::BadgeDependentBadge": {
          name: "badge_dependent_badges",
          description: "Returns all badge_dependent_badges",
          create_options: [
            {
              required_relationships: [
                "badge",
                {
                  name: "dependent_badge",
                  as: "badge"
                }
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a badge_dependent_badge",
              delete: true
            },
            {
              name: "id",
              description: "Get a badge_dependent_badge",
              get: true
            },
            {
              name: "id",
              description: "Update a badge_dependent_badge",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {}
              },
              put: true
            }
          ]
        },
        "Curriculum::Badge": {
          name: "badges",
          description: "Returns all badges",
          create_options: [
            {
              publishable: true,
              optional_relationships: [
                {
                  name: "previous_badge",
                  as: "badge"
                },
                "library_keyring"
              ]
            }
          ],
          create_params: {
            requires: {
              name: {
                type: "String",
                desc: "Name of this badge"
              },
              description: {
                type: "String",
                desc: "Description of this badge"
              },
              minutes: {
                type: "Integer",
                allow_blank: false,
                desc: "Amount of time this should take"
              },
              difficulty_level: {
                type: "Symbol",
                allow_blank: false,
                values: [
                  "beginner",
                  "intermediate",
                  "advanced",
                  "expert",
                  "pro"
                ],
                desc: "beginner, intermediate, advanced, expert or pro"
              },
              image: {
                type: "String",
                allow_blank: false,
                desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              }
            },
            optional: {
              coins: {
                type: "Integer",
                allow_blank: true,
                desc: "how many nova coins this will award"
              },
              studio_only: {
                type: "Virtus::Attribute::Boolean",
                desc: "Is badge only available in the studio"
              },
              secret: {
                type: "Virtus::Attribute::Boolean",
                desc: "Is badge hidden but still acheivable"
              },
              guide_only: {
                type: "Virtus::Attribute::Boolean",
                desc: "Is badge only acheivable by guides"
              }
            }
          },
          filter_options: [
            {
              deletable: true,
              publishable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search the badges by name"
              },
              first_badge_id: {
                type: "String",
                desc: "get badges in the series begining with this badge"
              },
              first_badge_only: {
                type: "Virtus::Attribute::Boolean",
                desc: "get only top level, first in series badges"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "name",
            "points",
            "position"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a badge",
              delete: true
            },
            {
              name: "id",
              description: "Get a badge",
              get: true
            },
            {
              name: "id",
              description: "Update a badge",
              update_options: [
                {
                  deletable: true,
                  publishable: true,
                  optional_relationships: [
                    {
                      name: "previous_badge",
                      as: "badge"
                    },
                    "library_keyring"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this badge"
                  },
                  description: {
                    type: "String",
                    desc: "Description of this badge"
                  },
                  coins: {
                    type: "Integer",
                    allow_blank: true,
                    desc: "how many nova coins this will award"
                  },
                  minutes: {
                    type: "Integer",
                    allow_blank: false,
                    desc: "Amount of time this should take"
                  },
                  difficulty_level: {
                    type: "Symbol",
                    allow_blank: false,
                    values: [
                      "beginner",
                      "intermediate",
                      "advanced",
                      "expert",
                      "pro"
                    ],
                    desc: "beginner, intermediate, advanced, expert or pro"
                  },
                  studio_only: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Is badge only available in the studio"
                  },
                  secret: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Is badge hidden but still acheivable"
                  },
                  guide_only: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Is badge only acheivable by guides"
                  },
                  image: {
                    type: "String",
                    allow_blank: false,
                    desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                badge_dependent_badges: {
                  name: "badge_dependent_badges",
                  description: "List of badge_dependent_badges for this badge",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                badge_skills: {
                  name: "badge_skills",
                  description: "List of badge_skills for this badge",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                badge_conditions: {
                  name: "badge_conditions",
                  description: "List of badge_conditions for this badge",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Curriculum::BadgeSkill": {
          name: "badge_skills",
          description: "Returns all badge_skills",
          create_options: [
            {
              required_relationships: [
                "badge",
                "skill"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              ratio: {
                type: "Integer",
                desc: "Points awarded towards this skill"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a badge_skill",
              delete: true
            },
            {
              name: "id",
              description: "Get a badge_skill",
              get: true
            },
            {
              name: "id",
              description: "Update a badge_skill",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  ratio: {
                    type: "Integer",
                    desc: "Points awarded towards this skill"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Billing::CouponSubscriptionDiscounts::CouponSubscriptionDiscount": {
          name: "coupon_subscription_discounts",
          description: "Returns all coupon_subscription_discounts",
          create_options: [
            {
              required_relationships: [
                "coupon"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              amount: {
                type: "BigDecimal",
                coerce_with: "APICoercions::MoneyToBigDecimal",
                desc: "Amount of this coupon_subscription_discount"
              },
              additional_member_amount: {
                type: "BigDecimal",
                coerce_with: "APICoercions::MoneyToBigDecimal",
                desc: "Additional Member Amount of this coupon_subscription_discount"
              },
              number_of_billing_cycles: {
                type: "Integer",
                desc: "Number Of Billing Cycles of this coupon_subscription_discount"
              },
              target: {
                type: "Symbol",
                values: [
                  "explorer",
                  "studio",
                  "saas",
                  "nova",
                  "supernova_lite",
                  "supernova_pro",
                  "supernova_starter",
                  "supernova"
                ],
                desc: "explorer, studio, saas, nova, supernova_lite, supernova_pro, supernova_starter or supernova"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a coupon_subscription_discount",
              delete: true
            },
            {
              name: "id",
              description: "Get a coupon_subscription_discount",
              get: true
            },
            {
              name: "id",
              description: "Update a coupon_subscription_discount",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  amount: {
                    type: "BigDecimal",
                    coerce_with: "APICoercions::MoneyToBigDecimal",
                    desc: "Amount of this coupon_subscription_discount"
                  },
                  additional_member_amount: {
                    type: "BigDecimal",
                    coerce_with: "APICoercions::MoneyToBigDecimal",
                    desc: "Additional Member Amount of this coupon_subscription_discount"
                  },
                  number_of_billing_cycles: {
                    type: "Integer",
                    desc: "Number Of Billing Cycles of this coupon_subscription_discount"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Curriculum::Activities::Activity": {
          name: "curriculum_activities",
          description: "Returns all curriculum_activities",
          create_options: [
            {
              publishable: true,
              optional_relationships: [
                "curriculum_mission"
              ]
            }
          ],
          create_params: {
            requires: {
              minutes: {
                type: "Integer",
                allow_blank: false,
                desc: "Amount of time this should take"
              },
              difficulty_level: {
                type: "Symbol",
                allow_blank: false,
                values: [
                  "beginner",
                  "intermediate",
                  "advanced",
                  "expert",
                  "pro"
                ],
                desc: "beginner, intermediate, advanced, expert or pro"
              },
              awards_points: {
                type: "Virtus::Attribute::Boolean",
                desc: "Does completing this activity award points"
              },
              awards_mission_points: {
                type: "Virtus::Attribute::Boolean",
                desc: "Does completing this activity award points"
              },
              awards_badge_points: {
                type: "Virtus::Attribute::Boolean",
                desc: "Does completing this activity award points"
              }
            },
            optional: {
              name: {
                type: "String",
                desc: "Name of this activity"
              },
              notes: {
                type: "String",
                desc: "Notes of this activity"
              },
              hint: {
                type: "String",
                desc: "Hint of this activity"
              },
              validation_rules: {
                type: "Hash",
                desc: "Validation Rules of this activity"
              },
              test_kidscript: {
                type: "String",
                desc: "Test Kidscript of this activity"
              },
              coins: {
                type: "Integer",
                allow_blank: true,
                desc: "how many nova coins this will award"
              },
              processor: {
                type: "Symbol",
                values: [
                  "manual",
                  "message_bus",
                  "event",
                  "kidscript",
                  "project_event",
                  "project_kidscript",
                  "mission_event",
                  "mission_kidscript"
                ],
                desc: "manual, message_bus, event, kidscript, project_event, project_kidscript, mission_event or mission_kidscript"
              }
            }
          },
          filter_options: [
            {
              deletable: true,
              publishable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search the activities"
              },
              processor: {
                type: "Symbol",
                values: [
                  "manual",
                  "message_bus",
                  "event",
                  "kidscript",
                  "project_event",
                  "project_kidscript",
                  "mission_event",
                  "mission_kidscript"
                ],
                desc: "manual, message_bus, event, kidscript, project_event, project_kidscript, mission_event or mission_kidscript"
              },
              processors: {
                type: "Array",
                desc: "array of processors"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a curriculum_activity",
              delete: true
            },
            {
              name: "id",
              description: "Get a activity",
              get: true
            },
            {
              name: "id",
              description: "Update a curriculum_activity",
              update_options: [
                {
                  deletable: true,
                  publishable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this activity"
                  },
                  notes: {
                    type: "String",
                    desc: "Notes of this activity"
                  },
                  hint: {
                    type: "String",
                    desc: "Hint of this activity"
                  },
                  validation_rules: {
                    type: "Hash",
                    desc: "Validation Rules of this activity"
                  },
                  test_kidscript: {
                    type: "String",
                    desc: "Test Kidscript of this activity"
                  },
                  coins: {
                    type: "Integer",
                    allow_blank: true,
                    desc: "how many nova coins this will award"
                  },
                  minutes: {
                    type: "Integer",
                    allow_blank: false,
                    desc: "Amount of time this should take"
                  },
                  difficulty_level: {
                    type: "Symbol",
                    allow_blank: false,
                    values: [
                      "beginner",
                      "intermediate",
                      "advanced",
                      "expert",
                      "pro"
                    ],
                    desc: "beginner, intermediate, advanced, expert or pro"
                  },
                  processor: {
                    type: "Symbol",
                    values: [
                      "manual",
                      "message_bus",
                      "event",
                      "kidscript",
                      "project_event",
                      "project_kidscript",
                      "mission_event",
                      "mission_kidscript"
                    ],
                    desc: "manual, message_bus, event, kidscript, project_event, project_kidscript, mission_event or mission_kidscript"
                  },
                  awards_points: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Does completing this activity award points"
                  },
                  awards_mission_points: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Does completing this activity award points"
                  },
                  awards_badge_points: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Does completing this activity award points"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                curriculum_activity_skills: {
                  name: "curriculum_activity_skills",
                  description: "List of curriculum_activity_skills for this curriculum_activity",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Curriculum::ActivitySkill": {
          name: "curriculum_activity_skills",
          description: "Returns all curriculum_activity_skills",
          create_options: [
            {
              required_relationships: [
                "curriculum_activity",
                "skill"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              ratio: {
                type: "Integer",
                desc: "Ratio of this activity_skill"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a curriculum_activity_skill",
              delete: true
            },
            {
              name: "id",
              description: "Get a activity_skill",
              get: true
            },
            {
              name: "id",
              description: "Update a curriculum_activity_skill",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  ratio: {
                    type: "Integer",
                    desc: "Ratio of this activity_skill"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Curriculum::Accomplishment": {
          name: "curriculum_accomplishments",
          description: "Returns all curriculum_accomplishments",
          create_options: [
            {
              optional_relationships: [
                "user",
                "project"
              ],
              required_relationships: [
                "curriculum_activity"
              ]
            }
          ],
          create_params: {
            requires: {
              count: {
                type: "Integer",
                allow_blank: false,
                desc: "number of occurrences of this activity"
              }
            },
            optional: {}
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a accomplishment",
              get: true
            },
            {
              name: "id",
              description: "Update a curriculum_accomplishment",
              update_options: [
                {
                  deletable: true
                }
              ],
              put: true
            },
            {
              name: "id",
              description: "Delete a curriculum_accomplishment",
              delete: true
            }
          ]
        },
        "Curriculum::LearningPathLevel": {
          name: "learning_path_levels",
          description: "Returns all learning_path_levels",
          create_options: [
            {
              required_relationships: [
                "learning_path"
              ]
            }
          ],
          create_params: {
            requires: {
              minutes: {
                type: "Integer",
                allow_blank: false,
                desc: "Amount of time this should take"
              },
              difficulty_level: {
                type: "Symbol",
                allow_blank: false,
                values: [
                  "beginner",
                  "intermediate",
                  "advanced",
                  "expert",
                  "pro"
                ],
                desc: "beginner, intermediate, advanced, expert or pro"
              }
            },
            optional: {
              position: {
                type: "Integer",
                desc: "Position of this learning_path_level"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a learning_path_level",
              delete: true
            },
            {
              name: "id",
              description: "Get a learning_path_level",
              get: true
            },
            {
              name: "id",
              description: "Update a learning_path_level",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  minutes: {
                    type: "Integer",
                    allow_blank: false,
                    desc: "Amount of time this should take"
                  },
                  difficulty_level: {
                    type: "Symbol",
                    allow_blank: false,
                    values: [
                      "beginner",
                      "intermediate",
                      "advanced",
                      "expert",
                      "pro"
                    ],
                    desc: "beginner, intermediate, advanced, expert or pro"
                  },
                  position: {
                    type: "Integer",
                    desc: "Position of this learning_path_level"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                learning_path_level_skill_levels: {
                  name: "learning_path_level_skill_levels",
                  description: "List of learning_path_level_skill_levels for this learning_path_level",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Curriculum::LearningPath": {
          name: "learning_paths",
          description: "Returns all learning_paths",
          create_params: {
            requires: {
              name: {
                type: "String",
                desc: "Name of this learning_path"
              },
              description: {
                type: "String",
                desc: "Description of this learning_path"
              },
              icon: {
                type: "String",
                allow_blank: false,
                desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              },
              guide_only: {
                type: "Virtus::Attribute::Boolean",
                desc: "Is this only acheivable by guides"
              }
            },
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search the learning path by name"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "name"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a learning_path",
              delete: true
            },
            {
              name: "id",
              description: "Get a learning_path",
              get: true
            },
            {
              name: "id",
              description: "Update a learning_path",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this learning_path"
                  },
                  description: {
                    type: "String",
                    desc: "Description of this learning_path"
                  },
                  icon: {
                    type: "String",
                    allow_blank: false,
                    desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  },
                  guide_only: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Is this only acheivable by guides"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                skills: {
                  name: "skills",
                  description: "List of skills for this learning_path",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at",
                    "name"
                  ]
                }
              }
            },
            {
              name: "id",
              resources: {
                learning_path_levels: {
                  name: "learning_path_levels",
                  description: "List of learning_path_levels for this learning_path",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at",
                    "position",
                    "points"
                  ]
                }
              }
            }
          ]
        },
        "Library::ObjectIncludedEngineEvent": {
          name: "library_object_included_engine_events",
          description: "Returns all library_object_included_engine_events",
          create_options: [
            {
              required_relationships: [
                "library_engine_event",
                "library_object"
              ],
              optional_relationships: [
                "library_keyring"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              super_power: {
                type: "Virtus::Attribute::Boolean",
                desc: "Super Power of this object_included_engine_event"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a library_object_included_engine_event",
              delete: true
            },
            {
              name: "id",
              description: "Get a object_included_engine_event",
              get: true
            },
            {
              name: "id",
              description: "Update a library_object_included_engine_event",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "library_keyring"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  super_power: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Super Power of this object_included_engine_event"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Library::ObjectIncludedEngineMethod": {
          name: "library_object_included_engine_methods",
          description: "Returns all library_object_included_engine_methods",
          create_options: [
            {
              required_relationships: [
                "library_engine_method",
                "library_object"
              ],
              optional_relationships: [
                "library_keyring"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              super_power: {
                type: "Virtus::Attribute::Boolean",
                desc: "Super Power of this object_included_engine_method"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a object_included_engine_method",
              get: true
            },
            {
              name: "id",
              description: "Update a library_object_included_engine_method",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "library_keyring"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  super_power: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Super Power of this object_included_engine_method"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Library::ObjectReactionModule": {
          name: "library_object_reaction_modules",
          description: "Returns all library_object_reaction_modules",
          create_options: [
            {
              required_relationships: [
                "library_object_reaction",
                "library_engine_module"
              ]
            }
          ],
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a library_object_reaction_module",
              delete: true
            },
            {
              name: "id",
              description: "Get a object_reaction_module",
              get: true
            },
            {
              name: "id",
              description: "Update a library_object_reaction_module",
              update_options: [
                {
                  deletable: true
                }
              ],
              put: true
            }
          ]
        },
        "Library::ObjectReaction": {
          name: "library_object_reactions",
          description: "Returns all library_object_reactions",
          create_options: [
            {
              required_relationships: [
                "library_object"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              javascript: {
                type: "String",
                desc: "Javascript of this object_reaction"
              },
              key: {
                type: "String",
                desc: "Key of this object_reaction"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a library_object_reaction",
              delete: true
            },
            {
              name: "id",
              description: "Get a object_reaction",
              get: true
            },
            {
              name: "id",
              description: "Update a library_object_reaction",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  javascript: {
                    type: "String",
                    desc: "Javascript of this object_reaction"
                  },
                  key: {
                    type: "String",
                    desc: "Key of this object_reaction"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                library_object_reaction_modules: {
                  name: "library_object_reaction_modules",
                  description: "List of object_reaction_modules for this object_reaction",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Curriculum::MissionObjects::MissionObject": {
          name: "mission_objects",
          description: "Returns all mission_objects",
          create_options: [
            {
              required_relationships: [
                "mission",
                "library_object"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              basis: {
                type: "Symbol",
                values: [
                  "dependency",
                  "featured"
                ],
                desc: "dependency and featured"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a mission_object",
              delete: true
            },
            {
              name: "id",
              description: "Get a mission_object",
              get: true
            },
            {
              name: "id",
              description: "Update a mission_object",
              update_options: [
                {
                  deletable: true
                }
              ],
              put: true
            }
          ]
        },
        "Curriculum::Missions::Mission": {
          name: "missions",
          description: "Returns all missions",
          create_options: [
            {
              optional_relationships: [
                "library_keyring"
              ]
            }
          ],
          create_params: {
            requires: {
              name: {
                type: "String",
                desc: "Name of this mission"
              },
              description: {
                type: "String",
                desc: "Description of this mission"
              },
              minutes: {
                type: "Integer",
                allow_blank: false,
                desc: "Amount of time this should take"
              },
              difficulty_level: {
                type: "Symbol",
                allow_blank: false,
                values: [
                  "beginner",
                  "intermediate",
                  "advanced",
                  "expert",
                  "pro"
                ],
                desc: "beginner, intermediate, advanced, expert or pro"
              },
              icon: {
                type: "String",
                allow_blank: false,
                desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              },
              series: {
                type: "Symbol",
                values: [
                  "standard",
                  "bonus",
                  "competition"
                ],
                desc: "standard, bonus or competition"
              }
            },
            optional: {
              position: {
                type: "Integer",
                desc: "Position of this mission"
              },
              coins: {
                type: "Integer",
                allow_blank: true,
                desc: "how many nova coins this will award"
              },
              hidden: {
                type: "Virtus::Attribute::Boolean",
                desc: "hide this mission from the mission catalog"
              },
              guide_only: {
                type: "Virtus::Attribute::Boolean",
                desc: "Is this only acheivable by guides"
              },
              required_multiple_choice_question_count: {
                type: "Integer",
                desc: "Number of multiple choice questions which must be answered correctly to complete this mission"
              }
            }
          },
          filter_options: [
            {
              deletable: true,
              publishable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              ids: {
                type: "Array"
              },
              q: {
                type: "String",
                desc: "search the missions by name"
              },
              difficulty_level: {
                type: "Symbol",
                values: [
                  "beginner",
                  "intermediate",
                  "advanced",
                  "expert",
                  "pro"
                ],
                desc: "beginner, intermediate, advanced, expert or pro"
              },
              hidden: {
                type: "Virtus::Attribute::Boolean",
                desc: "return only hidden missions"
              },
              digital: {
                type: "Virtus::Attribute::Boolean",
                desc: "return only digital missions"
              },
              guide_only: {
                type: "Virtus::Attribute::Boolean",
                desc: "return only guide missions"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a mission",
              delete: true
            },
            {
              name: "id",
              description: "Get a mission",
              get: true
            },
            {
              name: "id",
              description: "Update a mission",
              update_options: [
                {
                  deletable: true,
                  publishable: true,
                  optional_relationships: [
                    "library_keyring"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this mission"
                  },
                  position: {
                    type: "Integer",
                    desc: "Position of this mission"
                  },
                  description: {
                    type: "String",
                    desc: "Description of this mission"
                  },
                  coins: {
                    type: "Integer",
                    allow_blank: true,
                    desc: "how many nova coins this will award"
                  },
                  minutes: {
                    type: "Integer",
                    allow_blank: false,
                    desc: "Amount of time this should take"
                  },
                  difficulty_level: {
                    type: "Symbol",
                    allow_blank: false,
                    values: [
                      "beginner",
                      "intermediate",
                      "advanced",
                      "expert",
                      "pro"
                    ],
                    desc: "beginner, intermediate, advanced, expert or pro"
                  },
                  icon: {
                    type: "String",
                    allow_blank: false,
                    desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  },
                  series: {
                    type: "Symbol",
                    values: [
                      "standard",
                      "bonus",
                      "competition"
                    ],
                    desc: "standard, bonus or competition"
                  },
                  hidden: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "hide this mission from the mission catalog"
                  },
                  guide_only: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Is this only acheivable by guides"
                  },
                  required_multiple_choice_question_count: {
                    type: "Integer",
                    desc: "Number of multiple choice questions which must be answered correctly to complete this mission"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                mission_objects: {
                  name: "mission_objects",
                  description: "List of mission_objects for this mission",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                mission_skills: {
                  name: "mission_skills",
                  description: "List of mission_skills for this mission",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                mission_steps: {
                  name: "mission_steps",
                  description: "List of mission_steps for this mission",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Curriculum::MissionSkill": {
          name: "mission_skills",
          description: "Returns all mission_skills",
          create_options: [
            {
              required_relationships: [
                "mission",
                "skill"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              ratio: {
                type: "Integer",
                desc: "Ratio of this mission_skill"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a mission_skill",
              delete: true
            },
            {
              name: "id",
              description: "Get a mission_skill",
              get: true
            },
            {
              name: "id",
              description: "Update a mission_skill",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  ratio: {
                    type: "Integer",
                    desc: "Ratio of this mission_skill"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Organizations::Address": {
          name: "organization_addresses",
          description: "Returns all organization_address",
          create_options: [
            {
              required_relationships: [
                "organization"
              ]
            }
          ],
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                desc: "Person name or business name"
              },
              address1: {
                type: "String",
                desc: "Address1 of this organization_address"
              },
              city: {
                type: "String",
                allow_blank: false,
                desc: "City of this organization_address"
              },
              state: {
                type: "String",
                allow_blank: false,
                desc: "State of this organization_address"
              },
              zip_code: {
                type: "String",
                allow_blank: false,
                desc: "Zip Code of this organization_address"
              },
              country_code: {
                type: "String",
                allow_blank: false,
                desc: "Country of this organization_address"
              }
            },
            optional: {
              default: {
                type: "Virtus::Attribute::Boolean",
                default: false,
                desc: "Pass true to make this the default address"
              },
              address2: {
                type: "String",
                desc: "Address2 of this organization_address"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete an organization_address",
              delete: true
            },
            {
              name: "id",
              description: "Get an organization_address",
              get: true
            },
            {
              name: "id",
              description: "Update a user_address",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  default: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Pass true to set this as the default address"
                  },
                  name: {
                    type: "String",
                    desc: "Person name or business name"
                  },
                  address1: {
                    type: "String",
                    desc: "Address1 of this user_address"
                  },
                  address2: {
                    type: "String",
                    desc: "Address2 of this user_address"
                  },
                  city: {
                    type: "String",
                    desc: "City of this user_address"
                  },
                  state: {
                    type: "String",
                    desc: "State of this user_address"
                  },
                  zip_code: {
                    type: "String",
                    desc: "Zip Code of this user_address"
                  },
                  country_code: {
                    type: "String",
                    desc: "Country of this user_address"
                  },
                  latitude: {
                    type: "BigDecimal",
                    desc: "Latitude of this user_address"
                  },
                  longitude: {
                    type: "BigDecimal",
                    desc: "Longitude of this user_address"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Organizations::PhoneNumber": {
          name: "organization_phone_numbers",
          description: "Returns all organization_phone_numbers",
          create_options: [
            {
              required_relationships: [
                "organization"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              dialing_code: {
                type: "String",
                values: [
                  "1",
                  "20",
                  "211",
                  "212",
                  "213",
                  "216",
                  "218",
                  "220",
                  "221",
                  "222",
                  "223",
                  "224",
                  "225",
                  "226",
                  "227",
                  "228",
                  "229",
                  "230",
                  "231",
                  "232",
                  "233",
                  "234",
                  "235",
                  "236",
                  "237",
                  "238",
                  "239",
                  "240",
                  "241",
                  "242",
                  "243",
                  "244",
                  "245",
                  "246",
                  "248",
                  "249",
                  "250",
                  "251",
                  "252",
                  "253",
                  "254",
                  "255",
                  "256",
                  "257",
                  "258",
                  "260",
                  "261",
                  "262",
                  "263",
                  "264",
                  "265",
                  "266",
                  "267",
                  "268",
                  "269",
                  "27",
                  "290",
                  "291",
                  "297",
                  "298",
                  "299",
                  "30",
                  "31",
                  "32",
                  "33",
                  "34",
                  "350",
                  "351",
                  "352",
                  "353",
                  "354",
                  "355",
                  "356",
                  "357",
                  "358",
                  "359",
                  "36",
                  "370",
                  "371",
                  "372",
                  "373",
                  "374",
                  "375",
                  "376",
                  "377",
                  "378",
                  "380",
                  "381",
                  "382",
                  "385",
                  "386",
                  "387",
                  "389",
                  "39",
                  "40",
                  "41",
                  "420",
                  "421",
                  "423",
                  "43",
                  "44",
                  "45",
                  "46",
                  "47",
                  "48",
                  "49",
                  "500",
                  "501",
                  "502",
                  "503",
                  "504",
                  "505",
                  "506",
                  "507",
                  "508",
                  "509",
                  "51",
                  "52",
                  "53",
                  "54",
                  "55",
                  "56",
                  "57",
                  "58",
                  "590",
                  "591",
                  "592",
                  "593",
                  "594",
                  "595",
                  "596",
                  "597",
                  "598",
                  "599",
                  "60",
                  "61",
                  "62",
                  "63",
                  "64",
                  "65",
                  "66",
                  "670",
                  "672",
                  "673",
                  "674",
                  "675",
                  "676",
                  "677",
                  "678",
                  "679",
                  "680",
                  "681",
                  "682",
                  "683",
                  "685",
                  "686",
                  "687",
                  "688",
                  "689",
                  "690",
                  "691",
                  "692",
                  "7",
                  "81",
                  "82",
                  "84",
                  "850",
                  "852",
                  "853",
                  "855",
                  "856",
                  "86",
                  "880",
                  "886",
                  "90",
                  "91",
                  "92",
                  "93",
                  "94",
                  "95",
                  "960",
                  "961",
                  "962",
                  "963",
                  "964",
                  "965",
                  "966",
                  "967",
                  "968",
                  "970",
                  "971",
                  "972",
                  "973",
                  "974",
                  "975",
                  "976",
                  "977",
                  "98",
                  "992",
                  "993",
                  "994",
                  "995",
                  "996",
                  "998"
                ],
                desc: "a valid country dialing code, i.e. 1 for the US and 44 for the UK"
              },
              phone_number: {
                type: "String",
                desc: "Phone Number of this phone_number"
              },
              default: {
                type: "Virtus::Attribute::Boolean",
                desc: "Is this the users default preferred number"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Delete a organization_phone_number",
              delete: true
            },
            {
              name: "id",
              description: "Get a phone_number",
              get: true
            },
            {
              name: "id",
              description: "Update a organization_phone_number",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  dialing_code: {
                    type: "String",
                    values: [
                      "1",
                      "20",
                      "211",
                      "212",
                      "213",
                      "216",
                      "218",
                      "220",
                      "221",
                      "222",
                      "223",
                      "224",
                      "225",
                      "226",
                      "227",
                      "228",
                      "229",
                      "230",
                      "231",
                      "232",
                      "233",
                      "234",
                      "235",
                      "236",
                      "237",
                      "238",
                      "239",
                      "240",
                      "241",
                      "242",
                      "243",
                      "244",
                      "245",
                      "246",
                      "248",
                      "249",
                      "250",
                      "251",
                      "252",
                      "253",
                      "254",
                      "255",
                      "256",
                      "257",
                      "258",
                      "260",
                      "261",
                      "262",
                      "263",
                      "264",
                      "265",
                      "266",
                      "267",
                      "268",
                      "269",
                      "27",
                      "290",
                      "291",
                      "297",
                      "298",
                      "299",
                      "30",
                      "31",
                      "32",
                      "33",
                      "34",
                      "350",
                      "351",
                      "352",
                      "353",
                      "354",
                      "355",
                      "356",
                      "357",
                      "358",
                      "359",
                      "36",
                      "370",
                      "371",
                      "372",
                      "373",
                      "374",
                      "375",
                      "376",
                      "377",
                      "378",
                      "380",
                      "381",
                      "382",
                      "385",
                      "386",
                      "387",
                      "389",
                      "39",
                      "40",
                      "41",
                      "420",
                      "421",
                      "423",
                      "43",
                      "44",
                      "45",
                      "46",
                      "47",
                      "48",
                      "49",
                      "500",
                      "501",
                      "502",
                      "503",
                      "504",
                      "505",
                      "506",
                      "507",
                      "508",
                      "509",
                      "51",
                      "52",
                      "53",
                      "54",
                      "55",
                      "56",
                      "57",
                      "58",
                      "590",
                      "591",
                      "592",
                      "593",
                      "594",
                      "595",
                      "596",
                      "597",
                      "598",
                      "599",
                      "60",
                      "61",
                      "62",
                      "63",
                      "64",
                      "65",
                      "66",
                      "670",
                      "672",
                      "673",
                      "674",
                      "675",
                      "676",
                      "677",
                      "678",
                      "679",
                      "680",
                      "681",
                      "682",
                      "683",
                      "685",
                      "686",
                      "687",
                      "688",
                      "689",
                      "690",
                      "691",
                      "692",
                      "7",
                      "81",
                      "82",
                      "84",
                      "850",
                      "852",
                      "853",
                      "855",
                      "856",
                      "86",
                      "880",
                      "886",
                      "90",
                      "91",
                      "92",
                      "93",
                      "94",
                      "95",
                      "960",
                      "961",
                      "962",
                      "963",
                      "964",
                      "965",
                      "966",
                      "967",
                      "968",
                      "970",
                      "971",
                      "972",
                      "973",
                      "974",
                      "975",
                      "976",
                      "977",
                      "98",
                      "992",
                      "993",
                      "994",
                      "995",
                      "996",
                      "998"
                    ],
                    desc: "a valid country dialing code, i.e. 1 for the US and 44 for the UK"
                  },
                  phone_number: {
                    type: "String",
                    desc: "Phone Number of this phone_number"
                  },
                  default: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Default of this phone_number"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Billing::SubscriptionAddOns::SubscriptionAddOn": {
          name: "subscription_add_ons",
          description: "Returns all subscription_add_ons",
          create_options: [
            {
              required_relationships: [
                "subscription"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              member_count: {
                type: "Integer",
                desc: "Member Count of this subscription_add_on"
              },
              product: {
                type: "Symbol",
                values: [
                  "saas",
                  "studio",
                  "explorer",
                  "nova",
                  "supernova_starter",
                  "supernova_lite",
                  "supernova",
                  "supernova_pro"
                ],
                desc: "saas, studio, explorer, nova, supernova_starter, supernova_lite, supernova or supernova_pro"
              },
              membership: {
                type: "BigDecimal",
                coerce_with: "APICoercions::MoneyToBigDecimal",
                desc: "The price for the first member"
              },
              membership_additional_member_recurring_discount: {
                type: "BigDecimal",
                coerce_with: "APICoercions::MoneyToBigDecimal",
                desc: "The discount which will be applied to each additional member"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a subscription_add_on",
              get: true
            },
            {
              name: "id",
              description: "Update a subscription_add_on",
              update_params: {
                requires: {},
                optional: {
                  member_count: {
                    type: "Integer",
                    desc: "Member Count of this subscription_add_on"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Products::TradingCard": {
          name: "trading_cards",
          description: "Returns all trading_cards",
          create_options: [
            {
              publishable: true,
              required_relationships: [
                "library_object"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              code: {
                type: "String",
                desc: "Unlock code for this object"
              },
              changelog: {
                type: "String",
                desc: "Changelog of this trading_card"
              },
              front: {
                type: "String",
                desc: "Image which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              },
              back: {
                type: "String",
                desc: "Image which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a trading_card",
              get: true
            },
            {
              name: "id",
              description: "Update a products_trading_card",
              update_options: [
                {
                  publishable: true,
                  deletable: true,
                  optional_relationships: [
                    "library_object"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  changelog: {
                    type: "String",
                    desc: "Changelog of this trading_card"
                  },
                  front: {
                    type: "String",
                    desc: "Image which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  },
                  back: {
                    type: "String",
                    desc: "Image which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a trading_card",
              delete: true
            }
          ]
        },
        "Curriculum::MissionAchievement": {
          name: "mission_achievements",
          description: "Returns all mission_achievements",
          create_options: [
            {
              completable: true,
              failable: true,
              submittable: true,
              optional_relationships: [
                "user",
                "project"
              ],
              required_relationships: [
                "mission"
              ]
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a mission_achievement",
              get: true
            },
            {
              name: "id",
              description: "Update a mission_achievement",
              update_options: [
                {
                  completable: true,
                  failable: true,
                  submittable: true,
                  optional_relationships: [
                    "mission_step"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  step_changes: {
                    type: "Hash",
                    desc: "JSON representation of the code changes made for each step"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Curriculum::BadgeCondition": {
          name: "badge_conditions",
          description: "Returns all badge_conditions",
          create_options: [
            {
              optional_relationships: [
                "badge_condition"
              ],
              required_relationships: [
                "badge"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              comparator: {
                type: "Symbol",
                values: [
                  "and",
                  "or"
                ],
                desc: "and and or"
              },
              single_project: {
                type: "Virtus::Attribute::Boolean",
                desc: "do all conditions and activities under this condition have to exist at a single project"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a badge_condition",
              get: true
            },
            {
              name: "id",
              description: "Update a badge_condition",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "badge_condition"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  comparator: {
                    type: "Symbol",
                    values: [
                      "and",
                      "or"
                    ],
                    desc: "and and or"
                  },
                  single_project: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "do all conditions and activities under this condition have to exist at a single project"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a badge_condition",
              delete: true
            },
            {
              name: "id",
              resources: {
                badge_conditions: {
                  name: "badge_conditions",
                  description: "List of badge_conditions for this badge_condition",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                badge_comparables: {
                  name: "badge_comparables",
                  description: "List of badge_comparables for this badge_condition",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Curriculum::BadgeComparable": {
          name: "badge_comparables",
          description: "Returns all badge_comparables",
          create_options: [
            {
              required_relationships: [
                "badge_condition",
                "curriculum_activity"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              count: {
                type: "Integer",
                desc: "Number of this activity which is required"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a badge_comparable",
              get: true
            },
            {
              name: "id",
              description: "Update a badge_comparable",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  count: {
                    type: "Integer",
                    desc: "Number of this activity which is required"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a badge_comparable",
              delete: true
            }
          ]
        },
        "Curriculum::Rank": {
          name: "ranks",
          description: "Returns all ranks",
          create_params: {
            requires: {
              name: {
                type: "String",
                allow_blank: false,
                desc: "Name of this rank"
              },
              minutes: {
                type: "Integer",
                allow_blank: false,
                desc: "Amount of time this should take"
              },
              difficulty_level: {
                type: "Symbol",
                allow_blank: false,
                values: [
                  "beginner",
                  "intermediate",
                  "advanced",
                  "expert",
                  "pro"
                ],
                desc: "beginner, intermediate, advanced, expert or pro"
              }
            },
            optional: {
              position: {
                type: "Integer",
                desc: "Position of this rank"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a rank",
              get: true
            },
            {
              name: "id",
              description: "Update a rank",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this rank"
                  },
                  position: {
                    type: "Integer",
                    desc: "Position of this rank"
                  },
                  minutes: {
                    type: "Integer",
                    allow_blank: false,
                    desc: "Amount of time this should take"
                  },
                  difficulty_level: {
                    type: "Symbol",
                    allow_blank: false,
                    values: [
                      "beginner",
                      "intermediate",
                      "advanced",
                      "expert",
                      "pro"
                    ],
                    desc: "beginner, intermediate, advanced, expert or pro"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a rank",
              delete: true
            },
            {
              name: "id",
              resources: {
                rank_learning_path_levels: {
                  name: "rank_learning_path_levels",
                  description: "List of rank_learning_path_levels for this rank",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Curriculum::RankLearningPathLevel": {
          name: "rank_learning_path_levels",
          description: "Returns all rank_learning_path_levels",
          create_options: [
            {
              required_relationships: [
                "rank",
                "learning_path_level"
              ]
            }
          ],
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a rank_learning_path_level",
              get: true
            },
            {
              name: "id",
              description: "Update a rank_learning_path_level",
              update_options: [
                {
                  deletable: true
                }
              ],
              put: true
            },
            {
              name: "id",
              description: "Delete a rank_learning_path_level",
              delete: true
            }
          ]
        },
        "Users::Avatar": {
          name: "avatars",
          description: "Returns all avatars",
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this avatar"
              },
              file: {
                type: "String",
                desc: "This photo which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a avatar",
              get: true
            },
            {
              name: "id",
              description: "Update a avatar",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this avatar"
                  },
                  file: {
                    type: "String",
                    desc: "This photo which is base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a avatar",
              delete: true
            }
          ]
        },
        "Curriculum::PointAdjustments::ManualAdjustment": {
          name: "curriculum_point_adjustments",
          description: "Returns all curriculum_point_adjustments",
          create_options: [
            {
              required_relationships: [
                "skill",
                "user"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              description: {
                type: "String",
                desc: "Description of this point_adjustment"
              },
              points: {
                type: "Integer",
                desc: "Points of this point_adjustment"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a point_adjustment",
              get: true
            },
            {
              name: "id",
              description: "Update a curriculum_point_adjustment",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  description: {
                    type: "String",
                    desc: "Description of this point_adjustment"
                  },
                  points: {
                    type: "Integer",
                    desc: "Points of this point_adjustment"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a curriculum_point_adjustment",
              delete: true
            }
          ]
        },
        "Curriculum::MissionSteps::MissionStep": {
          name: "mission_steps",
          description: "Returns all mission_steps",
          create_options: [
            {
              required_relationships: [
                "mission"
              ]
            }
          ],
          create_params: {
            requires: {
              boilerplate: {
                type: "Symbol",
                values: [
                  "info",
                  "code",
                  "quiz"
                ],
                desc: "code, info, write, checkpoint, object_importer, example, insert, submit, video, quiz, audio or image"
              },
              skippable: {
                type: "Virtus::Attribute::Boolean",
                desc: "If true, then this step can be skipped"
              },
              fullscreen: {
                type: "Virtus::Attribute::Boolean",
                desc: "If true, then this step takes up the whole ide view"
              }
            },
            optional: {
              display: {
                type: "Symbol",
                values: [
                  "modal",
                  "line",
                  "canvas",
                  "fixed",
                  "fullscreen"
                ],
                desc: "modal, line, canvas, fixed or fullscreen"
              },
              position: {
                type: "Integer",
                desc: "The sort order for steps within each difficulty."
              },
              header: {
                type: "String",
                desc: "A small header which is required for all step types except step."
              },
              content: {
                type: "String",
                desc: "The primary content for this step which is a block of markdown which can also contain symbols such as %RUN% for our run button or %HillFriend% for objects."
              },
              body: {
                type: "String",
                desc: "A long form block of markdown"
              },
              detail: {
                type: "String",
                desc: "A long form block of markdown"
              },
              side_bar_header: {
                type: "String",
                desc: "A long form block of markdown"
              },
              runnable: {
                type: "Virtus::Attribute::Boolean",
                desc: "Should the step have a run button"
              },
              image: {
                type: "String",
                desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
              },
              video_uri: {
                type: "String",
                desc: "video uri for the video step type"
              },
              audio_uri: {
                type: "String",
                desc: "audio uri for the audio step type"
              },
              optional: {
                type: "Virtus::Attribute::Boolean"
              },
              kidscript: {
                type: "String"
              },
              document: {
                type: "Integer"
              },
              target_kidscript_after: {
                type: "String"
              },
              target_kidscript_before: {
                type: "String"
              },
              button_type: {
                type: "String",
                values: [
                  "next",
                  "run",
                  "both",
                  "none"
                ],
                desc: "If set to 'run' then the primary button for the step will run the current KidScript and moving to the next step will occur when an event matching the validation rules is detected. This is required for Info or Write steps."
              },
              success_header: {
                type: "String",
                desc: "An optional header which can be displayed after completing either a Code or Write step."
              },
              success_message: {
                type: "String",
                desc: "An optional block of content, represented in markdown which can be displayed after completing either a Code or Write step."
              },
              kidscript_head: {
                type: "String",
                desc: "KidScript which will be placed into the Stage.KS tab. If not provided, then the previous steps KidScript will be used. If the first Step does not declare KidScript then the value from the Difficulty will be used."
              },
              kidscript_head_strategy: {
                type: "String",
                values: [
                  "append",
                  "prepend",
                  "inherit",
                  "replace"
                ],
                desc: "How should the client treat the KidScript in this step with respect to the KidScript in the previous step. Either 'append' to add this KidScript to the end of the previous step, 'prepend' to add it before the previous steps KidScript, 'inherit' to ignore KidScript in this step and use the previous steps KidScript or 'replace' to replace the previous steps KidScript."
              },
              kidscript_body: {
                type: "String",
                desc: "KidScript which will be placed into the Main.KS tab. If not provided, then the previous steps KidScript will be used. If the first Step does not declare KidScript then the value from the Difficulty will be used."
              },
              kidscript_body_strategy: {
                type: "String",
                values: [
                  "append",
                  "prepend",
                  "inherit",
                  "replace"
                ],
                desc: "How should the client treat the KidScript in this step with respect to the KidScript in the previous step. Either 'append' to add this KidScript to the end of the previous step, 'prepend' to add it before the previous steps KidScript, 'inherit' to ignore KidScript in this step and use the previous steps KidScript or 'replace' to replace the previous steps KidScript."
              },
              highlight: {
                type: "Hash",
                desc: "Instructions to the Editor to highlight lines or symbols"
              },
              editable_symbols: {
                type: "Hash",
                desc: "the Editable Symbols feature will lock the editor in a way which allows only specific symbols to be edited"
              },
              type_over: {
                type: "Hash",
                desc: "the Editable Symbols feature will lock the editor in a way which allows only specific symbols to be edited"
              },
              kidscript_changes: {
                type: "Hash",
                description: "Instructions to the Editor to modify the current kidscript"
              },
              line_address: {
                type: "Hash",
                description: "The line "
              },
              symbol_address: {
                type: "Hash",
                description: "The symbol"
              },
              library: {
                type: "Hash",
                desc: "the objects, colors and other library items which can be used within code editing on this step"
              },
              validation_target: {
                type: "Symbol",
                values: [
                  "kidscript",
                  "interpreter",
                  "editor"
                ],
                desc: "null, kidscript, interpreter or editor"
              },
              validation_rules: {
                type: "Hash",
                desc: "Validation Rules for autompletion of this step, uses JSON Logic"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a mission_step",
              get: true
            },
            {
              name: "id",
              description: "Update a mission_step",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "mission"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  boilerplate: {
                    type: "Symbol",
                    values: [
                      "info",
                      "code",
                      "quiz"
                    ],
                    desc: "code, info, write, checkpoint, object_importer, example, insert, submit, video, quiz, audio or image"
                  },
                  display: {
                    type: "Symbol",
                    values: [
                      "modal",
                      "line",
                      "canvas",
                      "fixed",
                      "fullscreen"
                    ],
                    desc: "modal, line, canvas, fixed or fullscreen"
                  },
                  position: {
                    type: "Integer",
                    desc: "The sort order for steps within each tutorial."
                  },
                  header: {
                    type: "String",
                    desc: "A small header which is required for all step types except step."
                  },
                  content: {
                    type: "String",
                    desc: "The primary content for this step which is a block of markdown which can also contain symbols such as %RUN% for our run button or %HillFriend% for objects."
                  },
                  body: {
                    type: "String",
                    desc: "A long form block of markdown"
                  },
                  detail: {
                    type: "String",
                    desc: "A long form block of markdown"
                  },
                  runnable: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Should the step have a run button"
                  },
                  side_bar_header: {
                    type: "String",
                    desc: "A long form block of markdown"
                  },
                  image: {
                    type: "String",
                    desc: "An image, should be sent base64 encoded in Data URI format such as \"data:image/png;base64,iVBORw0KGgo...\""
                  },
                  video_uri: {
                    type: "String",
                    desc: "video uri for the video step type"
                  },
                  audio_uri: {
                    type: "String",
                    desc: "audio uri for the audio step type"
                  },
                  optional: {
                    type: "Virtus::Attribute::Boolean"
                  },
                  kidscript: {
                    type: "String"
                  },
                  document: {
                    type: "Integer"
                  },
                  target_kidscript_after: {
                    type: "String"
                  },
                  target_kidscript_before: {
                    type: "String"
                  },
                  button_type: {
                    type: "String",
                    values: [
                      "next",
                      "run",
                      "both",
                      "none"
                    ],
                    desc: "If set to 'run' then the primary button for the step will run the current KidScript and moving to the next step will occur when an event matching the validation rules is detected. This is required for Info or Write steps."
                  },
                  skippable: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "If true, then this step can be skipped"
                  },
                  fullscreen: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "If true, then this step takes up the whole ide view"
                  },
                  success_header: {
                    type: "String",
                    desc: "An optional header which can be displayed after completing either a Code or Write step."
                  },
                  success_message: {
                    type: "String",
                    desc: "An optional block of content, represented in markdown which can be displayed after completing either a Code or Write step."
                  },
                  kidscript_head: {
                    type: "String",
                    desc: "KidScript which will be placed into the Stage.KS tab. If not provided, then the previous steps KidScript will be used. If the first Step does not declare KidScript then the value from the Difficulty will be used."
                  },
                  kidscript_head_strategy: {
                    type: "String",
                    values: [
                      "append",
                      "prepend",
                      "inherit",
                      "replace"
                    ],
                    desc: "How should the client treat the KidScript in this step with respect to the KidScript in the previous step. Either 'append' to add this KidScript to the end of the previous step, 'prepend' to add it before the previous steps KidScript, 'inherit' to ignore KidScript in this step and use the previous steps KidScript or 'replace' to replace the previous steps KidScript."
                  },
                  kidscript_body: {
                    type: "String",
                    desc: "KidScript which will be placed into the Main.KS tab. If not provided, then the previous steps KidScript will be used. If the first Step does not declare KidScript then the value from the Difficulty will be used."
                  },
                  kidscript_body_strategy: {
                    type: "String",
                    values: [
                      "append",
                      "prepend",
                      "inherit",
                      "replace"
                    ],
                    desc: "How should the client treat the KidScript in this step with respect to the KidScript in the previous step. Either 'append' to add this KidScript to the end of the previous step, 'prepend' to add it before the previous steps KidScript, 'inherit' to ignore KidScript in this step and use the previous steps KidScript or 'replace' to replace the previous steps KidScript."
                  },
                  highlight: {
                    type: "Hash",
                    description: "Instructions to the Editor to highlight lines or symbols"
                  },
                  editable_symbols: {
                    type: "Hash",
                    description: "the Editable Symbols feature will lock the editor in a way which allows only specific symbols to be edited"
                  },
                  type_over: {
                    type: "Hash",
                    description: "the Editable Symbols feature will lock the editor in a way which allows only specific symbols to be edited"
                  },
                  kidscript_changes: {
                    type: "Hash",
                    description: "Instructions to the Editor to modify the current kidscript"
                  },
                  line_address: {
                    type: "Hash",
                    description: "The line"
                  },
                  symbol_address: {
                    type: "Hash",
                    description: "The symbol"
                  },
                  library: {
                    type: "Hash",
                    desc: "the objects, colors and other library items which can be used within code editing on this step"
                  },
                  validation_target: {
                    type: "Symbol",
                    values: [
                      "kidscript",
                      "interpreter",
                      "editor"
                    ],
                    desc: "null, kidscript, interpreter or editor"
                  },
                  validation_rules: {
                    type: "Hash",
                    desc: "Validation Rules for autompletion of this step, uses JSON Logic"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a mission_step",
              delete: true
            },
            {
              name: "id",
              resources: {
                mission_step_tips: {
                  name: "mission_step_tips",
                  description: "List of mission_step_tips for this mission",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                mission_step_insertables: {
                  name: "mission_step_insertables",
                  description: "List of mission_step_insertables for this mission",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                multiple_choices: {
                  name: "multiple_choices",
                  description: "List of multiple_choices for this mission",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Curriculum::MissionStepActivity": {
          name: "mission_step_activities",
          description: "Returns all mission_step_activities",
          create_options: [
            {
              required_relationships: [
                "mission_step",
                "curriculum_activity"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a mission_step_activity",
              get: true
            },
            {
              name: "id",
              description: "Update a mission_step_activity",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "mission_step",
                    "activity"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {}
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a mission_step_activity",
              delete: true
            }
          ]
        },
        "Projects::Category": {
          name: "project_categories",
          description: "Returns all project_categories",
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this category"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a category",
              get: true
            },
            {
              name: "id",
              description: "Update a project_category",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this category"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a project_category",
              delete: true
            }
          ]
        },
        "Curriculum::SkillLevel": {
          name: "skill_levels",
          description: "Returns all skill_levels",
          create_options: [
            {
              required_relationships: [
                "skill"
              ]
            }
          ],
          create_params: {
            requires: {
              minutes: {
                type: "Integer",
                allow_blank: false,
                desc: "Amount of time this should take"
              },
              difficulty_level: {
                type: "Symbol",
                allow_blank: false,
                values: [
                  "beginner",
                  "intermediate",
                  "advanced",
                  "expert",
                  "pro"
                ],
                desc: "beginner, intermediate, advanced, expert or pro"
              }
            },
            optional: {
              position: {
                type: "Integer",
                desc: "Position of this learning_path_level"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              learning_path_id: {
                type: "String",
                desc: "get skills levels for a learning path"
              },
              q: {
                type: "String",
                desc: "search the missions by name"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a skill_level",
              get: true
            },
            {
              name: "id",
              description: "Update a skill_level",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "skill"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  minutes: {
                    type: "Integer",
                    allow_blank: false,
                    desc: "Amount of time this should take"
                  },
                  difficulty_level: {
                    type: "Symbol",
                    allow_blank: false,
                    values: [
                      "beginner",
                      "intermediate",
                      "advanced",
                      "expert",
                      "pro"
                    ],
                    desc: "beginner, intermediate, advanced, expert or pro"
                  },
                  position: {
                    type: "Integer",
                    desc: "Position of this learning_path_level"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a skill_level",
              delete: true
            }
          ]
        },
        "Curriculum::LearningPathLevelSkillLevel": {
          name: "learning_path_level_skill_levels",
          description: "Returns all learning_path_level_skill_levels",
          create_options: [
            {
              required_relationships: [
                "learning_path_level",
                "skill_level"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a learning_path_level_skill_level",
              get: true
            },
            {
              name: "id",
              description: "Update a learning_path_level_skill_level",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "learning_path_level",
                    "skill_level"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {}
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a learning_path_level_skill_level",
              delete: true
            }
          ]
        },
        "Projects::LaunchedApp": {
          name: "launched_apps",
          description: "Returns all launched_apps",
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search apps by name or username"
              },
              category_id: {
                type: "String",
                desc: "search apps by category"
              }
            }
          },
          get: true,
          paginate_params: true,
          sort_by_param: [
            "play_count",
            "created_at"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a launched_app",
              get: true
            }
          ]
        },
        "Staff::Team": {
          name: "staff_teams",
          description: "Returns all staff_teams",
          create_options: [
            {
              required_relationships: [
                {
                  name: "leader",
                  as: "user"
                }
              ],
              optional_relationships: [
                "location"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              name: {
                type: "String",
                desc: "Name of this team"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search the teams"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "name"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a team",
              get: true
            },
            {
              name: "id",
              description: "Update a staff_team",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "location",
                    {
                      name: "leader",
                      as: "user"
                    }
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this team"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a staff_team",
              delete: true
            },
            {
              name: "id",
              resources: {
                staff_team_memberships: {
                  name: "staff_team_memberships",
                  description: "List of team_memberships for this team",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Staff::TeamMembership": {
          name: "staff_team_memberships",
          description: "Returns all staff_team_memberships",
          create_options: [
            {
              required_relationships: [
                "staff_team",
                "user"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              title: {
                type: "String",
                desc: "This persons title"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a team_membership",
              get: true
            },
            {
              name: "id",
              description: "Update a staff_team_membership",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "staff_team",
                    "user"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  title: {
                    type: "String",
                    desc: "Title of this team_membership"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a staff_team_membership",
              delete: true
            }
          ]
        },
        "Projects::VersionPlay": {
          name: "version_plays",
          description: "Create a version_play",
          create_options: [
            {
              required_relationships: [
                "public_session",
                "version"
              ]
            }
          ],
          post: true
        },
        "Curriculum::MissionStepTip": {
          name: "mission_step_tips",
          description: "Returns all mission_step_tips",
          create_options: [
            {
              required_relationships: [
                "mission_step"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              icon: {
                type: "String",
                desc: "Icon of this mission_step_tip"
              },
              content: {
                type: "String",
                desc: "Content of this mission_step_tip"
              },
              line: {
                type: "Integer",
                desc: "Line of this mission_step_tip"
              },
              position: {
                type: "Integer",
                desc: "Position of this mission_step_tip"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a mission_step_tip",
              get: true
            },
            {
              name: "id",
              description: "Update a mission_step_tip",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "mission_step"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  icon: {
                    type: "String",
                    desc: "Icon of this mission_step_tip"
                  },
                  content: {
                    type: "String",
                    desc: "Content of this mission_step_tip"
                  },
                  line: {
                    type: "Integer",
                    desc: "Line of this mission_step_tip"
                  },
                  position: {
                    type: "Integer",
                    desc: "Position of this mission_step_tip"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a mission_step_tip",
              delete: true
            }
          ]
        },
        "Curriculum::MissionStepInsertable": {
          name: "mission_step_insertables",
          description: "Returns all mission_step_insertables",
          create_options: [
            {
              required_relationships: [
                "mission_step"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              object: {
                type: "String",
                desc: "Object of this mission_step_insertable"
              },
              kidscript: {
                type: "String",
                desc: "Kidscript of this mission_step_insertable"
              },
              position: {
                type: "Integer",
                desc: "Position of this mission_step_insertable"
              },
              display: {
                type: "Symbol",
                values: [
                  "object",
                  "snippet"
                ],
                desc: "object and snippet"
              },
              x: {
                type: "Integer",
                desc: "X position for mission_step_insertable object type"
              },
              y: {
                type: "Integer",
                desc: "Y position for mission_step_insertable object type"
              },
              line_address: {
                type: "Hash",
                description: "The line"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a mission_step_insertable",
              get: true
            },
            {
              name: "id",
              description: "Update a mission_step_insertable",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "mission_step"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  object: {
                    type: "String",
                    desc: "Object of this mission_step_insertable"
                  },
                  kidscript: {
                    type: "String",
                    desc: "Kidscript of this mission_step_insertable"
                  },
                  position: {
                    type: "Integer",
                    desc: "Position of this mission_step_insertable"
                  },
                  display: {
                    type: "Symbol",
                    values: [
                      "object",
                      "snippet"
                    ],
                    desc: "object and snippet"
                  },
                  x: {
                    type: "Integer",
                    desc: "X position for mission_step_insertable object type"
                  },
                  y: {
                    type: "Integer",
                    desc: "Y position for mission_step_insertable object type"
                  },
                  line_address: {
                    type: "Hash",
                    description: "The line"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a mission_step_insertable",
              delete: true
            }
          ]
        },
        "Communication::Meeting": {
          name: "meetings",
          description: "Returns all meetings",
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a meeting",
              get: true
            },
            {
              name: "id",
              description: "Update a meeting",
              update_params: {
                requires: {},
                optional: {
                  status: {
                    type: "Symbol",
                    values: [
                      "new",
                      "opened",
                      "started",
                      "ended",
                      "no_show",
                      "abandoned",
                      "children_abandoned",
                      "children_no_show"
                    ],
                    desc: "set to opened to open the meeting and wait up to 5 minutes for someone to join"
                  },
                  sentiment: {
                    type: "Symbol",
                    values: [
                      "very_sad",
                      "sad",
                      "neutral",
                      "happy",
                      "very_happy"
                    ],
                    desc: "null, very_sad, sad, neutral, happy or very_happy"
                  },
                  kid_concerns: {
                    type: "Virtus::Attribute::Boolean"
                  },
                  technology_issues: {
                    type: "Virtus::Attribute::Boolean"
                  },
                  parent_concerns: {
                    type: "Virtus::Attribute::Boolean"
                  },
                  other_concerns: {
                    type: "String"
                  },
                  technology_logging_in_issues: {
                    type: "Virtus::Attribute::Boolean"
                  },
                  technology_audio_video_issues: {
                    type: "Virtus::Attribute::Boolean"
                  },
                  technology_code_ide_issues: {
                    type: "Virtus::Attribute::Boolean"
                  },
                  other_issues: {
                    type: "String"
                  },
                  comments: {
                    type: "String"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                participations: {
                  name: "participations",
                  description: "List of participations for this meeting",
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Communication::Participations::Participation": {
          name: "participations",
          description: "Returns all participations",
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a participation",
              get: true
            },
            {
              name: "id",
              description: "Update a participation",
              update_params: {
                requires: {},
                optional: {
                  comments: {
                    type: "String",
                    desc: "Comments on this session"
                  },
                  sentiment: {
                    type: "Symbol",
                    values: [
                      "very_sad",
                      "sad",
                      "neutral",
                      "happy",
                      "very_happy"
                    ],
                    desc: "null, very_sad, sad, neutral, happy or very_happy"
                  },
                  parent_sentiment: {
                    type: "Symbol",
                    values: [
                      "very_sad",
                      "sad",
                      "neutral",
                      "happy",
                      "very_happy"
                    ],
                    desc: "null, very_sad, sad, neutral, happy or very_happy"
                  },
                  parent_keep_guide: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "parent survey field"
                  },
                  parent_make_guide_most_preferred: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "parent survey field"
                  },
                  parent_learning_concerns: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "parent survey field"
                  },
                  parent_technology_issues: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "parent survey field"
                  },
                  parent_guide_concerns: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "parent survey field"
                  },
                  parent_technology_logging_in_issues: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "parent survey field"
                  },
                  parent_technology_audio_video_issues: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "parent survey field"
                  },
                  parent_technology_code_ide_issues: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "parent survey field"
                  },
                  parent_other_concerns: {
                    type: "String",
                    desc: "parent survey field"
                  },
                  parent_other_issues: {
                    type: "String",
                    desc: "parent survey field"
                  },
                  parent_next_session_comments: {
                    type: "String",
                    desc: "parent survey field"
                  },
                  parent_experience_comments: {
                    type: "String",
                    desc: "parent survey field"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Guides::Schedulable": {
          name: "guide_schedulables",
          description: "Returns all guide_schedulables",
          create_options: [
            {
              required_relationships: [
                "user",
                "occasion"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a schedulable",
              get: true
            },
            {
              name: "id",
              description: "Update a guides_schedulable",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {}
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a guides_schedulable",
              delete: true
            }
          ]
        },
        "Guides::AvailabilityInstance": {
          name: "guide_availability_instances",
          description: "Returns all guide_availability_instances",
          filter_params: {
            requires: {},
            optional: {
              after: {
                type: "Date",
                desc: "filter by date"
              },
              before: {
                type: "Date",
                desc: "filter by date"
              },
              start_hour: {
                type: "Integer",
                desc: "the hour of the day that the availability instance starts"
              },
              start_minute: {
                type: "Integer",
                desc: "the minute of the day that the availability instance starts"
              },
              end_hour: {
                type: "Integer",
                desc: "the hour of the day that the availability instance ends"
              },
              end_minute: {
                type: "Integer",
                desc: "the minute of the day that the availability instance ends"
              },
              location_id: {
                type: "UUID"
              },
              location_ids: {
                type: "Array"
              },
              slot_instance_id: {
                type: "UUID"
              },
              slot_instance_ids: {
                type: "Array"
              },
              user_id: {
                type: "UUID"
              },
              user_ids: {
                type: "Array"
              },
              occasion_id: {
                type: "UUID"
              },
              occasion_ids: {
                type: "Array"
              },
              hide_full: {
                type: "Virtus::Attribute::Boolean",
                desc: "hide availability instances with no capacity"
              },
              hide_blocked: {
                type: "Virtus::Attribute::Boolean",
                desc: "hide availability instances that are blocked"
              }
            }
          },
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true
        },
        "Guides::Availability": {
          name: "guide_availabilities",
          description: "Returns all guide_availabilities",
          create_options: [
            {
              optional_relationships: [
                "location"
              ],
              required_relationships: [
                "user",
                "occasion"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              start_hour: {
                type: "Integer",
                desc: "Start Hour of this availability"
              },
              start_minute: {
                type: "Integer",
                desc: "Start Minute of this availability"
              },
              end_hour: {
                type: "Integer",
                desc: "End Hour of this availability"
              },
              end_minute: {
                type: "Integer",
                desc: "End Minute of this availability"
              },
              first_available_at: {
                type: "Date",
                desc: "First Available At of this availability"
              },
              last_available_at: {
                type: "Date",
                desc: "Last Available At of this availability"
              },
              excluded_dates: {
                type: "Array",
                desc: "An array of dates where this availability will not be available"
              },
              disabled: {
                type: "Virtus::Attribute::Boolean",
                desc: "Disabled of this availability",
                default: false
              },
              accept_codeverse_customers: {
                type: "Virtus::Attribute::Boolean",
                desc: "Accept Codeverse Customers of this availability",
                default: true
              },
              time_zone: {
                type: "String",
                desc: "This locations time zone, i.e. America/Chicago",
                default: "America/Chicago"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              ids: {
                type: "Array"
              },
              user_id: {
                uuid: true
              },
              user_ids: {
                type: "Array"
              },
              location_id: {
                uuid: true
              },
              location_ids: {
                type: "Array"
              },
              occasion_id: {
                uuid: true
              },
              occasion_ids: {
                type: "Array"
              },
              date: {
                type: "Date",
                desc: "the date of a hypothetical booking"
              },
              start_hour: {
                type: "Integer",
                desc: "the hour of the day that the slot starts"
              },
              start_minute: {
                type: "Integer",
                desc: "the minute of the day that the slot starts"
              },
              end_hour: {
                type: "Integer",
                desc: "the hour of the day that the slot ends"
              },
              end_minute: {
                type: "Integer",
                desc: "the minute of the day that the slot ends"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "first_available_at",
            "last_available_at",
            "start_hour",
            "end_hour"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get an availability",
              get: true
            },
            {
              name: "id",
              description: "Update a guides_availability",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  last_available_at: {
                    type: "Date",
                    desc: "Last Available At of this availability"
                  },
                  excluded_dates: {
                    type: "Array",
                    desc: "An array of dates where this availability will not be available"
                  },
                  disabled: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Disabled of this availability"
                  },
                  accept_codeverse_customers: {
                    type: "Virtus::Attribute::Boolean",
                    desc: "Accept Codeverse Customers of this availability"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a guides_availability",
              delete: true
            }
          ]
        },
        "Guides::Preference": {
          name: "guide_preferences",
          description: "Returns all guide_preferences",
          create_options: [
            {
              required_relationships: [
                "user",
                {
                  name: "guide",
                  as: "user"
                }
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              position: {
                type: "Integer",
                desc: "Position of this guide_preference"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a guide_preference",
              get: true
            },
            {
              name: "id",
              description: "Update a guide_preference",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  position: {
                    type: "Integer",
                    desc: "Position of this guide_preference"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a guide_preference",
              delete: true
            }
          ]
        },
        "Guides::Block": {
          name: "guide_blocks",
          description: "Returns all guide_blocks",
          create_options: [
            {
              required_relationships: [
                "user",
                {
                  name: "guide",
                  as: "user"
                }
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a guide_block",
              get: true
            },
            {
              name: "id",
              description: "Update a guide_block",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {}
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a guide_block",
              delete: true
            }
          ]
        },
        "Guides::Rating": {
          name: "guide_ratings",
          description: "Returns all guide_ratings",
          create_options: [
            {
              required_relationships: [
                "user"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              stars: {
                type: "BigDecimal",
                desc: "Stars of this rating"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a rating",
              get: true
            },
            {
              name: "id",
              description: "Update a guides_rating",
              update_params: {
                requires: {},
                optional: {
                  stars: {
                    type: "BigDecimal",
                    desc: "Stars of this rating"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Guides::Profile": {
          name: "guide_profiles",
          description: "Returns all guide_profiles",
          create_options: [
            {
              publishable: true,
              optional_relationships: [
                "user"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              video_uri: {
                type: "String",
                desc: "Video Uri for this guides profile"
              },
              headline: {
                type: "String",
                desc: "Written headline for this profile"
              },
              bio: {
                type: "String",
                desc: "Written Bio for this profile"
              },
              instagram: {
                type: "String",
                desc: "Username for this guides instagram profile"
              },
              twitter: {
                type: "String",
                desc: "Username for this guides twitter profile"
              },
              linkedin: {
                type: "String",
                desc: "Username for this guides linkedin profile"
              },
              facebook: {
                type: "String",
                desc: "Username for this guides facebook profile"
              },
              github: {
                type: "String",
                desc: "Username for this guides github profile"
              },
              stackoverflow: {
                type: "String",
                desc: "Username for this guides stackoverflow profile"
              },
              youtube: {
                type: "String",
                desc: "Username for this guides youtube profile"
              },
              pinterest: {
                type: "String",
                desc: "Username for this guides pinterest profile"
              },
              twitch: {
                type: "String",
                desc: "Username for this guides twitch profile"
              },
              homepage: {
                type: "String",
                desc: "URL to this guides hompeage"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a profile",
              get: true
            },
            {
              name: "id",
              description: "Update a guides_profile",
              update_options: [
                {
                  publishable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  video_uri: {
                    type: "String",
                    desc: "Video Uri for this guides profile"
                  },
                  headline: {
                    type: "String",
                    desc: "Written headline for this profile"
                  },
                  bio: {
                    type: "String",
                    desc: "Written Bio for this profile"
                  },
                  instagram: {
                    type: "String",
                    desc: "Username for this guides instagram profile"
                  },
                  twitter: {
                    type: "String",
                    desc: "Username for this guides twitter profile"
                  },
                  linkedin: {
                    type: "String",
                    desc: "Username for this guides linkedin profile"
                  },
                  facebook: {
                    type: "String",
                    desc: "Username for this guides facebook profile"
                  },
                  github: {
                    type: "String",
                    desc: "Username for this guides github profile"
                  },
                  stackoverflow: {
                    type: "String",
                    desc: "Username for this guides stackoverflow profile"
                  },
                  youtube: {
                    type: "String",
                    desc: "Username for this guides youtube profile"
                  },
                  pinterest: {
                    type: "String",
                    desc: "Username for this guides pinterest profile"
                  },
                  twitch: {
                    type: "String",
                    desc: "Username for this guides twitch profile"
                  },
                  homepage: {
                    type: "String",
                    desc: "URL to this guides hompeage"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Curriculum::MultipleChoice": {
          name: "multiple_choices",
          description: "Returns all multiple_choices",
          create_options: [
            {
              required_relationships: [
                "mission_step"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              question: {
                type: "String",
                desc: "Question"
              },
              answer_a: {
                type: "String",
                desc: "Answer A"
              },
              answer_b: {
                type: "String",
                desc: "Answer B"
              },
              answer_c: {
                type: "String",
                desc: "Answer C"
              },
              answer_d: {
                type: "String",
                desc: "Answer D"
              },
              position: {
                type: "Integer",
                desc: "Position of this multiple_choice"
              },
              answer: {
                type: "Symbol",
                values: [
                  "a",
                  "b",
                  "c",
                  "d"
                ],
                desc: "a, b, c or d"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a multiple_choice",
              get: true
            },
            {
              name: "id",
              description: "Update a multiple_choice",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    "mission_step"
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  question: {
                    type: "String",
                    desc: "Question"
                  },
                  answer_a: {
                    type: "String",
                    desc: "Answer A"
                  },
                  answer_b: {
                    type: "String",
                    desc: "Answer B"
                  },
                  answer_c: {
                    type: "String",
                    desc: "Answer C"
                  },
                  answer_d: {
                    type: "String",
                    desc: "Answer D"
                  },
                  position: {
                    type: "Integer",
                    desc: "Position"
                  },
                  answer: {
                    type: "Symbol",
                    values: [
                      "a",
                      "b",
                      "c",
                      "d"
                    ],
                    desc: "a, b, c or d"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a multiple_choice",
              delete: true
            }
          ]
        },
        "Curriculum::MultipleChoiceAnswer": {
          name: "multiple_choice_answers",
          description: "Returns all multiple_choice_answers",
          create_options: [
            {
              required_relationships: [
                "multiple_choice"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              answer: {
                type: "Symbol",
                values: [
                  "a",
                  "b",
                  "c",
                  "d"
                ],
                desc: "a, b, c or d"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a multiple_choice_answer",
              get: true
            }
          ]
        },
        "Curriculum::GuideRank": {
          name: "guide_ranks",
          description: "Returns all guide_ranks",
          create_params: {
            requires: {
              minutes: {
                type: "Integer",
                allow_blank: false,
                desc: "Amount of time this should take"
              },
              difficulty_level: {
                type: "Symbol",
                allow_blank: false,
                values: [
                  "beginner",
                  "intermediate",
                  "advanced",
                  "expert",
                  "pro"
                ],
                desc: "beginner, intermediate, advanced, expert or pro"
              }
            },
            optional: {
              name: {
                type: "String",
                desc: "Name of this guide_rank"
              },
              position: {
                type: "Integer",
                desc: "Position of this guide_rank"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a guide_rank",
              get: true
            },
            {
              name: "id",
              description: "Update a guide_rank",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this guide_rank"
                  },
                  position: {
                    type: "Integer",
                    desc: "Position of this guide_rank"
                  },
                  minutes: {
                    type: "Integer",
                    allow_blank: false,
                    desc: "Amount of time this should take"
                  },
                  difficulty_level: {
                    type: "Symbol",
                    allow_blank: false,
                    values: [
                      "beginner",
                      "intermediate",
                      "advanced",
                      "expert",
                      "pro"
                    ],
                    desc: "beginner, intermediate, advanced, expert or pro"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a guide_rank",
              delete: true
            },
            {
              name: "id",
              resources: {
                guide_rank_learning_path_levels: {
                  name: "guide_rank_learning_path_levels",
                  description: "List of guide_rank_learning_path_levels for this guide_rank",
                  filter_options: [
                    {
                      deletable: true
                    }
                  ],
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Curriculum::GuideRankLearningPathLevel": {
          name: "guide_rank_learning_path_levels",
          description: "Returns all guide_rank_learning_path_levels",
          create_options: [
            {
              required_relationships: [
                "guide_rank",
                "learning_path_level"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a guide_rank_learning_path_level",
              get: true
            },
            {
              name: "id",
              description: "Update a guide_rank_learning_path_level",
              update_options: [
                {
                  deletable: true
                }
              ],
              put: true
            },
            {
              name: "id",
              description: "Delete a guide_rank_learning_path_level",
              delete: true
            }
          ]
        },
        "Guides::StripeAccount": {
          name: "stripe_accounts",
          description: "Returns all stripe_accounts",
          create_options: [
            {
              optional_relationships: [
                "user"
              ]
            }
          ],
          create_params: {
            requires: {
              oauth_code: {
                type: "String",
                desc: "oauth code, which will be sent to stripe to get the stripe_user_id"
              }
            },
            optional: {}
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a stripe_account",
              get: true
            }
          ]
        },
        "Guides::CheckrAccount": {
          name: "checkr_accounts",
          description: "Returns all checkr_accounts",
          create_options: [
            {
              optional_relationships: [
                "user"
              ]
            }
          ],
          create_params: {
            requires: {
              oauth_code: {
                type: "String",
                desc: "oauth code, which will be sent to checkr to get the checkr_user_id"
              }
            },
            optional: {}
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a checkr_account",
              get: true
            }
          ]
        },
        "Billing::Credits::Credit": {
          name: "credits",
          description: "Returns all credits",
          create_options: [
            {
              required_relationships: [
                "organization"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              source: {
                type: "Symbol",
                values: [
                  "subscription",
                  "promotion",
                  "loyalty",
                  "adjustment",
                  "overage"
                ],
                desc: "subscription, promotion, loyalty, adjustment or overage"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a credit",
              get: true
            },
            {
              name: "id",
              description: "Update a credit",
              update_options: [
                {
                  deletable: true
                }
              ],
              put: true
            },
            {
              name: "id",
              description: "Delete a credit",
              delete: true
            }
          ]
        },
        "Friends::FriendRequest": {
          name: "friend_requests",
          description: "Returns all friend_requests",
          create_options: [
            {
              optional_relationships: [
                "user",
                {
                  name: "friend",
                  as: "user"
                }
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              username: {
                type: "String",
                desc: "If you dont know the members ID then you can find them by username."
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a friend_request",
              get: true
            },
            {
              name: "id",
              description: "Update a friend_request",
              update_options: [
                {
                  acceptable: true,
                  revokable: true,
                  ignorable: true
                }
              ],
              put: true
            }
          ]
        },
        "Friends::Friendship": {
          name: "friendships",
          description: "Returns all friendships",
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a friendship",
              get: true
            },
            {
              name: "id",
              description: "Update a friendship",
              update_params: {
                requires: {},
                optional: {
                  best_friend_position: {
                    type: "Integer",
                    desc: "Position of this friend (used for displaying best friends)"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Opportunities::Assignments::Assignment": {
          name: "assignments",
          description: "Returns all assignments",
          filter_options: [
            {
              resolvable: true,
              cancelable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              q: {
                type: "String",
                desc: "search by string"
              },
              ids: {
                type: "Array"
              },
              assignor_id: {
                type: "UUID"
              },
              owner_id: {
                type: "UUID"
              },
              staff_team_id: {
                type: "UUID"
              },
              due_after: {
                type: "Date",
                desc: "filter by due date"
              },
              due_before: {
                type: "Date",
                desc: "filter by due date"
              },
              topic: {
                type: "Symbol",
                values: [
                  "virtual_classes_lead/phone_call",
                  "virtual_classes_lead/inbound_communication",
                  "virtual_classes_prospect/phone_call",
                  "virtual_classes_prospect/inbound_communication",
                  "influencer_program_lead/phone_call",
                  "influencer_program_lead/inbound_communication",
                  "conversion_stream_follow_up/phone_call",
                  "conversion_stream_follow_up/inbound_communication",
                  "acquisition_stream_follow_up/phone_call",
                  "acquisition_stream_follow_up/inbound_communication",
                  "on_demand_stream_follow_up/phone_call",
                  "on_demand_stream_follow_up/inbound_communication",
                  "collect_learning_styles/phone_call",
                  "collect_learning_styles/inbound_communication",
                  "missed_trial_session/phone_call",
                  "virtual_trial_period/inbound_communication",
                  "virtual_trial_follow_up/phone_call",
                  "canceled_member/account_review",
                  "canceled_member/phone_call",
                  "missed_member_session/phone_call",
                  "past_due_subscription/phone_call",
                  "unhappy_survey/review",
                  "unhappy_survey/escalated_review",
                  "unhappy_survey/phone_call",
                  "unused_credits/phone_call",
                  "guide_certification/training_review",
                  "guide_contractor_agreement_signed/renewal_review",
                  "guide_contractor_agreement_signed/termination_follow_up",
                  "guide_onboarding/training_review",
                  "guide_onboarding/checkout_review",
                  "partner_group_class_follow_up/phone_call",
                  "ussc_virtual_camp_follow_up/phone_call"
                ],
                desc: "the topic"
              },
              topics: {
                type: "Array",
                desc: "array of topics"
              },
              hide_assigned: {
                type: "Virtus::Attribute::Boolean",
                desc: "hide assignments which have been claimed/assigned"
              }
            }
          },
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "due_at",
            "resolved_at",
            "canceled_at",
            "updated_at"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a assignment",
              get: true
            },
            {
              name: "id",
              description: "Update an assignment",
              update_options: [
                {
                  optional_relationships: [
                    {
                      name: "owner",
                      as: "user"
                    }
                  ],
                  resolvable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  resolution: {
                    type: "String",
                    desc: "The event to fire on the opportunity after resolution"
                  },
                  delayed_event: {
                    type: "String",
                    desc: "The delayed event to fire some time after resolution"
                  },
                  delayed_event_at: {
                    type: "Time",
                    desc: "When the delayed event should be fired"
                  },
                  note: {
                    type: "String",
                    desc: "Any notes about the completion of this assignment"
                  },
                  assignor_notes: {
                    type: "String",
                    desc: "Notes to accompany the assignment of this assignment"
                  },
                  claim: {
                    type: "String",
                    desc: "Special shortcut for the current user to assign a task to themselves"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Users::LearningStyle": {
          name: "learning_styles",
          description: "Returns all learning_styles",
          create_options: [
            {
              required_relationships: [
                "user",
                "organization"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              experience: {
                type: "String",
                desc: "Experience of this learning_style"
              },
              styles: {
                type: "String",
                desc: "Styles of this learning_style"
              },
              interests: {
                type: "String",
                desc: "Interests of this learning_style"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a learning_style",
              get: true
            },
            {
              name: "id",
              description: "Update a learning_style",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  experience: {
                    type: "String",
                    desc: "Experience of this learning_style"
                  },
                  styles: {
                    type: "String",
                    desc: "Styles of this learning_style"
                  },
                  interests: {
                    type: "String",
                    desc: "Interests of this learning_style"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a learning_style",
              delete: true
            }
          ]
        },
        "Opportunities::Opportunity": {
          name: "opportunities",
          description: "Returns all opportunities",
          filter_options: [
            {
              completable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              journey: {
                type: "Symbol",
                values: [
                  "virtual_classes_lead",
                  "virtual_classes_prospect",
                  "gift_of_code",
                  "kid_player",
                  "adult_player_high_intent",
                  "adult_player_low_intent",
                  "influencer_program_lead",
                  "collect_learning_styles",
                  "missed_trial_session",
                  "virtual_trial_booked",
                  "virtual_trial_follow_up",
                  "virtual_trial_period",
                  "canceled_member",
                  "missed_member_session",
                  "past_due_subscription",
                  "unhappy_survey",
                  "unused_credits",
                  "guide_certification",
                  "guide_contractor_agreement_signed",
                  "guide_onboarding",
                  "ussc_virtual_camp_booked",
                  "ussc_virtual_camp_follow_up",
                  "partner_group_class_booked",
                  "partner_group_class_follow_up",
                  "conversion_stream_registered",
                  "conversion_stream_follow_up",
                  "acquisition_stream_registered",
                  "acquisition_stream_follow_up",
                  "on_demand_stream_registered",
                  "on_demand_stream_follow_up"
                ],
                desc: "the journey"
              },
              journeys: {
                type: "Array",
                desc: "array of journeys"
              },
              owner_id: {
                type: "UUID"
              },
              staff_team_id: {
                type: "UUID"
              }
            }
          },
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "updated_at",
            "completed_at"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a opportunity",
              get: true
            }
          ]
        },
        "Players::LeaderboardScore": {
          name: "leaderboard_scores",
          description: "Returns all leaderboard_scores",
          create_options: [
            {
              required_relationships: [
                "version"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              score_obfs: {
                type: "String",
                desc: "The users score (which comes in obfuscated, as a weak form of security to prevent kids from trying to cheat and post arbitrary scores)"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a leaderboard_score",
              get: true
            }
          ]
        },
        "Projects::VersionStar": {
          name: "version_stars",
          description: "Returns all version_stars",
          create_options: [
            {
              required_relationships: [
                "version"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a version_star",
              get: true
            },
            {
              name: "id",
              description: "Delete a version_star",
              delete: true
            }
          ]
        },
        "Friends::Following": {
          name: "followings",
          description: "Returns all followings",
          create_options: [
            {
              optional_relationships: [
                {
                  name: "following",
                  as: "user"
                }
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              username: {
                type: "String",
                desc: "username of the person to follow"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a following",
              get: true
            },
            {
              name: "id",
              description: "Delete a following",
              delete: true
            }
          ]
        },
        "Projects::VersionComment": {
          name: "version_comments",
          description: "Returns all version_comments",
          create_options: [
            {
              required_relationships: [
                "version"
              ],
              optional_relationships: [
                {
                  name: "replying_to",
                  as: "version_comment"
                }
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              comment: {
                type: "String",
                desc: "Comment of this version_comment"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a version_comment",
              get: true
            },
            {
              name: "id",
              description: "Update a version_comment",
              update_options: [
                {
                  deletable: true,
                  approveable: true,
                  rejectable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  comment: {
                    type: "String",
                    desc: "Comment of this version_comment"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a version_comment",
              delete: true
            },
            {
              name: "id",
              resources: {
                version_comment_flags: {
                  name: "version_comment_flags",
                  description: "List of version_comment_flags for this version_comment",
                  get: true,
                  paginate_params: true
                }
              }
            },
            {
              name: "id",
              resources: {
                version_comment_emojis: {
                  name: "version_comment_emojis",
                  description: "List of version_comment_emojis for this version_comment",
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Projects::VersionEmoji": {
          name: "version_emojis",
          description: "Returns all version_emojis",
          create_options: [
            {
              required_relationships: [
                "version"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              emoji: {
                type: "String",
                desc: "Emoji of this version_emoji"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a version_emoji",
              get: true
            },
            {
              name: "id",
              description: "Delete a version_emoji",
              delete: true
            }
          ]
        },
        "Projects::VersionFlag": {
          name: "version_flags",
          description: "Returns all version_flags",
          create_options: [
            {
              required_relationships: [
                "version"
              ]
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a version_flag",
              get: true
            },
            {
              name: "id",
              description: "Update a version_flag",
              update_options: [
                {
                  agreeable: true,
                  disagreeable: true
                }
              ],
              put: true
            }
          ]
        },
        "Projects::VersionCommentEmoji": {
          name: "version_comment_emojis",
          description: "Returns all version_comment_emojis",
          create_options: [
            {
              required_relationships: [
                "version_comment"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              emoji: {
                type: "String",
                desc: "Emoji of this version_comment_emoji"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a version_comment_emoji",
              get: true
            },
            {
              name: "id",
              description: "Delete a version_comment_emoji",
              delete: true
            }
          ]
        },
        "Projects::VersionCommentFlag": {
          name: "version_comment_flags",
          description: "Returns all version_comment_flags",
          create_options: [
            {
              required_relationships: [
                "version_comment"
              ]
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a version_comment_flag",
              get: true
            },
            {
              name: "id",
              description: "Update a version_comment_flag",
              update_options: [
                {
                  agreeable: true,
                  disagreeable: true
                }
              ],
              put: true
            }
          ]
        },
        "Stream::UserActivityEmoji": {
          name: "user_activity_emojis",
          description: "Returns all user_activity_emojis",
          create_options: [
            {
              required_relationships: [
                "user_activity"
              ]
            }
          ],
          create_params: {
            requires: {
              emoji: {
                type: "String",
                desc: "Emoji of this user_activity_emoji"
              }
            },
            optional: {}
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a user_activity_emoji",
              get: true
            },
            {
              name: "id",
              description: "Delete a user_activity_emoji",
              delete: true
            }
          ]
        },
        "Stream::UserActivities::UserActivity": {
          name: "user_activities",
          description: "Returns all user_activities",
          filter_options: [
            {
              deletable: true
            }
          ],
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a user_activity",
              get: true
            },
            {
              name: "id",
              resources: {
                user_activity_emojis: {
                  name: "user_activity_emojis",
                  description: "List of user_activity_emojis for this user_activity",
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Library::KeyringGrant": {
          name: "keyring_grants",
          description: "Create a economy_keyring_grant",
          create_params: {
            requires: {
              unlock_code: {
                type: "String",
                desc: "Unlock Code of the keyring"
              }
            },
            optional: {}
          },
          post: true,
          authorize: [
            "account"
          ]
        },
        "Economy::KeyringPurchase": {
          name: "keyring_purchases",
          description: "Create a economy_keyring_purchase",
          create_options: [
            {
              required_relationships: [
                "library_keyring"
              ]
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Update a economy_keyring_purchase",
              update_options: [
                {
                  deletable: true
                }
              ],
              put: true
            },
            {
              name: "id",
              description: "Delete a economy_keyring_purchase",
              delete: true
            }
          ]
        },
        "Library::Keyring": {
          name: "library_keyrings",
          description: "Returns all library_keyrings",
          create_params: {
            requires: {
              name: {
                type: "String",
                desc: "Name of this keyring"
              },
              description: {
                type: "String",
                desc: "Description of this keyring"
              }
            },
            optional: {
              unlock_code: {
                type: "String",
                desc: "Unlock Code of this keyring"
              },
              coins: {
                type: "Integer",
                desc: "Novas of this keyring"
              }
            }
          },
          filter_options: [
            {
              resolvable: true,
              cancelable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              ids: {
                type: "Array"
              },
              q: {
                type: "String",
                desc: "search the keyrings by name"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a keyring",
              get: true
            },
            {
              name: "id",
              description: "Update a library_keyring",
              update_params: {
                requires: {},
                optional: {
                  name: {
                    type: "String",
                    desc: "Name of this keyring"
                  },
                  description: {
                    type: "String",
                    desc: "Description of this keyring"
                  },
                  unlock_code: {
                    type: "String",
                    desc: "Unlock Code of this keyring"
                  },
                  coins: {
                    type: "Integer",
                    desc: "Novas of this keyring"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Economy::BankBalanceAdjustment": {
          name: "bank_balance_adjustments",
          description: "Create a bank_balance_adjustment",
          create_options: [
            {
              required_relationships: [
                "user"
              ]
            }
          ],
          create_params: {
            requires: {},
            optional: {
              description: {
                type: "String",
                desc: "Description of this adjustment"
              },
              coins: {
                type: "Integer",
                desc: "Novas of this adjustment"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Update a bank_balance_adjustment",
              update_options: [
                {
                  deletable: true
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  description: {
                    type: "String",
                    desc: "Description of this adjustment"
                  },
                  coins: {
                    type: "Integer",
                    desc: "Novas of this adjustment"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a bank_balance_adjustment",
              delete: true
            }
          ]
        },
        "Streaming::Stream": {
          name: "streaming_streams",
          description: "Returns all streaming_streams",
          create_options: [
            {
              required_relationships: [
                {
                  name: "presenter",
                  as: "user"
                }
              ],
              optional_relationships: [
                {
                  name: "replay_chat_stream",
                  as: "streaming_stream"
                }
              ]
            }
          ],
          create_params: {
            requires: {
              title: {
                type: "String",
                desc: "Title of this stream"
              },
              description: {
                type: "String",
                desc: "Description of this stream"
              },
              source: {
                type: "Symbol",
                values: [
                  "prerecorded",
                  "live"
                ],
                desc: "prerecorded and live"
              },
              start_at: {
                type: "Time",
                desc: "Start At of this stream"
              },
              end_at: {
                type: "Time",
                desc: "End At of this stream"
              },
              audience: {
                type: "Symbol",
                values: [
                  "private",
                  "public",
                  "users",
                  "premium"
                ],
                desc: "private, public, users or premium"
              }
            },
            optional: {
              source_file: {
                type: "String",
                desc: "File for this source (if prerecorded)"
              },
              channel: {
                type: "Symbol",
                values: [
                  "conversion",
                  "acquisition"
                ],
                desc: "null, conversion and acquisition"
              }
            }
          },
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              after: {
                type: "Date",
                desc: "filter for streams after this date"
              },
              before: {
                type: "Date",
                desc: "filter for streams before this date"
              },
              source: {
                type: "Symbol",
                values: [
                  "prerecorded",
                  "live"
                ],
                desc: "prerecorded and live"
              },
              channel: {
                type: "Symbol",
                values: [
                  "conversion",
                  "acquisition"
                ],
                desc: "null, conversion and acquisition"
              },
              audience: {
                type: "Symbol",
                values: [
                  "private",
                  "public",
                  "users",
                  "premium"
                ],
                desc: "private, public, users or premium"
              },
              presenter_id: {
                type: "UUID",
                desc: "a single presenter_id"
              },
              presenter_ids: {
                type: "UUID",
                desc: "an array of presenter_ids"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at",
            "start_at",
            "end_at"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a stream",
              get: true
            },
            {
              name: "id",
              description: "Update a stream",
              update_options: [
                {
                  deletable: true,
                  optional_relationships: [
                    {
                      name: "presenter",
                      as: "user"
                    }
                  ]
                }
              ],
              update_params: {
                requires: {},
                optional: {
                  title: {
                    type: "String",
                    desc: "Title of this stream"
                  },
                  description: {
                    type: "String",
                    desc: "Description of this stream"
                  },
                  source: {
                    type: "Symbol",
                    values: [
                      "prerecorded",
                      "live"
                    ],
                    desc: "prerecorded and live"
                  },
                  source_file: {
                    type: "String",
                    desc: "File for this source (if prerecorded)"
                  },
                  stream_id: {
                    type: "String",
                    desc: "The id for completed streams"
                  },
                  channel: {
                    type: "Symbol",
                    values: [
                      "conversion",
                      "acquisition"
                    ],
                    desc: "null, conversion and acquisition"
                  },
                  start_at: {
                    type: "Time",
                    desc: "Start At of this stream"
                  },
                  end_at: {
                    type: "Time",
                    desc: "End At of this stream"
                  },
                  audience: {
                    type: "Symbol",
                    values: [
                      "private",
                      "public",
                      "users",
                      "premium"
                    ],
                    desc: "private, public, users or premium"
                  },
                  status: {
                    type: "Symbol",
                    values: [
                      "scheduled",
                      "started",
                      "ended",
                      "on_demand"
                    ],
                    desc: "joined and left"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              description: "Delete a stream",
              delete: true
            },
            {
              name: "id",
              resources: {
                streaming_chat_messages: {
                  name: "streaming_chat_messages",
                  description: "List of chat_messages for this stream",
                  filter_params: {
                    requires: {},
                    optional: {
                      ids: {
                        type: "Array"
                      },
                      status: {
                        type: "Symbol",
                        values: [
                          "pending",
                          "canceled",
                          "manually_approved",
                          "manually_rejected",
                          "automatically_approved",
                          "automatically_rejected",
                          "previousely_approved",
                          "previousely_rejected",
                          "presenter",
                          "administrator",
                          "guide"
                        ],
                        desc: ""
                      }
                    }
                  },
                  get: true,
                  paginate_params: true,
                  sort_by_param: [
                    "created_at"
                  ]
                }
              }
            }
          ]
        },
        "Streaming::Registration": {
          name: "streaming_registrations",
          description: "Returns all streaming_registrations",
          create_options: [
            {
              required_relationships: [
                "streaming_stream"
              ],
              optional_relationships: [
                "organization",
                {
                  name: "registrant",
                  as: "user"
                }
              ]
            }
          ],
          filter_options: [
            {
              deletable: true
            }
          ],
          filter_params: {
            requires: {},
            optional: {
              stream_id: {
                type: "UUID",
                desc: "a single stream_id"
              },
              stream_ids: {
                type: "Array",
                desc: "an array of stream_ids"
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a registration",
              get: true
            },
            {
              name: "id",
              description: "Delete a streaming_registration",
              delete: true
            }
          ]
        },
        "Streaming::ChatMessage": {
          name: "streaming_chat_messages",
          description: "Returns all streaming_chat_messages",
          create_options: [
            {
              required_relationships: [
                "streaming_stream"
              ],
              optional_relationships: [
                "user"
              ]
            }
          ],
          create_params: {
            requires: {
              message: {
                type: "String",
                desc: "The Chat Message"
              }
            },
            optional: {
              send_at: {
                type: "DateTime",
                desc: "For delaying chat messages until a specific time"
              },
              metadata: {
                type: "Hash"
              }
            }
          },
          filter_params: {
            requires: {},
            optional: {
              ids: {
                type: "Array"
              },
              status: {
                type: "Symbol",
                values: [
                  "pending",
                  "canceled",
                  "manually_approved",
                  "manually_rejected",
                  "automatically_approved",
                  "automatically_rejected",
                  "previousely_approved",
                  "previousely_rejected",
                  "presenter",
                  "administrator",
                  "guide"
                ],
                desc: ""
              }
            }
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          sort_by_param: [
            "created_at"
          ],
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a chat_message",
              get: true
            },
            {
              name: "id",
              description: "Update a stream chat message",
              update_params: {
                requires: {},
                optional: {
                  send_at: {
                    type: "DateTime",
                    desc: "for sending a message at a specific time"
                  },
                  status: {
                    type: "Symbol",
                    values: [
                      "pending",
                      "canceled",
                      "manually_approved",
                      "manually_rejected",
                      "automatically_approved",
                      "automatically_rejected",
                      "previousely_approved",
                      "previousely_rejected",
                      "presenter",
                      "administrator",
                      "guide"
                    ],
                    desc: "pending, canceled, manually_approved, manually_rejected, automatically_approved, automatically_rejected, previousely_approved, previousely_rejected, presenter, administrator or guide"
                  }
                }
              },
              put: true
            },
            {
              name: "id",
              resources: {
                streaming_chat_message_approvals: {
                  name: "streaming_chat_message_approvals",
                  description: "List of chat_message_approvals for this chat_message",
                  get: true,
                  paginate_params: true
                }
              }
            }
          ]
        },
        "Streaming::ChatMessageApproval": {
          name: "streaming_chat_message_approvals",
          description: "Returns all streaming_chat_message_approvals",
          create_options: [
            {
              required_relationships: [
                "streaming_chat_message"
              ]
            }
          ],
          create_params: {
            requires: {
              status: {
                type: "Symbol",
                values: [
                  "approved",
                  "force_approved",
                  "rejected"
                ],
                desc: "approved, force_approved or rejected"
              }
            },
            optional: {}
          },
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a chat_message_approval",
              get: true
            }
          ]
        },
        "Streaming::Viewer": {
          name: "streaming_viewers",
          description: "Returns all streaming_viewers",
          create_options: [
            {
              required_relationships: [
                "streaming_stream"
              ]
            }
          ],
          post: true,
          authorize: [
            "account"
          ],
          get: true,
          paginate_params: true,
          id_param: true,
          route_params: [
            {
              name: "id",
              description: "Get a viewer",
              get: true
            },
            {
              name: "id",
              description: "Update a streaming_viewer",
              update_params: {
                requires: {},
                optional: {
                  status: {
                    type: "Symbol",
                    values: [
                      "joined",
                      "left"
                    ],
                    desc: "joined and left"
                  }
                }
              },
              put: true
            }
          ]
        },
        "Narration::Voices::Voice": {
          name: "voices",
          description: "Create a voice",
          create_params: {
            requires: {
              name: {
                type: "String",
                desc: "Name of this voice"
              },
              synthesizer: {
                type: "Symbol",
                values: [
                  "resemble_synthesized_voice"
                ],
                desc: "resemble_synthesized_voice"
              },
              synthesizer_id: {
                type: "String",
                desc: "Resemble UUID for this voice"
              },
              language_code: {
                type: "String",
                allow_blank: false,
                desc: "Language of this voice"
              },
              country_code: {
                type: "String",
                allow_blank: false,
                desc: "Country of this voice"
              }
            },
            optional: {}
          },
          post: true,
          authorize: [
            "account"
          ]
        }
      }
    end
  end
end
