class ContactsController < ApplicationController
  
  def index
    @contact = Contact.new
  end
  
  def create
    @contact = Contact.new(params[:contact])
    @contact.user = current_user
    if @contact.save
      flash[:notice] = "thank you"
      redirect_to contacts_url
    else
      flash[:notice] = "there were errors"
      render :contacts
    end
  end
  
end
