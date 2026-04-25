class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "510f8f2062f89f9a6dc3dbf6055291f3f04d7707a8214115ca10db20d15bded9"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c339be913611cadd184918869859e01d4768d8cc6563bc80205b448629e94c70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c339be913611cadd184918869859e01d4768d8cc6563bc80205b448629e94c70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c339be913611cadd184918869859e01d4768d8cc6563bc80205b448629e94c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fa85d6701bcb8be49970485c81c9870a3049897000f8fe6556225e69bb2c2f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "311bf4007c2e7d6907e18eb74838e2de2e8f1ce4db92a1ead37649149fcd3821"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gpk"
  end

  test do
    assert_match "gpk #{version}", shell_output("#{bin}/gpk --version")
  end
end
