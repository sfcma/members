# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20181024003131) do

  create_table "absences", force: :cascade do |t|
    t.integer  "member_id"
    t.date     "date"
    t.boolean  "planned"
    t.string   "sub_found"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.datetime "deleted_at"
    t.integer  "performance_set_date_id"
    t.index ["deleted_at"], name: "index_absences_on_deleted_at"
    t.index ["member_id"], name: "index_absences_on_member_id"
  end

  create_table "action_logs", force: :cascade do |t|
    t.integer  "member_id"
    t.integer  "user_id"
    t.string   "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_action_logs_on_member_id"
    t.index ["user_id"], name: "index_action_logs_on_user_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "email_id",          default: 0, null: false
  end

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "community_night_instruments", force: :cascade do |t|
    t.integer  "community_night_id"
    t.string   "instrument"
    t.integer  "limit"
    t.boolean  "available_to_opt_in"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "community_nights", force: :cascade do |t|
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.string   "type"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "deleted_at"
    t.string   "leader_name"
    t.string   "leader_email"
    t.integer  "leader_user_id"
    t.index ["deleted_at"], name: "index_community_nights_on_deleted_at"
  end

  create_table "email_logs", force: :cascade do |t|
    t.integer  "email_id",   null: false
    t.integer  "member_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.datetime "opened_at"
    t.index ["deleted_at"], name: "index_email_logs_on_deleted_at"
    t.index ["email_id"], name: "index_email_logs_on_email_id"
    t.index ["member_id"], name: "index_email_logs_on_member_id"
  end

  create_table "emails", force: :cascade do |t|
    t.text     "email_body",                    null: false
    t.string   "email_title",                   null: false
    t.integer  "user_id",                       null: false
    t.integer  "performance_set_id"
    t.integer  "ensemble_id"
    t.integer  "performance_set_instrument_id"
    t.string   "status"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.datetime "deleted_at"
    t.integer  "email_type"
    t.datetime "sent_at"
    t.string   "instruments"
    t.string   "behalf_of_name"
    t.string   "behalf_of_email"
    t.string   "email_audience_type"
    t.index ["deleted_at"], name: "index_emails_on_deleted_at"
    t.index ["ensemble_id"], name: "index_emails_on_ensemble_id"
    t.index ["performance_set_id"], name: "index_emails_on_performance_set_id"
    t.index ["performance_set_instrument_id"], name: "index_emails_on_performance_set_instrument_id"
    t.index ["user_id"], name: "index_emails_on_user_id"
  end

  create_table "ensembles", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_ensembles_on_deleted_at"
  end

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index"
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index"
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "member_community_nights", force: :cascade do |t|
    t.string   "status"
    t.integer  "member_id"
    t.integer  "community_night_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "member_instrument_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_member_community_nights_on_deleted_at"
  end

  create_table "member_instruments", force: :cascade do |t|
    t.integer  "member_id"
    t.string   "instrument"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_member_instruments_on_deleted_at"
    t.index ["member_id"], name: "index_member_instruments_on_member_id"
  end

  create_table "member_notes", force: :cascade do |t|
    t.integer  "member_id"
    t.integer  "user_id"
    t.string   "note"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "deleted_at"
    t.boolean  "private_note", default: false
    t.index ["deleted_at"], name: "index_member_notes_on_deleted_at"
    t.index ["member_id"], name: "index_member_notes_on_member_id"
    t.index ["user_id"], name: "index_member_notes_on_user_id"
  end

  create_table "member_sets", force: :cascade do |t|
    t.integer  "performance_set_id"
    t.integer  "member_id"
    t.string   "set_status"
    t.string   "string"
    t.boolean  "rotating"
    t.boolean  "boolean"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.datetime "deleted_at"
    t.integer  "set_status_id",      default: 0,     null: false
    t.boolean  "standby_player",     default: false
    t.index ["deleted_at"], name: "index_member_sets_on_deleted_at"
    t.index ["member_id", "performance_set_id"], name: "index_member_sets_on_member_id_and_performance_set_id", unique: true
    t.index ["member_id"], name: "index_member_sets_on_member_id"
    t.index ["performance_set_id"], name: "index_member_sets_on_performance_set_id"
    t.index ["set_status_id"], name: "index_member_sets_on_set_status_id"
  end

  create_table "members", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone_1"
    t.string   "phone_1_type"
    t.string   "phone_2"
    t.string   "phone_2_type"
    t.string   "email_1"
    t.string   "email_2"
    t.string   "emergency_name"
    t.string   "emergency_relation"
    t.string   "emergency_phone"
    t.string   "playing_status"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.datetime "initial_date"
    t.datetime "waiver_signed"
    t.datetime "deleted_at"
    t.string   "program_name"
    t.datetime "contact_reply_date"
    t.text     "introduction"
    t.integer  "reply_user_id"
    t.boolean  "source_website"
    t.string   "source_other"
    t.boolean  "interested_in_large_ensemble_opportunities", default: true
    t.boolean  "interested_in_chamber_opportunities",        default: true
    t.boolean  "unsubscribe_from_all_emails",                default: false
    t.boolean  "no_contact",                                 default: false
    t.index ["deleted_at"], name: "index_members_on_deleted_at"
  end

  create_table "old_passwords", force: :cascade do |t|
    t.string   "encrypted_password",       null: false
    t.string   "password_archivable_type", null: false
    t.integer  "password_archivable_id",   null: false
    t.datetime "created_at"
    t.index ["password_archivable_type", "password_archivable_id"], name: "index_password_archivable"
  end

  create_table "opt_in_messages", force: :cascade do |t|
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title"
  end

  create_table "performance_pieces", force: :cascade do |t|
    t.integer  "performance_set_id"
    t.string   "title",              null: false
    t.string   "composer"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_performance_pieces_on_deleted_at"
    t.index ["performance_set_id"], name: "index_performance_pieces_on_performance_set_id"
  end

  create_table "performance_pieces_members", force: :cascade do |t|
    t.integer  "performance_piece_id"
    t.integer  "member_id"
    t.string   "instrument",           null: false
    t.string   "member_piece_status",  null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_performance_pieces_members_on_deleted_at"
    t.index ["member_id"], name: "index_performance_pieces_members_on_member_id"
    t.index ["performance_piece_id"], name: "index_performance_pieces_members_on_performance_piece_id"
  end

  create_table "performance_set_dates", force: :cascade do |t|
    t.integer  "performance_set_id", null: false
    t.date     "date",               null: false
    t.datetime "deleted_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["deleted_at"], name: "index_performance_set_dates_on_deleted_at"
    t.index ["performance_set_id"], name: "index_performance_set_dates_on_performance_set_id"
  end

  create_table "performance_set_instruments", force: :cascade do |t|
    t.integer  "performance_set_id"
    t.string   "instrument",                      null: false
    t.integer  "limit"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "available_to_opt_in"
    t.string   "opt_in_message_type"
    t.decimal  "opt_in_message_id"
    t.integer  "standby_limit",       default: 0
    t.index ["performance_set_id"], name: "index_performance_set_instruments_on_performance_set_id"
  end

  create_table "performance_sets", force: :cascade do |t|
    t.integer  "ensemble_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "name"
    t.datetime "deleted_at"
    t.string   "description"
    t.text     "opt_in_message"
    t.datetime "opt_in_start_date"
    t.datetime "opt_in_end_date"
    t.index ["deleted_at"], name: "index_performance_sets_on_deleted_at"
    t.index ["end_date", "ensemble_id"], name: "index_end_date_and_ensemble_id"
    t.index ["end_date"], name: "index_performance_sets_on_end_date"
    t.index ["ensemble_id"], name: "index_performance_sets_on_ensemble_id"
  end

  create_table "set_member_instruments", force: :cascade do |t|
    t.integer  "performance_set_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "member_set_id"
    t.integer  "member_instrument_id"
    t.datetime "deleted_at"
    t.string   "variant"
    t.index ["deleted_at"], name: "index_set_member_instruments_on_deleted_at"
    t.index ["performance_set_id"], name: "index_set_member_instruments_on_performance_set_id"
  end

  create_table "user_ensembles", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "ensemble_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["ensemble_id"], name: "index_user_ensembles_on_ensemble_id"
    t.index ["user_id"], name: "index_user_ensembles_on_user_id"
  end

  create_table "user_instrument_ensemble_permissions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "user_instrument_id"
    t.integer  "user_ensemble_id"
    t.string   "permission_name"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["user_ensemble_id"], name: "index_user_inst_ens_perms_on_user_ensemble_id"
    t.index ["user_id"], name: "index_user_instrument_ensemble_permissions_on_user_id"
    t.index ["user_instrument_id"], name: "index_user_inst_ens_perms_on_user_instrument_id"
  end

  create_table "user_instruments", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "instrument", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["instrument"], name: "index_user_instruments_on_instrument"
    t.index ["user_id"], name: "index_user_instruments_on_user_id"
  end

  create_table "user_permissions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_permissions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                    default: "",    null: false
    t.string   "encrypted_password",                       default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                            default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                          default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "password_changed_at"
    t.string   "unique_session_id",             limit: 20
    t.datetime "last_activity_at"
    t.datetime "expired_at"
    t.string   "paranoid_verification_code"
    t.integer  "paranoid_verification_attempt",            default: 0
    t.datetime "paranoid_verified_at"
    t.datetime "deleted_at"
    t.boolean  "global_admin",                             default: false
    t.string   "name"
    t.string   "phone"
    t.boolean  "is_active"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["expired_at"], name: "index_users_on_expired_at"
    t.index ["last_activity_at"], name: "index_users_on_last_activity_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
