class PicoclawAfjcjsbx < Formula
  desc "Actively maintained PicoClaw fork with local and cloud AI agents"
  homepage "https://github.com/afjcjsbx/picoclaw"
  url "https://github.com/afjcjsbx/picoclaw.git",
      tag:      "v0.5.6",
      revision: "43001a01030a87d025625b147fdbc1d304ff2f55"
  license "MIT"
  head "https://github.com/afjcjsbx/picoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "02b5f8e68a03432d4581c14458e04c7efa8761f868911e24d21e11c54338c114"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d78ddb8b489b7798f41fb3abc2d802a4ba1c512e89665bdf5d3bf1b0b880156c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d78ddb8b489b7798f41fb3abc2d802a4ba1c512e89665bdf5d3bf1b0b880156c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac57437422116bafc85d22057e5989db636f2b96de9b69ef2c03bd01ca242a72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13d217a5fb21309ea1ad3d32729fdafc6ca6de86c5d9a5966c0f68113fcc68f8"
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
