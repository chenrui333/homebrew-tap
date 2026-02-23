class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.11.2.tar.gz"
  sha256 "5ce41bf9a6d0c95478b304bf0d446d1e48fcd88248b165939c8f66b266b6a4b9"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e793b0dd31fe336ae796dcc3a0fe61d8b9a5a96a6617e49888f793e399d64e87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "068183c4b39917a3bc9f970f4e55ff815f461d44a01354263b6e79ae591e64f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7eda1a43b489e4041c44fb471bb4b082af9a371e8aba324cd647097b58776107"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c74a2a3192f7175b8bd8c99826247e67419c19873a666481b2d2b2ff46f88800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f421aa43e8237296c410248440c70eec3dfef2a880d510fdb925acfaefba2c3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
