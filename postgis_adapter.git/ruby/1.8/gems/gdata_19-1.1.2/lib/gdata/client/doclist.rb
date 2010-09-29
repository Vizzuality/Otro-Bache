# encoding: UTF-8
# Copyright (C) 2008 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module GData
  module Client
    
    # Client class to wrap working with the Documents List Data API.
    class DocList < Base
      
      def initialize(options = {})
        options[:clientlogin_service] ||= 'writely'
        options[:authsub_scope] ||= 'http://docs.google.com/feeds/'
        super(options)
      end
    end
  end
end