class Xpdig < Formula
  desc "Dig into Crossplane traces via TUI"
  homepage "https://github.com/brunoluiz/xpdig"
  url "https://github.com/brunoluiz/xpdig/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "491f23bcb5392921162dc95df79b40016347cb44daf46ebb4148073046d3dc84"
  license "Apache-2.0"
  head "https://github.com/brunoluiz/xpdig.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04becdf9231e66b093c7b08a89c336a8756760b19fb6771ccc186b2a74aca8ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04becdf9231e66b093c7b08a89c336a8756760b19fb6771ccc186b2a74aca8ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04becdf9231e66b093c7b08a89c336a8756760b19fb6771ccc186b2a74aca8ee"
    sha256 cellar: :any,                 arm64_linux:   "b4718e7a0e0d88225d4b4c156304321152d866f546f5b3e57d3ba9dce3a1da86"
    sha256 cellar: :any,                 x86_64_linux:  "3a29b4276a9098217f5feb22b19ab2151499c67333a3024ffb4d1a7d102cdeee"
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
