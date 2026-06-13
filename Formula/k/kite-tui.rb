class KiteTui < Formula
  desc "Terminal reader for Kagi News"
  homepage "https://github.com/KernelFreeze/kite-tui"
  url "https://github.com/KernelFreeze/kite-tui/archive/refs/tags/0.1.1.tar.gz"
  sha256 "0a1946783888fb51b6e6f8306e5953b344ad7d96a8eae58f0c101f1a4e3e4cd1"
  license "MIT"
  head "https://github.com/KernelFreeze/kite-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7c4644fd6e7fcc0c77dadc8b20864ef6c1d72d9f9dae060415b04bf95d2083b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ebd3436075ae49ef1981f30838d175b7c19c8e18f35f4ce5b21a1826af185c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03e4dcc51c19a9f2453f46a3bdcc5bfa30a4449a7e0fbe9fc9791717a81a9776"
    sha256 cellar: :any,                 arm64_linux:   "3355274d01b7714f0f111ea7aff88f467b8f558c070493073a25c696ccb25bd8"
    sha256 cellar: :any,                 x86_64_linux:  "566a47e27e924a0c2cbc56d3bbc485317b188599fb4481d5f9479fa676dd0787"
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
