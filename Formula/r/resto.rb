class Resto < Formula
  desc "Send pretty HTTP & API requests with TUI"
  homepage "https://github.com/abdfnx/resto"
  url "https://github.com/abdfnx/resto/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "6d5a1f773b8f21926af786123f436753c80bbea2e2970a96775c4996fd63760a"
  license "MIT"
  head "https://github.com/abdfnx/resto.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56225c6b935e9f64eb32b568878c58e6e3759936ccbea93a814b6fc47b6bc219"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56225c6b935e9f64eb32b568878c58e6e3759936ccbea93a814b6fc47b6bc219"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c39f45010c2f99bffa84b720e3f2a8fa60f2026bacee16ce6b0151353ad5edda"
    sha256 cellar: :any,                 x86_64_linux:  "df4bb346ced5152945dae378e65349d2229f97d5d39949866c0659b986e923ce"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Skip the post-command GitHub release check: it dereferences a nil response when offline
    inreplace "main.go", "checker.Check(version)", "_ = checker.Check"

    ldflags = "-s -w -X main.version=v#{version} -X main.versionDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"resto", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/resto version")

    system bin/"resto", "settings", "set", "show_update", "false"
    system bin/"resto", "settings", "set", "theme", "monokai"
    settings = (testpath/".resto/settings.json").read
    assert_match(/"show_update":\s*false/, settings)
    assert_match(/"theme":\s*"monokai"/, settings)
  end
end
