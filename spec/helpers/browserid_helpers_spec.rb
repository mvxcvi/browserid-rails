require 'spec_helper'

describe BrowserID::Rails::Helpers do
  describe '#setup_browserid' do
    it "includes persona javascript shim"

    context "when authenticated" do
      it "calls setup with current user"
    end

    context "when not authenticated" do
      it "calls setup without current user"
    end
  end

  describe '#login_link' do
    let(:link) { helper.login_link }

    describe "text" do
      let(:text) { link_text(link) }

      it "has a default value" do
        text.should_not be_blank
      end

      it "is configurable" do
        browserid_config.login_link.text = "Login with Persona"
        text.should eq("Login with Persona")
      end

      it "can be set with the first argument" do
        text = link_text(helper.login_link("FooBarBaz"))
        text.should eq("FooBarBaz")
      end
    end

    describe "target" do
      let(:target) { link_attributes(link)['href'] }

      it "defaults to URL fragment" do
        target.should eq('#')
      end

      it "is configurable" do
        browserid_config.login_link.target = "/login/path"
        target.should eq("/login/path")
      end
    end

    describe "css classes" do
      subject(:classes) { link_attributes(link)['class'].scan(/\w+/) }

      it { should include('browserid_login') }
    end
  end

  describe '#logout_link' do
    let(:link) { helper.logout_link }

    describe "text" do
      let(:text) { link_text(link) }

      it "has a default value" do
        text.should_not be_blank
      end

      it "is configurable" do
        browserid_config.logout_link.text = "Log out of Persona"
        text.should eq("Log out of Persona")
      end

      it "can be set with the first argument" do
        text = link_text(helper.logout_link("FooBarBaz"))
        text.should eq("FooBarBaz")
      end
    end

    describe "target" do
      let(:target) { link_attributes(link)['href'] }

      it "defaults to URL fragment" do
        target.should eq('#')
      end

      it "is configurable" do
        browserid_config.logout_link.target = "/logout/path"
        target.should eq("/logout/path")
      end
    end

    describe "css classes" do
      subject(:classes) { link_attributes(link)['class'].scan(/\w+/) }

      it { should include('browserid_logout') }
    end
  end



  # Extracts the link text from a tag.
  def link_text(tag)
    $1 if tag =~ /<a[^>]*>([^<>]*)<\/a>/
  end

  # Extracts the attributes from a tag.
  def link_attributes(tag)
    Hash[$1.scan(/(\w+)="([^"]*)"/)] if tag =~ /<a([^>]*)>[^<>]*<\/a>/
  end
end
