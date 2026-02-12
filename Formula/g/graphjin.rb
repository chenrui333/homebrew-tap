class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "b28820caf5081baa1521aa02b2562f6a3542b0e9937dd0598bbc4ea1b6c0cff6"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93512870d9b8a0b091f9d7f0d2f553c0b528abcb8e94ee0e88698a1325933c6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54d20258d83b2c13147c6329229c2274819424534da32dfc954dc079862767f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "768a5a00673fa712c4864615a17550df5415bcd65c49d07f74809d4b2290b604"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab61022923573b7928c543dea90fc2d5314fde59a3a3bd95baa1062b55a16bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79e3f38b06cbb2e7da800f4a34a75a4dd71db5b31d3638020a976fc7a0875d5e"
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
