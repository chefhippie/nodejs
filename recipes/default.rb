#
# Cookbook Name:: nodejs
# Recipe:: default
#
# Copyright 2013-2014, Thomas Boerger <thomas@webhippie.de>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node["platform_family"]
when "suse"
  include_recipe "zypper"

  zypper_repository node["nodejs"]["zypper"]["alias"] do
    uri node["nodejs"]["zypper"]["repo"]
    key node["nodejs"]["zypper"]["key"]
    title node["nodejs"]["zypper"]["title"]

    action :add
  end
end

node["nodejs"]["packages"].each do |name|
  package name do
    action :install
  end
end

case node["platform_family"]
when "debian"
  remote_file ::File.join(Chef::Config[:file_cache_path], "npm-install") do
    source "https://www.npmjs.org/install.sh"
    action :create_if_missing

    only_if do
      node["nodejs"]["install_npm"]
    end
  end

  bash "npm_install" do
    code <<-EOH
      clean=yes bash npm-install
    EOH

    cwd Chef::Config[:file_cache_path]
    action :run

    not_if do
      ::File.exists? "/usr/bin/npm"
    end
  end
end
