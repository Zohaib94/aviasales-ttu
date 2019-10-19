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

describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  describe 'a user with a long login (<= 256 chars)' do
    let(:login) { 'a' * 256 }
    it 'is valid' do
      user.login = login
      expect(user).to be_valid
    end

    it 'may be loaded from the database' do
      user.login = login
      expect(user.save).to be_truthy

      expect(User.find_by_login(login)).to eq(user)
      expect(User.find_by_unique(login)).to eq(user)
    end
  end

  describe 'a user with an invalid login' do
    let(:login) { 'me' }

    it 'is invalid' do
      user.login = login
      expect(user).not_to be_valid
    end
  end

  describe 'a user with and overly long login (> 256 chars)' do
    it 'is invalid' do
      user.login = 'a' * 257
      expect(user).not_to be_valid
    end

    it 'may not be stored in the database' do
      user.login = 'a' * 257
      expect(user.save).to be_falsey
    end
  end

  describe 'login whitespace' do
    before do
      user.login = login
    end

    context 'simple spaces' do
      let(:login) { 'a b  c' }

      it 'is valid' do
        expect(user).to be_valid
      end

      it 'may be stored in the database' do
        expect(user.save).to be_truthy
      end
    end

    context 'line breaks' do
      let(:login) { 'ab\nc' }

      it 'is invalid' do
        expect(user).not_to be_valid
      end

      it 'may not be stored in the database' do
        expect(user.save).to be_falsey
      end
    end

    context 'tabs' do
      let(:login) { 'ab\tc' }

      it 'is invalid' do
        expect(user).not_to be_valid
      end

      it 'may not be stored in the database' do
        expect(user.save).to be_falsey
      end
    end
  end

  describe 'login symbols' do
    before do
      user.login = login
    end

    %w[+ _ . - @].each do |symbol|
      context symbol do
        let(:login) { "foo#{symbol}bar" }

        it 'is valid' do
          expect(user).to be_valid
        end

        it 'may be stored in the database' do
          expect(user.save).to be_truthy
        end
      end
    end

    context 'combination thereof' do
      let(:login) { 'the+boss-is@the_house.' }

      it 'is valid' do
        expect(user).to be_valid
      end

      it 'may be stored in the database' do
        expect(user.save).to be_truthy
      end
    end

    context 'with invalid symbol' do
      let(:login) { 'invalid!name' }

      it 'is invalid' do
        expect(user).not_to be_valid
      end

      it 'may not be stored in the database' do
        expect(user.save).to be_falsey
      end
    end
  end
end
