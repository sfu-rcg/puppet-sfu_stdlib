# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----

# ---- original file header ----
#
# @summary
#       Merges two or more hashes together into an array of hashes and returns the resulting hash merges inside an array.
#
#    For example:
#
#        $hash1 = [{'name' => 'testrule', 'value', => 'testvalue'}, {'name' => 'secondtestrule', 'value' => 'secondtestvalue', 'three' => 'losingthree'}]
#        $hash2 = {'two' => 'dos', 'three', => 'tres'}
#        $merged_hash = merge($hash1, $hash2)
#        # The resulting hash is equivalent to:
#        # $merged_hash =  [{'name' => 'testrule', 'value' => 'testvalue', 'two' => 'dos', 'three' => 'tres'}, {'name' => 'secondtestrule', 'value' => 'secondtestvalue', 'two' => 'dos', 'three' => 'tres'}]
#
#    When there is a duplicate key, the key in the rightmost hash will "win."
#
#
#
Puppet::Functions.create_function(:'sfu_stdlib::merge_array_of_hash') do
  # @param args
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :args
  end


  def default_impl(*args)
    

    if args.length < 2
      raise Puppet::ParseError, ("merge(): wrong number of arguments (#{args.length}; must be at least 2)")
    end

    hash_array = args[0]

    # This is just incase they happen to pass us a hash that's not in an array as their source hash
    hash_array = [hash_array] unless hash_array.is_a?(Array)

    result = Array.new

    hash_array.each do |arr|
      next if arr.is_a? String and arr.empty? # empty string is synonym for puppet's undef
      unless arr.is_a?(Hash)
        raise Puppet::ParseError, "merge: unexpected argument type #{arr.class}, only expects hash arguments"
      end
      # Swap args[0] so that we place each hash, one at a time, into the merge loop
      args[0] = arr
      # The hash we accumulate into
      accumulator = Hash.new
      # Merge into the accumulator hash
      args.each do |arg|
        next if arg.is_a? String and arg.empty? # empty string is synonym for puppet's undef
        unless arg.is_a?(Hash)
          raise Puppet::ParseError, "merge: unexpected argument type #{arg.class}, only expects hash arguments"
        end
        accumulator.merge!(arg)
      end
      # Place the fully merged hash into the array
      result << accumulator
    end
    return result
  
  end
end