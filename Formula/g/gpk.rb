class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "fac313ec21375c10d462b1df0a1375cda948429c9e443243d5b7835a6a957af0"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdc7806163c41fdda460d5a4296f1b59b3e2bbedd4e1aa4269b5e8cb3b7e67bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdc7806163c41fdda460d5a4296f1b59b3e2bbedd4e1aa4269b5e8cb3b7e67bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdc7806163c41fdda460d5a4296f1b59b3e2bbedd4e1aa4269b5e8cb3b7e67bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e4b188b461386d471ce0d3d3e26106444389ac22ca5dd0e9cfa80ef944ead70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2139e7770ed91bb94aa5437ebd8fe9ae898e3e081e8b6be7857d0278d77e272d"
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
