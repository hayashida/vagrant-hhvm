#
# Cookbook Name:: hhvm
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{hop5 nginx}.each do |repo|
	yum_repository repo do
		description node['yum'][repo]['description']
		baseurl node['yum'][repo]['baseurl']
		enabled node['yum'][repo]['enabled']
		gpgcheck node['yum'][repo]['gpgcheck']
		sslverify node['yum'][repo]['sslverify']
		action :create
	end
end

package "hhvm" do
	action :install
	options "--enablerepo=hop5"
end

package "nginx" do
	action :install
	options "--enablerepo=nginx"
end

service "iptables" do
	action [:disable, :stop]
end

service "nginx" do
	supports :status => true, :restart => true, :reload => true
	action [:start, :enable]
end

service "hhvm" do
	supports :status => true, :restart => true, :reload => true
	action [:start, :enable]
end

template "/etc/hhvm/config.hdf" do
	source "config.hdf.erb"
	mode 0644
	owner "root"
	group "root"
	notifies :restart, "service[hhvm]"
end

template "/etc/nginx/conf.d/hhvm.conf" do
	source "hhvm.conf.erb"
	mode 0644
	owner "root"
	group "root"
	notifies :restart, "service[nginx]"
end
