class Toast < Formula
  desc "Terminal-based text editor with integrated language servers"
  homepage "https://github.com/paradise-runner/toast"
  url "https://github.com/paradise-runner/toast/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "9f2123cca3082f410e7b69ef9866d457ce97d74fab03247dd9a1f74159d2eeb5"
  license "MIT"
  head "https://github.com/paradise-runner/toast.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a98b8c831b0c4aaae8e3a91ad8827bbd49e5630d3bb4c0a7b8b7b381ba459d17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "592464441a91b8ad9e0260d2db7313ed5629cdc1d191fe61ae0e0fe33eb1aa93"
    sha256 cellar: :any,                 arm64_linux:   "f101c800fc06e162f22e461339a0f2ada35339d6cd416577fe685af1c950c05b"
    sha256 cellar: :any,                 x86_64_linux:  "2b4e26819fe1107709f6782e43a0f8f38dd2e21fd5db8eef8056ee80d6c94bb0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/toast"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toast --version")

    output = shell_output("#{bin}/toast migrate-theme vscode #{testpath}/missing.json 2>&1", 1)
    assert_match "reading VSCode theme", output
  end
end
