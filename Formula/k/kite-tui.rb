class KiteTui < Formula
  desc "Terminal reader for Kagi News"
  homepage "https://github.com/KernelFreeze/kite-tui"
  url "https://github.com/KernelFreeze/kite-tui/archive/refs/tags/0.1.1.tar.gz"
  sha256 "0a1946783888fb51b6e6f8306e5953b344ad7d96a8eae58f0c101f1a4e3e4cd1"
  license "MIT"
  head "https://github.com/KernelFreeze/kite-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be75f23600d84037d50e155ff7d2fa1636ad87754dfea60a3398e6e20fab54a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d334e8998d2052ade1624c2e9973e931e25b0e55473678ef786ff720b8aee79b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01d208a7578b19d2079c411da1e837c751aab6d74ed543e16fe6349bdc4d8121"
    sha256 cellar: :any,                 arm64_linux:   "98586973ac78fa91b2112110f0cb652eb7eb2958589fcd703c398560c9197483"
    sha256 cellar: :any,                 x86_64_linux:  "82cdd97ca07d7e288444ec090e18f004c93c44ddd530b3e1b5d29bd925cfb1a9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "kite #{version}", shell_output("#{bin}/kite-tui --version")
    output = shell_output("#{bin}/kite-tui --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
