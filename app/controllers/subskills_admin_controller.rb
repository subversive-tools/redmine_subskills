class SubskillsAdminController < ApplicationController
  before_action :require_admin
  before_action :find_skill, only: [:edit, :update, :destroy, :move]
  skip_before_action :verify_authenticity_token, only: [:reorder, :reorder_categories, :reparent]

  layout 'admin'

  # GET /subskills/admin
  def index
    @tree_rows = SubskillSkill.tree_rows
  end

  # GET /subskills/admin/new
  def new
    if params[:copy_from].present? && (src = SubskillSkill.find_by(id: params[:copy_from]))
      @skill = src.dup
      @skill.name      = "Kopie von #{src.name}"
      @skill.parent_id = src.parent_id
      @skill.position  = SubskillSkill.maximum(:position).to_i + 1
      build_level_descriptions(@skill)
      src.level_descriptions.each do |ld|
        @skill.level_descriptions.find { |d| d.level == ld.level }&.tap { |d| d.description = ld.description }
      end
    else
      @skill = SubskillSkill.new(
        active:    true,
        parent_id: params[:parent_id],
        position:  SubskillSkill.maximum(:position).to_i + 1
      )
      build_level_descriptions(@skill)
    end
    @parent_options = parent_options_for(@skill)
  end

  # POST /subskills/admin
  def create
    @skill = SubskillSkill.new(skill_params)
    if @skill.save
      flash[:notice] = "Skill '#{@skill.name}' wurde erstellt."
      redirect_to subskills_admin_index_path
    else
      @parent_options = parent_options_for(@skill)
      render :new
    end
  end

  # GET /subskills/admin/:id/edit
  def edit
    build_level_descriptions(@skill)
    @parent_options = parent_options_for(@skill)
  end

  # PATCH /subskills/admin/:id
  def update
    if @skill.update(skill_params)
      flash[:notice] = "Skill '#{@skill.name}' wurde aktualisiert."
      redirect_to subskills_admin_index_path
    else
      @parent_options = parent_options_for(@skill)
      render :edit
    end
  end

  # DELETE /subskills/admin/:id
  def destroy
    if @skill.children.any?
      flash[:error] = "Skill '#{@skill.name}' hat noch Unter-Skills und kann nicht gelöscht werden."
      return redirect_to subskills_admin_index_path
    end
    name = @skill.name
    @skill.destroy
    flash[:notice] = "Skill '#{name}' wurde gelöscht."
    redirect_to subskills_admin_index_path
  end

  # POST /subskills/admin/:id/move  (legacy up/down buttons)
  def move
    direction = params[:direction]
    scope = SubskillSkill.where(parent_id: @skill.parent_id)
    other = direction == 'up' ?
      scope.where('position < ?', @skill.position).order(position: :desc).first :
      scope.where('position > ?', @skill.position).order(position: :asc).first

    if other
      @skill.position, other.position = other.position, @skill.position
      @skill.save!; other.save!
    end
    redirect_to subskills_admin_index_path
  end

  # POST /subskills/admin/reorder  (AJAX — siblings or root skills)
  def reorder
    ids = extract_ids(params[:ids])
    ids.each_with_index { |id, i| SubskillSkill.where(id: id).update_all(position: i + 1) }
    render json: { ok: true }
  rescue => e
    render json: { ok: false, error: e.message }, status: 422
  end

  # POST /subskills/admin/reorder_categories  (AJAX — root-level reorder by root skill ids)
  def reorder_categories
    ids = extract_ids(params[:ids])
    ids.each_with_index { |id, i| SubskillSkill.where(id: id, parent_id: nil).update_all(position: (i + 1) * 10) }
    render json: { ok: true }
  rescue => e
    render json: { ok: false, error: e.message }, status: 422
  end

  # POST /subskills/admin/reparent  (AJAX — move skill to new parent or make top-level)
  def reparent
    skill = SubskillSkill.find(params[:skill_id])
    new_parent_id = params[:new_parent_id].presence&.to_i  # nil / blank = top-level

    if new_parent_id.present?
      target = SubskillSkill.find_by(id: new_parent_id)
      return render(json: { ok: false, error: 'Ziel nicht gefunden.' }, status: 422) unless target
      return render(json: { ok: false, error: 'Skill kann nicht sein eigener Eltern-Skill sein.' }, status: 422) if target.id == skill.id

      # Prevent circular references (target must not be a descendant of skill)
      node = target
      while node.parent_id
        node = SubskillSkill.find(node.parent_id)
        return render(json: { ok: false, error: 'Zirkuläre Abhängigkeit nicht erlaubt.' }, status: 422) if node.id == skill.id
      end

      # Target must be able to accept children
      unless target.children.any? || target.user_skills.none?
        return render(json: { ok: false, error: "'#{target.name}' hat bereits Bewertungen und kann keine Kinder aufnehmen." }, status: 422)
      end
    end

    skill.update!(parent_id: new_parent_id)
    render json: { ok: true }
  rescue ActiveRecord::RecordNotFound
    render json: { ok: false, error: 'Skill nicht gefunden.' }, status: 404
  rescue => e
    render json: { ok: false, error: e.message }, status: 422
  end

  def seed
    SubskillSkill.seed_defaults!
    flash[:notice] = "Standard-Skills wurden eingespielt (#{SubskillSkill.count} insgesamt)."
    redirect_to subskills_admin_index_path
  end

  # GET /subskills/admin/export_csv
  def export_csv
    require 'csv'
    skills    = SubskillSkill.ordered.includes(:level_descriptions)
    descs_map = SubskillLevelDescription
                  .where(subskill_skill_id: skills.map(&:id))
                  .each_with_object({}) { |d, h| (h[d.subskill_skill_id] ||= {})[d.level] = d.description }

    csv_data = CSV.generate(headers: true, encoding: 'UTF-8') do |csv|
      csv << ['name', 'parent', 'description', 'level_1', 'level_2', 'level_3', 'level_4', 'level_5']
      skills.each do |s|
        ld = descs_map[s.id] || {}
        csv << [s.name, s.parent&.name, s.description, ld[1], ld[2], ld[3], ld[4], ld[5]]
      end
    end

    send_data "\xEF\xBB\xBF#{csv_data}",
              filename:    "skills_export_#{Date.today}.csv",
              type:        'text/csv; charset=utf-8',
              disposition: 'attachment'
  end

  # POST /subskills/admin/import_csv
  def import_csv
    file = params[:csv_file]
    unless file
      flash[:error] = 'Keine Datei ausgewählt.'
      return redirect_to subskills_admin_index_path
    end

    require 'csv'
    created = 0; updated = 0; errors = []

    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
      name   = row[:name]&.strip
      next if name.blank?

      parent_name = row[:parent]&.strip
      parent = parent_name.present? ? SubskillSkill.find_by(name: parent_name) : nil

      skill = SubskillSkill.find_or_initialize_by(name: name)
      is_new = skill.new_record?
      skill.parent_id  = parent&.id
      skill.description = row[:description]&.strip if row[:description].present?
      skill.active     = true if is_new
      skill.position ||= SubskillSkill.maximum(:position).to_i + 1

      if skill.save
        is_new ? created += 1 : updated += 1
        (1..5).each do |lvl|
          col_text = row["level_#{lvl}".to_sym]&.strip
          next if col_text.blank?
          ld = SubskillLevelDescription.find_or_initialize_by(subskill_skill_id: skill.id, level: lvl)
          ld.description = col_text; ld.save
        end
      else
        errors << "#{name}: #{skill.errors.full_messages.join(', ')}"
      end
    end

    msg = "Import: #{created} neu, #{updated} aktualisiert."
    msg += " Fehler: #{errors.join(' | ')}" if errors.any?
    flash[errors.any? ? :warning : :notice] = msg
    redirect_to subskills_admin_index_path
  rescue => e
    flash[:error] = "CSV-Fehler: #{e.message}"
    redirect_to subskills_admin_index_path
  end

  private

  def find_skill
    @skill = SubskillSkill.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  # Handles ids[] (array) or ids[0]/ids[1] (hash) from form params
  def extract_ids(raw)
    return [] if raw.blank?
    if raw.is_a?(Array)
      raw.map(&:to_i)
    else
      raw.to_unsafe_h.values.map(&:to_i)
    end
  end

  def skill_params
    params.require(:subskill_skill).permit(
      :name, :description, :position, :active, :parent_id,
      level_descriptions_attributes: [:id, :level, :description]
    )
  end

  def build_level_descriptions(skill)
    existing = skill.level_descriptions.index_by(&:level)
    (1..5).each { |lvl| skill.level_descriptions.build(level: lvl) unless existing[lvl] }
  end

  # Skills that can serve as parent of `skill` (not itself, not its descendants)
  def parent_options_for(skill)
    excluded = skill.persisted? ? ([skill.id] + SubskillSkill.tree_rows.select { |r| r[:skill].id == skill.id || r[:skill].parent_id == skill.id }.map { |r| r[:skill].id }) : []
    SubskillSkill.where.not(id: excluded).order(:position, :name).map { |s| [s.name, s.id] }
  end
end
