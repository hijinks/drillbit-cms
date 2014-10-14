module Drillbit
	class User < DrillbitUser
		authenticates_with_sorcery!
	end
end