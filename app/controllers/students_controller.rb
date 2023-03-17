
class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    @students = Student.all

    respond_to do |format|
      format.html
      format.json {render json: @students}
    end
  end

  def search
    limit = params[:length].to_i
    offset = params[:start].to_i

    column_searches = []
    if params[:columns].present?
      params[:columns].each do |index, column|
        search_term = column[:search][:value].strip
        column_name = column[:data]
        column_searches << "#{column_name} LIKE '%#{search_term}%'" unless search_term.blank?
      end
      search_conditions = column_searches.join(" AND ")
      @students = Student.where(search_conditions)
                       .order("#{sort_column} #{sort_direction}")
    else
      @students = Student.order("#{sort_column} #{sort_direction}")
    end
    @student_count = @students.count
    @students = @students.limit(limit).offset(offset)
                       
    data = []
    @students.each do |record|
      data << [
        record["name"],
        record["register_no"],
        record["maths"],
        record["science"]
      ]
    end
    render json: {
      draw: params[:draw].to_i,
      recordsTotal: Student.count,
      recordsFiltered: @student_count,
      data: data
    }
  end
  
 

  def export
    ids = params[:selected].split(',')
    @selected_students = Student.where(id: ids)
    respond_to do |format|
      format.html
      format.csv { 
        csv_data = @selected_students.to_csv(['name', 'register_no', 'maths', 'science'])
        file_path = 'Export/'+Time.now.strftime("%m-%d-%Y_%H%M%S")+'students.csv'
        File.open(file_path, 'a') do |file|
        file.write(csv_data)
      end 
      send_data csv_data
    }
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render action: 'show', status: :created, location: @student }
      else
        format.html { render action: 'new' }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:name, :register_no, :maths, :science)
    end

    def sort_column
      keys = (0..5).to_a
      values = %w[name register_no maths science]
      hash = Hash[keys.zip(values)]
      hash.has_key?(params[:order]['0'][:column].to_i) ? hash[params[:order]['0'][:column].to_i] : 'id'
    end
    def sort_direction
      %w[asc desc].include?(params[:order]['0'][:dir]) ? params[:order]['0'][:dir].upcase : 'ASC'
    end
end
