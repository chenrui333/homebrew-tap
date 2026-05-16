class Xpdig < Formula
  desc "Dig into Crossplane traces via TUI"
  homepage "https://github.com/brunoluiz/xpdig"
  url "https://github.com/brunoluiz/xpdig/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "2340fcda2bc11ed812a1cdd4ba67c1a7494470c1d3b13b9d7fbafe490302d2b4"
  license "Apache-2.0"
  head "https://github.com/brunoluiz/xpdig.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c79881fb7a5564cdc7c15e3bac26591bd8bccd1170c872f254dcc69f721a9e78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c79881fb7a5564cdc7c15e3bac26591bd8bccd1170c872f254dcc69f721a9e78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c79881fb7a5564cdc7c15e3bac26591bd8bccd1170c872f254dcc69f721a9e78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8caeea7fc0c80dc3821813831f44ffc194fc6fbb4991008527b538a9d6e7c3ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dacbe7abaedc67c8e557de0df4c4eb31f379ac6687a51babc62de528c8d4d9c"
  end

  depends_on "go" => :build
  depends_on "crossplane"

  def install
    ENV["CGO_ENABLED"] = "1"

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/xpdig"
  end

  test do
    version_output = shell_output("#{bin}/xpdig version")
    assert_match version.to_s, version_output

    # Concrete negative-path command to prove the binary handles bad input cleanly.
    invalid_output = shell_output("#{bin}/xpdig not-a-real-command 2>&1", 3)
    assert_match "No help topic for 'not-a-real-command'", invalid_output
    refute_match "panic:", invalid_output
  end
end
