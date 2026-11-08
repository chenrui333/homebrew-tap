class OtelTui < Formula
  desc "Terminal OpenTelemetry viewer"
  homepage "https://github.com/ymtdzzz/otel-tui"
  url "https://github.com/ymtdzzz/otel-tui/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "fc8a5ab4416b9428532978cb759b31f83bc27e8617e44545c53fb41d401a3d91"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ymtdzzz/otel-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c9d9ae2bb7468977dc402348ebee1b3987eb7310e64982f308806140de2e8cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5da8c282d21e9d9eb624caeffc87a66a1baa9d6171966638a03b73a8e018a4b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "640712e6d3aead633f99fdce15bdadff3a3b8b457f98a3d2986a5575b683ea04"
    sha256 cellar: :any,                 x86_64_linux:  "3065fc17c57aca1d0e3f29e419275a62efbd73bf1cfec94caeeee67e385b4daf"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/otel-tui --version")

    output = shell_output("#{bin}/otel-tui --invalid-flag 2>&1", 1)
    assert_match "unknown flag: --invalid-flag", output
  end
end
