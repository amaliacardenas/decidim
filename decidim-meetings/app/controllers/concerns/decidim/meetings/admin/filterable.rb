# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Meetings
    module Admin
      module Filterable
        extend ActiveSupport::Concern

        included do
          include Decidim::Admin::Filterable

          helper Decidim::Meetings::Admin::FilterableHelper

          private

          def base_query
            Meeting.not_hidden.where(component: current_component).order(start_time: :desc).page(params[:page]).per(15)
          end

          def filters
            [
              :type_eq,
              :is_upcoming_true,
              :scope_id_eq,
              :category_id_eq,
              :origin_eq,
              :closed_at_present
            ]
          end

          def filters_with_values
            {
              type_eq: meeting_types,
              scope_id_eq: scope_ids_hash(scopes.top_level),
              category_id_eq: category_ids_hash(categories.first_class),
              closed_at_present: %w(true false),
              is_upcoming_true: %w(true false),
              origin_eq: %w(participant official user_group)
            }
          end

          def search_field_predicate
            :id_string_or_title_cont
          end

          def meeting_types
            Meeting::TYPE_OF_MEETING
          end
        end
      end
    end
  end
end
