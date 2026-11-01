class PicoclawAfjcjsbx < Formula
  desc "Actively maintained PicoClaw fork with local and cloud AI agents"
  homepage "https://github.com/afjcjsbx/picoclaw"
  url "https://github.com/afjcjsbx/picoclaw/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "d715943832c97957f1a342b771ab52d7c7391fdc8bf6ccfd93f311fa1e3d084c"
  license "MIT"
  head "https://github.com/afjcjsbx/picoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7f6576234c7ed7d9b55afcc53bcf899566641ae09d80cfe3e7c841352beadef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7f6576234c7ed7d9b55afcc53bcf899566641ae09d80cfe3e7c841352beadef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c02ac9adbc2d265094e9f9339c2b2dd7a2808a2d0334f902663e90241818ca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73afef638dd05039e174dbd51ac34c1b0dc73c934c330958ef138969f8b16496"
  end

  depends_on "go" => :build

  conflicts_with "picoclaw", because: "both install a picoclaw executable"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X github.com/sipeed/picoclaw/pkg/config.Version=#{version}"
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
