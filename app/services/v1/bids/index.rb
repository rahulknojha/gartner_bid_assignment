class V1::Bids::Index

	def initialize(countries:, categories:, channels: )
		@countries = countries.split(',')
		@channels = channels.split(',')
		@categories = categories.split(',')
	end


	def call
		return [] unless valid?


		((@countries.product(@categories)).product(@channels)).map(&:flatten).each_with_object([]) do |condition, response|
			response << {
				country: condition[0] ,
				category: condition[1],
				channel: condition[2],
				amount: fetch_amount(condition)
			}
		end
	end


	private

	# Querying all relevant data at once to avoid multiple hits to database
	def bids
		@bids ||= Bid.where(
			"country IN (?) AND category IN (?) AND channel IN (?)",
			@countries.push('*'), @categories.push('*'), @channels.push('*')
		) 
  end

	def fetch_amount(condition)
	  selected_bids = bids.select do |bid|
	  	([condition[0], '*'].include?(bid.country) &&
	  		[condition[1], '*'].include?(bid.category) &&
	  		[condition[2], '*'].include?(bid.channel))
	  end

	  return selected_bids[0].amount if selected_bids.length == 1

    find_best_match(condition, selected_bids)
	end

	# Finding best match to the condition
	# First priority is given to exact match 
	# Second priorty is given to exact match of country and category
	# Third priority is given to exact match of country
	# At last look for * in all column 
	def find_best_match(condition, selected_bids, iteration=1)
		matched_bid = selected_bids.find do|selected_bid|
			selected_bid.country == condition[0] &&
			selected_bid.category == condition[1] && 
			selected_bid.channel == condition[2]
		end

		return matched_bid.amount if matched_bid.present?

		return nil if condition.tally['*'] == 3
		condition[condition.length - iteration] = '*'
		find_best_match(condition, selected_bids, iteration + 1)
	end

	def valid?
		@countries.present? && @categories.present? && @channels.present?
	end
end