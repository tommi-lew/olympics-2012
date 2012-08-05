helpers do
  def partial(page, options={ })
    haml page.to_sym, options.merge!(:layout => false)
  end
end
