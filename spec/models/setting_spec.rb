#-- encoding: UTF-8
#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2018 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See docs/COPYRIGHT.rdoc for more details.
#++

require 'spec_helper'

describe Setting, type: :model do
  # OpenProject specific defaults that are set in settings.yml
  describe "OpenProject's default settings" do
    it 'has OpenProject as application title' do
      expect(Setting.app_title).to eq 'AviaSales'
    end

    it 'allows users to register themselves' do
      expect(Setting.self_registration?).to be_truthy
    end

    it 'allows anonymous users to access public information' do
      expect(Setting.login_required?).to be_falsey
    end
  end

  describe 'language can be updated to Russian' do
    context "setting doesn't exist in the database" do
      before do
        Setting.default_language = 'ru'
      end

      it 'sets the setting' do
        expect(Setting.default_language).to eq 'ru'
      end

      it 'stores the setting' do
        expect(Setting.find_by(name: 'default_language').value).to eq 'ru'
      end

      after do
        Setting.find_by(name: 'default_language').destroy
      end
    end

    context 'setting already exist in the database' do
      before do
        Setting.default_language = 'en'
        Setting.default_language = 'ru'
      end

      it 'sets the setting' do
        expect(Setting.default_language).to eq 'ru'
      end

      it 'stores the setting' do
        expect(Setting.find_by(name: 'default_language').value).to eq 'ru'
      end

      after do
        Setting.find_by(name: 'default_language').destroy
      end
    end
  end
end
