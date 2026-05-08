class SubskillsAdminController < ApplicationController
  before_action :require_admin
  before_action :find_skill, only: [:edit, :update, :destroy, :move]
  skip_before_action :verify_authenticity_token, only: [:reorder]

  layout 'admin'

  # GET /subskills/admin
  def index
    @skills = SubskillSkill.ordered
    @skills = @skills.where(category: params[:category]) if params[:category].present?
    @skills = @skills.where(active: params[:active] == '1') if params[:active].present? && params[:active] != ''
    @categories = SubskillSkill::CATEGORIES
  end

  # GET /subskills/admin/new
  def new
    if params[:copy_from].present? && (src = SubskillSkill.find_by(id: params[:copy_from]))
      @skill = src.dup
      @skill.name = "Kopie von #{src.name}"
      @skill.position = SubskillSkill.maximum(:position).to_i + 1
      build_level_descriptions(@skill)
      # copy existing level descriptions
      src.level_descriptions.each do |ld|
        @skill.level_descriptions.find { |d| d.level == ld.level }&.tap { |d| d.description = ld.description }
      end
    else
      @skill = SubskillSkill.new(active: true, position: SubskillSkill.maximum(:position).to_i + 1)
      build_level_descriptions(@skill)
    end
    @categories = SubskillSkill::CATEGORIES
  end

  # POST /subskills/admin
  def create
    @skill = SubskillSkill.new(skill_params)
    if @skill.save
      flash[:notice] = "Skill '#{@skill.name}' wurde erstellt."
      redirect_to subskills_admin_index_path
    else
      @categories = SubskillSkill::CATEGORIES
      render :new
    end
  end

  # GET /subskills/admin/:id/edit
  def edit
    build_level_descriptions(@skill)
    @categories = SubskillSkill::CATEGORIES
  end

  # PATCH /subskills/admin/:id
  def update
    if @skill.update(skill_params)
      flash[:notice] = "Skill '#{@skill.name}' wurde aktualisiert."
      redirect_to subskills_admin_index_path
    else
      @categories = SubskillSkill::CATEGORIES
      render :edit
    end
  end

  # DELETE /subskills/admin/:id
  def destroy
    name = @skill.name
    @skill.destroy
    flash[:notice] = "Skill '#{name}' wurde gelöscht."
    redirect_to subskills_admin_index_path
  end

  # POST /subskills/admin/:id/move
  def move
    direction = params[:direction]
    other = direction == 'up' ?
      SubskillSkill.where('position < ?', @skill.position).order(position: :desc).first :
      SubskillSkill.where('position > ?', @skill.position).order(position: :asc).first

    if other
      @skill.position, other.position = other.position, @skill.position
      @skill.save!
      other.save!
    end
    redirect_to subskills_admin_index_path
  end

  # POST /subskills/admin/reorder  (AJAX drag-and-drop)
  def reorder
    ids = params[:ids].map(&:to_i)
    ids.each_with_index do |id, idx|
      SubskillSkill.where(id: id).update_all(position: idx + 1)
    end
    render json: { ok: true }
  rescue => e
    render json: { ok: false, error: e.message }, status: 422
  end

  # POST /subskills/admin/seed
  def seed
    SubskillSkill.seed_defaults!
    flash[:notice] = "Standard-Skills wurden eingespielt (#{SubskillSkill.count} insgesamt)."
    redirect_to subskills_admin_index_path
  end

  # GET /subskills/admin/export_csv
  def export_csv
    require 'csv'
    skills    = SubskillSkill.ordered.includes(:level_descriptions)
    # {skill_id => {level => text}}
    descs_map = SubskillLevelDescription
                  .where(subskill_skill_id: skills.map(&:id))
                  .each_with_object({}) { |d, h| (h[d.subskill_skill_id] ||= {})[d.level] = d.description }

    csv_data = CSV.generate(headers: true, encoding: 'UTF-8') do |csv|
      csv << ['name', 'category', 'description', 'level_1', 'level_2', 'level_3', 'level_4', 'level_5']
      skills.each do |s|
        ld = descs_map[s.id] || {}
        csv << [s.name, s.category, s.description, ld[1], ld[2], ld[3], ld[4], ld[5]]
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
    created = 0
    updated = 0
    errors  = []

    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
      name     = row[:name]&.strip
      category = row[:category]&.strip
      desc     = row[:description]&.strip

      next if name.blank?

      unless SubskillSkill::CATEGORIES.include?(category)
        errors << "Unbekannte Kategorie '#{category}' für '#{name}'"
        next
      end

      skill = SubskillSkill.find_or_initialize_by(name: name)
      is_new = skill.new_record?
      skill.category    = category if category.present?
      skill.description = desc      if desc.present?
      skill.active      = true      if is_new
      skill.position  ||= SubskillSkill.maximum(:position).to_i + 1

      if skill.save
        is_new ? created += 1 : updated += 1
        # Import level descriptions if present
        (1..5).each do |lvl|
          col_text = row["level_#{lvl}".to_sym]&.strip
          next if col_text.blank?
          ld = SubskillLevelDescription.find_or_initialize_by(subskill_skill_id: skill.id, level: lvl)
          ld.description = col_text
          ld.save
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

  def skill_params
    params.require(:subskill_skill).permit(
      :name, :category, :description, :position, :active,
      level_descriptions_attributes: [:id, :level, :description]
    )
  end

  def build_level_descriptions(skill)
    existing = skill.level_descriptions.index_by(&:level)
    (1..5).each do |lvl|
      skill.level_descriptions.build(level: lvl) unless existing[lvl]
    end
  end
end
