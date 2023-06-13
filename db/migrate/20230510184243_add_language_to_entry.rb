class AddLanguageToEntry < ActiveRecord::Migration[7.0]
  def change
    create_enum :language_option, ["en", "de"]

    change_table :entries do |t|
      t.enum :language, enum_type: "language_option", default: "en", null: false
    end
  end
end
