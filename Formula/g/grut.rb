class Grut < Formula
  desc "Terminal file explorer with Git and GitHub integration"
  homepage "https://github.com/jongio/grut"
  url "https://github.com/jongio/grut/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "791467840f9b3740ad2097614dcc17c527c61d2b1d367ddc2ebd609c23a7a681"
  license "MIT"
  head "https://github.com/jongio/grut.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1bd099dc3931141cf9e3292e1145861e94ba4b336f386dc7d69ce0769a2c374"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1bd099dc3931141cf9e3292e1145861e94ba4b336f386dc7d69ce0769a2c374"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c85cdf0d4c3f17697367c7b4aca9f183cfbda952a5e84c6f0ae49e2f731afbbe"
    sha256 cellar: :any,                 x86_64_linux:  "8d88b048e55d5a3f670dd0def7c9cd94ed646650878d006e3f8d5ea38120332a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/jongio/grut/internal/config.AppVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"grut", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grut --version")
    assert_equal [], JSON.parse(shell_output("#{bin}/grut keys --section homebrew-missing --json"))
    sections = JSON.parse(shell_output("#{bin}/grut keys --section filetree --json"))
    assert_equal "File Tree", sections.first.fetch("title")
    refute_empty sections.first.fetch("bindings")
  end
end
