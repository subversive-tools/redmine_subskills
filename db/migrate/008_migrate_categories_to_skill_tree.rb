class MigrateCategoriesToSkillTree < ActiveRecord::Migration[5.2]
  def up
    categories = connection.select_values(
      "SELECT DISTINCT category FROM subskill_skills " \
      "WHERE category IS NOT NULL AND category != '' ORDER BY category"
    )

    categories.each_with_index do |cat, idx|
      now    = connection.quote(Time.current.utc.strftime('%Y-%m-%d %H:%M:%S'))
      q_name = connection.quote(cat)

      connection.execute(
        "INSERT INTO subskill_skills " \
        "(name, category, description, active, position, weight, created_at, updated_at) " \
        "VALUES (#{q_name}, '', '', TRUE, #{(idx + 1) * 100}, 1.0, #{now}, #{now})"
      )

      parent_id = connection.select_value(
        "SELECT id FROM subskill_skills " \
        "WHERE name = #{q_name} AND (category = '' OR category IS NULL) " \
        "ORDER BY id DESC LIMIT 1"
      )

      connection.execute(
        "UPDATE subskill_skills SET parent_id = #{parent_id} " \
        "WHERE category = #{q_name} AND id != #{parent_id}"
      )
    end
  end

  def down
    root_ids = connection.select_values(
      "SELECT id FROM subskill_skills WHERE parent_id IS NULL AND (category = '' OR category IS NULL)"
    )

    root_ids.each do |root_id|
      cat_name = connection.select_value("SELECT name FROM subskill_skills WHERE id = #{root_id}")
      q_cat    = connection.quote(cat_name)
      connection.execute(
        "UPDATE subskill_skills SET category = #{q_cat}, parent_id = NULL WHERE parent_id = #{root_id}"
      )
      connection.execute("DELETE FROM subskill_skills WHERE id = #{root_id}")
    end
  end
end
