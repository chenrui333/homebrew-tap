class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "dbaac1beeca8cda7f82e1d85f089f259821c9f60099fc88f62eda0e1db0fc3bf"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fce40dbd97525e7a95dfab9a5797ad2503466c7d85b334cdca1492404754d9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09dd4e2941599d60a9323f945be6a18179df766a2c185b942168fade783b9c5b"
    sha256 cellar: :any,                 arm64_linux:   "99a524cc97ed53d92a3ef4d0afe4add229ed125edaaf95e2c5bf1e60a2f65a82"
    sha256 cellar: :any,                 x86_64_linux:  "95bcba4483c263a336719ec8fc4c762240082d319a95b113fedc77979a8a0d82"
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
