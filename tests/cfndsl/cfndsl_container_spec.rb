require 'spec_helper'

describe "Container" do

  before(:all) do
    @image = Docker::Image.build_from_dir($project_root)

    set :docker_image, @image.id
  end

  describe 'when running' do
    before(:all) do
      @container = Docker::Container.create(
          'Image' => @image.id,
          'Cmd' => ['bash']
      )
      @container.start()

      set :docker_container, @container.id
    end

    it "runs alpine version 3.4" do
      expect(file('/etc/os-release')).to be_a_file
      os_version = command('cat /etc/os-release')
      expect(os_version.stdout).to include('PRETTY_NAME="Alpine Linux v3.4"')
    end

    it "has the declared version of cfndsl installed" do
      version = command('gem list cfndsl')
      expect(version.stdout).to include('0.11.6')
    end

    requiredPackages = %w(
        bash
        groff
        less
        curl
        jq
        build-base
        ruby-dev
        ruby
        ruby-io-console
    )

    requiredPackages.each { |apkPackage|
      describe package(apkPackage) do
        it { is_expected.to be_installed }
      end
    }

    after(:all) do
      @container.kill
      @container.delete(:force => true)
    end
  end
end
