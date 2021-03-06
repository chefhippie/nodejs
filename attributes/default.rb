#
# Cookbook Name:: nodejs
# Attributes:: default
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

default["nodejs"]["packages"] = value_for_platform_family(
  "debian" => value_for_platform(
    "debian" => { "default" => %w(
      nodejs
      nodejs-dev
      nodejs-legacy
    ) },
    "ubuntu" => { "default" => %w(
      nodejs
      nodejs-dev
      npm
    ) }
  ),
  "suse" => %w(
    nodejs
    nodejs-devel
  )
)

default["nodejs"]["install_npm"] = value_for_platform_family(
  "debian" => value_for_platform(
    "debian" => { "default" => true },
    "ubuntu" => { "default" => false }
  ),
  "suse" => false
)

case node["platform_family"]
when "suse"
  repo = case node["platform_version"]
  when /\A13\.\d+\z/
    "openSUSE_#{node["platform_version"]}"
  when /\A42\.\d+\z/
    "openSUSE_Leap_#{node["platform_version"]}"
  when /\A\d{8}\z/
    "Tumbleweed"
  else
    raise "Unsupported SUSE version"
  end

  default["nodejs"]["zypper"]["enabled"] = true
  default["nodejs"]["zypper"]["alias"] = "nodejs"
  default["nodejs"]["zypper"]["title"] = "Node.js"
  default["nodejs"]["zypper"]["repo"] = "http://download.opensuse.org/repositories/devel:/languages:/nodejs/#{repo}/"
  default["nodejs"]["zypper"]["key"] = "#{node["nodejs"]["zypper"]["repo"]}repodata/repomd.xml.key"
end
