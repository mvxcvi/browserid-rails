require 'spec_helper'

describe BrowserID::Rails::Helpers do
  let(:link_regex) { %r{<a([^>]*)>([^<]*)</a>} }

  # Extracts the link text from a tag.
  def link_text(tag)
    $2 if tag =~ link_regex
  end

  # Extracts the attributes from a tag.
  def link_attributes(tag)
    Hash[$1.scan(/(\w+)="([^"]*)"/)] if tag =~ link_regex
  end

  ##### SPEC EXAMPLES #####

  describe '#login_link' do
    let(:link) { helper.login_link }

    it "should be a link" do
      link.should match link_regex
    end

    describe "text" do
      let(:text) { link_text(link) }

      it "has a default value" do
        text.should_not be_blank
      end

      it "is configurable" do
        config_tx browserid_config.login, :text, "Login with Persona" do
          text.should eq("Login with Persona")
        end
      end

      it "can be set with the first argument" do
        text = link_text(helper.login_link("FooBarBaz"))
        text.should eq("FooBarBaz")
      end
    end

    describe "target" do
      let(:target) { link_attributes(link)['href'] }

      it "defaults to URL fragment" do
        config_tx browserid_config.login, :path, nil do
          target.should eq('#')
        end
      end

      it "is configurable" do
        config_tx browserid_config.login, :path, "/login/path" do
          target.should eq("/login/path")
        end
      end
    end

    describe "css classes" do
      subject(:classes) { link_attributes(link)['class'].scan(/\w+/) }

      it { should include('browserid_login') }
    end
  end

  describe '#logout_link' do
    let(:link) { helper.logout_link }

    it "should be a link" do
      link.should match link_regex
    end

    describe "text" do
      let(:text) { link_text(link) }

      it "has a default value" do
        text.should_not be_blank
      end

      it "is configurable" do
        config_tx browserid_config.logout, :text, "Log out of Persona" do
          text.should eq("Log out of Persona")
        end
      end

      it "can be set with the first argument" do
        text = link_text(helper.logout_link("FooBarBaz"))
        text.should eq("FooBarBaz")
      end
    end

    describe "target" do
      let(:target) { link_attributes(link)['href'] }

      it "defaults to URL fragment" do
        config_tx browserid_config.logout, :path, nil do
          target.should eq('#')
        end
      end

      it "is configurable" do
        config_tx browserid_config.logout, :path, "/logout/path" do
          target.should eq("/logout/path")
        end
      end
    end

    describe "css classes" do
      subject(:classes) { link_attributes(link)['class'].scan(/\w+/) }

      it { should include('browserid_logout') }
    end
  end

#  describe '#setup_browserid' do
#    it "includes the Persona javascript shim" do
#      text = helper.setup_browserid
#      text.should match %r{<script src="https://login.persona.org/include.js"></script>}
#    end
#
#    context "with options" do
#      let(:text) { helper.setup_browserid login_path: "/login/path", logout_path: "/logout/path", debug: true }
#
#      it "sets the loginPath" do
#        text.should match %r{browserid.loginPath = "/login/path";}
#      end
#
#      it "sets the logoutPath" do
#        text.should match %r{browserid.logoutPath = "/logout/path";}
#      end
#
#      it "sets debug mode" do
#        text.should match %r{browserid.debug = true;}
#      end
#    end
#
#    context "when authenticated" do
#      it "calls setup with current user"
#    end
#
#    context "when not authenticated" do
#      it "calls setup without current user"
#    end
#  end
end
