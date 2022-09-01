namespace :hyku do
  desc 'reset work and collection data across all tenants'
  task works_and_collections: [:environment] do
    confirm('You are about to delete all works and collections across all accounts, this is not reversable!')
    Account.find_each do |account|
      switch!(account)
      Rake::Task["hyrax:reset:works_and_collections"].reenable
      Rake::Task["hyrax:reset:works_and_collections"].invoke
    end
  end

  def confirm(action)
    return if ENV['RESET_CONFIRMED'].present?
    confirm_token = rand(36**6).to_s(36)
    STDOUT.puts "#{action} Enter '#{confirm_token}' to confirm:"
    input = STDIN.gets.chomp
    raise "Aborting. You entered #{input}" unless input == confirm_token
    ENV['RESET_CONFIRMED'] = 'true'
  end
end
