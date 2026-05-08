class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.14.tar.gz"
  sha256 "eedee8763dbf42774f8baf66964b466ed83623e7a1a84c206e5ec8ff15c07c0a"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22e8533a07a2b256266a7a6fd9bf77b08e0b06590c5a51e1faaa853de3f2322e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f94cbb22ca4e79028bca0d12547a5537f8410a605f074de3a0b6685f88615175"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce8079c2adab7be6ecfa6e84ec4ffd289e84858f296dcc0a432ba517a5fed88c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02157b240a1109101017b22025de2ce3022477c9990db03a6afc0f0673ff1593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aeafee27d155d94a9044c977ef39dad77dd0a67cb60a34e6d168416ef31e84c9"
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
