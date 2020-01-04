# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# default_service_provider_merge.rb
#

# ---- original file header ----
#
# @summary
#   Returns the default service provider for the system overridden by any parent class
#that has Service { provider => $my_service_provider } specified to cause an override.
#This is useful when we actually need to know the clients service provider and allow them
#to also override it in case they decide they need a different one due to puppet not picking
#the right one for their new or old Operating System.
#
#Also useful if we need to be able to send a service stop in order to do something
#life replacing a config or binary that cannot be replace while the service is running
#This can be done via another function, inline_template or exec, prior to letting puppet DSL
#complete it's usual state management of
#
#service { 'service' ensure => running }
#
#Usage possibilities below:
#
# $default_provider = default_service_provider_merge
# inline_template("<% Puppet::Type.type(:service).newservice(:name => 'service', :provider => #{default_provider}).provider.send('stop') %>")
#
# or:
#
# $default_provider = default_service_provider_merge
# exec { 'stop_this_service':
#   command => "puppet resource service ${service_name} provider=${default_provider} ensure=stopped",
#   path    => $::path
# }
#
# or:
#
# # This method is 0.4 seconds faster than the Puppet Face (puppet resource service) method above but may be less supported?
# $default_provider = default_service_provider_merge
# exec { 'stop_this_service':
#   command => "ruby -r 'puppet' -e "Puppet::Type.type(:service).newservice(:name => 'service', :provider => ${default_provider}).provider.send('stop')"",
#   path    => $::path
# }
#
#
#
Puppet::Functions.create_function(:'sfu_stdlib::default_service_provider_merge') do
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
    
    #override = scope.lookupdefaults('Service')[:provider].instance_variable_get(:@value)
    override = self.lookupdefaults('Service')[:provider].instance_variable_get(:@value)
    override = lookupvar('service_provider') if override.nil? || override.empty?

    return override
  
  end
end