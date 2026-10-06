class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "dbaac1beeca8cda7f82e1d85f089f259821c9f60099fc88f62eda0e1db0fc3bf"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e698a1e00467d5ba1e32f455fdb91ee2675771c89359e6d07070b04e649c412"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa4a3506b8c18f724f73f9b7a4c4e1fa8af12f4be016bfbf25d1f7d21427c93f"
    sha256 cellar: :any,                 arm64_linux:   "e96fd33fd2308c425a42b2d028b781431b75e1f2a8b324e889e4b805d543577c"
    sha256 cellar: :any,                 x86_64_linux:  "360357dedd78c01397c6efb6996d72efcc6966c856257cae8e20add975942eac"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4n --version")
    assert_match "Error: kubeconfig file not found", shell_output("#{bin}/b4n 2>&1", 1)
  end
end
