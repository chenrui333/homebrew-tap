class PicoclawAfjcjsbx < Formula
  desc "Actively maintained PicoClaw fork with local and cloud AI agents"
  homepage "https://github.com/afjcjsbx/picoclaw"
  url "https://github.com/afjcjsbx/picoclaw/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "0ee6036e5fa3c97476e1e5972b4a4898c7ba074b36a3866974a5e1c484594c8e"
  license "MIT"
  head "https://github.com/afjcjsbx/picoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18bcf22c4dded812c1295d6345eab43e28ef4640e93ed3faed8d4ce668a8af83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18bcf22c4dded812c1295d6345eab43e28ef4640e93ed3faed8d4ce668a8af83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "934ccbcc8e460a893ef96c4b2323b4a93046e11c30390ddbce4d2dbdf17c9377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6de8183ed0b59eaadfee231cd1852e4b68bcdb8499a5448144fc3c7cf9ec2521"
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
