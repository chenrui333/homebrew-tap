class PicoclawAfjcjsbx < Formula
  desc "Actively maintained PicoClaw fork with local and cloud AI agents"
  homepage "https://github.com/afjcjsbx/picoclaw"
  url "https://github.com/afjcjsbx/picoclaw.git",
      tag:      "v0.5.5",
      revision: "9881ed49da20860fed25acd189d2c922c4f17200"
  license "MIT"
  head "https://github.com/afjcjsbx/picoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "1c79f4e60920888ae9ef490bdcfb50eb477c25d59b203256a97d772d7972e1d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09524cd8df262d784ad481eaa01e80b9d2c702510cc14b5ff11a375e4309041b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09524cd8df262d784ad481eaa01e80b9d2c702510cc14b5ff11a375e4309041b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c57c9e8ff04f736476711e0e083600f64182b05ea7be63d8a10f4c70738c374e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce2602c47ce63eaba3f283442e6d918e7e7b207f7673d6e04b836c280ef2d090"
  end

  depends_on "go" => :build

  conflicts_with "picoclaw", because: "both install a picoclaw executable"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/sipeed/picoclaw/pkg/config.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"picoclaw", ldflags:), "-tags=goolm,stdjson", "./cmd/picoclaw"
    generate_completions_from_executable(bin/"picoclaw", shell_parameter_format: :cobra)
  end

  def caveats
    <<~EOS
      This is afjcjsbx's maintained fork, not sipeed/picoclaw.
      Run `picoclaw onboard` to create your configuration and embedded workspace.
      Provider credentials and local model downloads are configured at runtime.
      This formula installs the CLI and gateway, not the separate web launcher.
    EOS
  end

  service do
    run [opt_bin/"picoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/picoclaw version")
    system bin/"picoclaw", "--no-color", "onboard"
    (testpath/".picoclaw/config.json").atomic_write "{not-json\n"
    # Upstream status reports config parse errors without a nonzero exit.
    output = shell_output("#{bin}/picoclaw --no-color status")
    assert_match "Error loading config:", output
    assert_match "invalid character", output
  end
end
