Facter.add(:service_provider) do
  setcode do
    Puppet::Type.type(:service).newservice(:name => 'anyservice')[:provider].to_s
  end
end

