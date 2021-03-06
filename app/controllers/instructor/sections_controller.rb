class Instructor::SectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_authorized_for_current_course, only: [:create]
  before_action :require_authorized_for_current_section, only: [:update]


  def create
    @section = current_course.sections.create(section_params)
    if @section.valid?
      redirect_to instructor_course_path(@current_course)
    else
      redirect_to instructor_course_path(@current_course, save_failed: true)
    end
  end

  def update
    current_section.update_attributes(section_params)
    render text: 'updated!'
  end

  private
  
  def require_authorized_for_current_section
    if current_section.user != current_user
      return render text: 'Unauthorized', status: :Unauthorized
    end
  end

  def require_authorized_for_current_course
    if current_course.user != current_user
      render text: "Unauthorized", status: :unauthorized
    end
  end

  helper_method :current_course
  def current_course
    if params[:course_id].present?
      @current_course ||= Course.find(params[:course_id])
    else
      current_section.course_id
    end
  end

  def section_params
    params.require(:section).permit(:title, :row_order_position)
  end
end
