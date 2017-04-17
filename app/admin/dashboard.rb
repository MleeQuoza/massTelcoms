ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    columns do
      column do
        panel 'Unpaid Donations' do
          table do
            thead do
              tr do
                %w(Date Reporter Donor Amount Re-assign Remove).each &method(:th)
              end
            end
            tbody do
              MoneyTransaction.where(status: 3).each do |mt|
                tr do
                  [mt.updated_at.strftime('%F'),
                   mt.withdrawal_user_name,
                   mt.donation_user_name,
                   mt.amount,
                   link_to('Re-assign', reassign_admin_money_transaction_path(mt),
                           method: :patch),
                   link_to('Remove', remove_admin_money_transaction_path(mt),
                           method: :patch)].each &method(:td)
                end
              end
            end
          end
        end
      end
    end
  
    
    
    


    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
