class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.14.1.tar.gz"
  sha256 "1547eb52da7420fec410af690be831f0b588eb0f21cbc4347965c651982833a9"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d3127b4bd380f22a07f72b4188a65b2f7f890059b10efa75a0ae5fbb16491ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "147359511eddb7812a560bc8764cc0a206b4021062daff75f4ab28edf8fb50b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02b95f4f7fb0491d43946e65ceb425e0e400a5e96baa4c45dbb0cce153604151"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3157ea9385fe30bf36a16d0737d572229871a9e66685c0391fa13e6a00f029f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d563a09e0ec176242e1da14a26997806e664a82e3a1edf8428b78ffe9ffaeb7"
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
