#
# default_service_provider_merge.rb
#

module Puppet::Parser::Functions
  newfunction(:default_service_provider_merge, :type => :rvalue, :doc => <<-EOS
Returns the default service provider for the system overridden by any parent class
that has Service { provider => $my_service_provider } specified to cause an override.
This is useful when we actually need to know the clients service provider and allow them
to also override it in case they decide they need a different one due to puppet not picking
the right one for their new or old Operating System.

Also useful if we need to be able to send a service stop in order to do something
life replacing a config or binary that cannot be replace while the service is running
This can be done via another function, inline_template or exec, prior to letting puppet DSL
complete it's usual state management of

service { 'service' ensure => running }

Usage possibilities below:

 $default_provider = default_service_provider_merge
 inline_template("<% Puppet::Type.type(:service).newservice(:name => 'service', :provider => \#{default_provider}).provider.send('stop') %>")

 or:

 $default_provider = default_service_provider_merge
 exec { 'stop_this_service':
   command => "puppet resource service ${service_name} provider=${default_provider} ensure=stopped",
   path    => $::path
 }

 or:

 # This method is 0.4 seconds faster than the Puppet Face (puppet resource service) method above but may be less supported?
 $default_provider = default_service_provider_merge
 exec { 'stop_this_service':
   command => "ruby -r 'puppet' -e \"Puppet::Type.type(:service).newservice(:name => 'service', :provider => ${default_provider}).provider.send('stop')\"",
   path    => $::path
 }

    EOS
  ) do |args|
    #override = scope.lookupdefaults('Service')[:provider].instance_variable_get(:@value)
    override = self.lookupdefaults('Service')[:provider].instance_variable_get(:@value)
    override = lookupvar('service_provider') if override.nil? || override.empty?

    return override
  end
end

# vim: set ts=2 sw=2 et :

