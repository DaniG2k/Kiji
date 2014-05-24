class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    if @contact.valid?
      flash[:notice] = 'Thank you for your message. We will contact you soon!'
    else
      flash[:error] = 'Cannot send message.'
      render :new
    end
  end
end
