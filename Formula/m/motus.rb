class Motus < Formula
  desc "Dead simple password generator"
  homepage "https://github.com/oleiade/motus"
  url "https://github.com/oleiade/motus/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "ac46d6e152293edf6aa30aaf40fcb8250429127f1ce8c59da3022dcedaa94633"
  license "AGPL-3.0-only"
  head "https://github.com/oleiade/motus.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2afb4b13022fa3d23354b29781927170715dd44b8e6aa89dcf8831d4574ab5ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eeb8425e0531730fef5a132db4185171e619e26a6891453d255db351e2497573"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b05d0db6986891539519fa8d35e1e7888a9c1d44553158eb5a6472b6d925ab4"
    sha256 cellar: :any,                 arm64_linux:   "d8b50a7934c142bd5c03a9cee43a5c41c7ed60e6561877e6c7c13679c3f0ac1b"
    sha256 cellar: :any,                 x86_64_linux:  "df6bfc3e9751d4e2488b720488c8fdc6bee1c66c6f62a2a25af1727ed74c4218"
  end

  depends_on "rust" => :build

  def install
    # The clipboard feature pulls in GUI-specific X11 clipboard support on Linux.
    system "cargo", "install", *std_cargo_args(path: "crates/motus-cli"), "--no-default-features"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/motus --version")

    output = shell_output("#{bin}/motus random -c 2 2>&1", 2)
    assert_match "The number of characters must be between 8 and 100", output
  end
end
