namespace :synchronize do

  task :teams => :environment do
    SynchronizeTeams.call
  end

  task :charges => :environment do
    return unless Rails.env.production?
    ActivateCharges.call
  end

end