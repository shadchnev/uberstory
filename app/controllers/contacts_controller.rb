class ContactsController < ApplicationController
  
  def new
    @contact = Contact.new
  end
  
  def create
    @contact = Contact.new(params[:contact])
    @contact.user = current_user
    if @contact.save
      flash[:notice] = "thank you"
      redirect_to new_contact_url
    else
      flash[:notice] = "there were errors"
      render :new
    end
  end
  
end
