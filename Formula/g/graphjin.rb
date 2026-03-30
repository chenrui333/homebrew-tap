class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.14.5.tar.gz"
  sha256 "625e8828a59c269a8e14290aa72d21905bb5b2662c56301a5921fe06f8761a3a"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9732318935cc0eaa92e4b0999cb4b5903483dc3d45dbec3de8a1137f799a146e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e836d359fae8c1eb9e5a899894693a44b138d33a8c3500a3656ed4f0b24fea8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0539dcdcfacf3acbe97ee44f7e65dff08ff9ab842837917eaf7d37c3ac03e904"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57280f29a3825c949cb6b1d108534c5c67c82fff81dac39b21ad3fd0d85c2f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39baad763850d8c6da0afaffb06e18cc417ed71e59ee7d8075ee541fa18b676c"
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
