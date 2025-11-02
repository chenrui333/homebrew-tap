class GoEagle < Formula
  desc "Go framework for the API or Microservice"
  homepage "https://github.com/go-eagle/eagle"
  url "https://github.com/go-eagle/eagle/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "480e8106fe50127a4e5329cc5d09909cc2d7b48dfee80d6681679f483b3c560e"
  license "MIT"
  head "https://github.com/go-eagle/eagle.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    cd "cmd/eagle" do
      system "go", "build", *std_go_args(ldflags:, output: bin/"eagle")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eagle --version")

    system bin/"eagle", "new", "testapp"
    assert_path_exists testpath/"testapp"
  end
end
