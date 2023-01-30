# frozen_string_literal: true

namespace :delete do
  desc "Destroy all components for a given organization"
  task destroy_all: [
    :destroy_all_comments,
    :destroy_all_attachments,
    :destroy_all_accountability,
    :destroy_all_budgets,
    :destroy_all_proposals,
    :destroy_all_blogs,
    :destroy_all_debates,
    :destroy_all_meetings,
    :destroy_all_pages,
    :destroy_all_surveys,
    :destroy_all_assemblies,
    :destroy_all_participatory_processes,
    :destroy_all_users
  ]

  desc "Destroy all comments for a given organization"
  task destroy_all_comments: :environment do
    puts "Start destroy_all_comments of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"

    organization = decidim_find_organization
    return unless organization

    Decidim::Comments::Comment.transaction do
      Decidim::Comments::DestroyAllComments.call(organization)
    end

    puts "Finish destroy_all_comments of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"
  end

  desc "Destroy all accountability for a given organization"
  task destroy_all_accountability: :environment do
    puts "Start destroy_all_accountability of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"

    organization = decidim_find_organization
    return unless organization

    Decidim::Accountability::Result.transaction do
      Decidim::Accountability::DestroyAllResults.call(organization)
    end

    puts "Finish destroy_all_accountability of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"
  end

  desc "Destroy all attachments for a given organization"
  task destroy_all_attachments: :environment do
    puts "Start destroy_all_attachments of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"

    organization = decidim_find_organization
    return unless organization

    Decidim::Attachment.transaction do
      Decidim::DestroyAllAttachments.call(organization)
    end

    puts "Finish destroy_all_attachments of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"
  end

  desc "Destroy all budgets for a given organization"
  task destroy_all_budgets: :environment do
    puts "Start destroy_all_budgets of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"

    organization = decidim_find_organization
    return unless organization

    Decidim::Budgets::Budget.transaction do
      Decidim::Budgets::DestroyAllBudgets.call(organization)
    end

    puts "Finish destroy_all_budgets of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"
  end

  desc "Destroy all proposals for a given organization"
  task destroy_all_proposals: :environment do
    puts "Start destroy_all_proposals of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"

    organization = decidim_find_organization
    return unless organization

    Decidim::Proposals::Proposal.transaction do
      Decidim::Proposals::DestroyAllProposals.call(organization)
    end

    puts "Finish destroy_all_proposals of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"
  end

  desc "Destroy all blogs for a given organization"
  task destroy_all_blogs: :environment do
    puts "Start destroy_all_blogs of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"

    organization = decidim_find_organization
    return unless organization

    Decidim::Blogs::Post.transaction do
      Decidim::Blogs::DestroyAllPosts.call(organization)
    end

    puts "Finish destroy_all_blogs of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"
  end

  desc "Destroy all debates for a given organization"
  task destroy_all_debates: :environment do
    puts "Start destroy_all_debates of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"

    organization = decidim_find_organization
    return unless organization

    Decidim::Debates::Debate.transaction do
      Decidim::Debates::DestroyAllDebates.call(organization)
    end

    puts "Finish destroy_all_debates of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"
  end

  desc "Destroy all meetings for a given organization"
  task destroy_all_meetings: :environment do
    puts "Start destroy_all_meetings of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"

    organization = decidim_find_organization
    return unless organization

    Decidim::Meetings::Meeting.transaction do
      Decidim::Meetings::DestroyAllMeetings.call(organization)
    end

    puts "Finish destroy_all_meetings of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"
  end

  desc "Destroy all pages for a given organization"
  task destroy_all_pages: :environment do
    puts "Start destroy_all_pages of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"

    organization = decidim_find_organization
    return unless organization

    Decidim::Pages::Page.transaction do
      Decidim::Pages::DestroyAllPages.call(organization)
    end

    puts "Finish destroy_all_pages of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"
  end

  desc "Destroy all surveys for a given organization"
  task destroy_all_surveys: :environment do
    puts "Start destroy_all_surveys of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"

    organization = decidim_find_organization
    return unless organization

    Decidim::Surveys::Survey.transaction do
      Decidim::Surveys::DestroyAllSurveys.call(organization)
    end

    puts "Finish destroy_all_surveys of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"
  end

  desc "Destroy all assemblies for a given organization"
  task destroy_all_assemblies: :environment do
    puts "Start destroy_all_assemblies of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"

    organization = decidim_find_organization
    return unless organization

    Decidim::Assembly.transaction do
      Decidim::Assemblies::DestroyAllAssemblies.call(organization)
    end

    puts "Finish destroy_all_assemblies of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"
  end

  desc "Destroy all participatory_processes for a given organization"
  task destroy_all_participatory_processes: :environment do
    puts "Start destroy_all_participatory_processes of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"

    organization = decidim_find_organization
    return unless organization

    Decidim::ParticipatoryProcess.transaction do
      Decidim::ParticipatoryProcesses::DestroyAllParticipatoryProcesses.call(organization)
    end

    puts "Finish destroy_all_participatory_processes of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"
  end

  desc "Destroy all users for a given organization"
  task destroy_all_users: :environment do
    puts "Start destroy_all_users of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"

    organization = decidim_find_organization
    return unless organization

    Decidim::User.transaction do
      form = OpenStruct.new(valid?: true, delete_reason: "Testing")
      Decidim::User.where(organization: organization).find_each do |user|
        Decidim::Gamifications::DestroyAllBadges.call(organization, user)
        Decidim::Authorization.where(user: user).destroy_all
        puts "destroy user id: #{user.id}"
        Decidim::DestroyAccount.call(user, form)
      end
    end

    puts "Finish destroy_all_users of #{ENV["DECIDIM_ORGANIZATION_NAME"]}"
  end
end

private

def decidim_find_organization
  organization = Decidim::Organization.find_by(name: ENV["DECIDIM_ORGANIZATION_NAME"])

  unless organization
    puts "Organization not found: '#{ENV["DECIDIM_ORGANIZATION_NAME"]}'"
    puts "Usage: DECIDIM_ORGANIZATION_NAME=<organization name> rails delete::destroy_all_pages"
    return
  end

  organization
end
