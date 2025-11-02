class GoEagle < Formula
  desc "Go framework for the API or Microservice"
  homepage "https://github.com/go-eagle/eagle"
  url "https://github.com/go-eagle/eagle/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "480e8106fe50127a4e5329cc5d09909cc2d7b48dfee80d6681679f483b3c560e"
  license "MIT"
  head "https://github.com/go-eagle/eagle.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fdcc789585d0dcaabcb9e7ae85d08557797344b859ce6255a48e46b826831c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fdcc789585d0dcaabcb9e7ae85d08557797344b859ce6255a48e46b826831c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fdcc789585d0dcaabcb9e7ae85d08557797344b859ce6255a48e46b826831c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0bb1c23d585098939ae1d5f4413dd85dae37c81323b2f93e0b5ef490c92e075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f260963fcd3feb3e22118581df64971ed8bd8b068207932e78c90b172fd3c419"
  end

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
