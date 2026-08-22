class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.37.tar.gz"
  sha256 "0a99826b427b13b1bfb6469b7ef0af8595f3e0069874ad18c49e3901266caa71"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4c53ba728dedf9ead6f4cec7de5db85babf85e0c8e922adce51e098c2dff6a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38a807037a976f35ce0be1e520956b8c224a2892b0030f0e46639675ff601ce9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f6f749d74d34f13842705bd40cd98cf3634e90c011c78020f35adb737c45548"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a8997a2d7d689a6006a6e6b09ba925636109be902f11f73185804f1a25a7753"
    sha256 cellar: :any,                 x86_64_linux:  "15dff3291b8dc1f6dae1c3a1a3e947ee2200cdd43fa06600387dd7d536fd1b58"
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

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
