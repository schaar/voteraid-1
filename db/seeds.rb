# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


  messages = Message.create([{ body: 'test message body' }, { request_id: 0 }])
  requests = Request.create([{ address: '2020 kittredge street' }, { request_id: 0 }, { responder_id: 0 }])
  responders = Responder.create([ ])

 # create_table "messages", force: :cascade do |t|
 #    t.string   "body"
 #    t.integer  "request_id"
 #    t.datetime "created_at", null: false
 #    t.datetime "updated_at", null: false
 #    t.index ["request_id"], name: "index_messages_on_request_id", using: :btree
 #  end

 #  create_table "requests", force: :cascade do |t|
 #    t.string   "phone"
 #    t.string   "address"
 #    t.string   "poll"
 #    t.string   "desc"
 #    t.integer  "responder_id"
 #    t.datetime "created_at",   null: false
 #    t.datetime "updated_at",   null: false
 #    t.integer  "status"
 #    t.integer  "issue"
 #    t.index ["responder_id"], name: "index_requests_on_responder_id", using: :btree
 #  end
