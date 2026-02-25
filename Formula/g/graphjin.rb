class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "1fdceb689814fafe94789347a2ecba32278c00c2a5153e05bad4abc23c680333"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1079356338abb184f6e5046174b915c824b5216cd809eaeaf7122bed90952279"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80451948c3b09399f3714f74f44b26e1bc572ee2305458aacd8e4a2c364c5360"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "872d7278ac63699fec2890d186129f8ce83fe8f940a43ffab7b2b4257b7d21d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf898a12722fe01614894d3b86e98de10df2ba27303328e9d051c675cbae74c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "716b897dae0289f31f1238f48995fdaad0786aeb87e2567e49e4c7ab3add1667"
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
