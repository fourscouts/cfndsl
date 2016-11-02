require 'spec_helper'

describe "The Docker image built by" do

  before(:all) do
    @image = Docker::Image.build_from_dir($project_root)

    set :docker_image, @image.id
  end

  describe 'the Dockerfile' do
    it "doesn't expose any ports" do
      expect(@image.json['ContainerConfig']['ExposedPorts']).to match(nil)
    end

    it "doesn't declare volumes" do
      expect(@image.json['ContainerConfig']['Volumes']).to match(nil)
    end
  end


  after(:all) do
    #@image.remove(:force => true)
  end

end
