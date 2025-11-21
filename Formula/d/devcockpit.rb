class Devcockpit < Formula
  desc "TUI system monitor for Apple Silicon"
  homepage "https://devcockpit.app/"
  url "https://github.com/caioricciuti/dev-cockpit/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "a1ce6d16d46da379d88ca579f24d9d16c542b047c6dd3005637c2d45cf7c49e7"
  license "MPL-2.0"
  head "https://github.com/caioricciuti/dev-cockpit.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83d2c3274cee48abef30e27bd168043bcc40a9e006531c5b127faa271911fa78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77a76824d20dbd4e083f1e78eddd83b2dc43a0b6ca3246a0df44f52786ed52d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3138a8bbb3b0a737c479aa61c598f3c73e5ff4b9e96eccf06408e34ff9cf879"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f8230ca6f61af3ba0a70d779af1c16a92cca8720484c7c15311556bdaf8956d"
  end

  depends_on "go" => :build
  depends_on arch: :arm64

  def install
    ENV["CGO_ENABLED"] = "1"

    # Workaround to avoid patchelf corruption when cgo is required (for go-zetasql)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    cd "app" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/devcockpit"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/devcockpit --version")
    assert_match "Log file location:", shell_output("#{bin}/devcockpit --logs")
  end
end
