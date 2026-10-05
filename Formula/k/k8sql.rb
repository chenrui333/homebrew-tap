class K8sql < Formula
  desc "Query Kubernetes clusters using SQL"
  homepage "https://github.com/ndenev/k8sql"
  url "https://github.com/ndenev/k8sql/archive/refs/tags/0.2.4.tar.gz"
  sha256 "459e6e718e783b3b2302b13590c23427d6c285ccf54dc1affca9d9f1b4073f0a"
  license "BSD-3-Clause"
  head "https://github.com/ndenev/k8sql.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95f9521aed78d2e00dd9e8294719c31e79748615164449ba6ef9bae839130569"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f243ee38acb74df0ca94045ed2ab6c6ecec7914149b35f8c78a967569dcd438d"
    sha256 cellar: :any,                 arm64_linux:   "161bf2db5c534bef965b0ee05cc7e67523b9f85e74951ab2be9d7ea64d085a58"
    sha256 cellar: :any,                 x86_64_linux:  "2dd0b48415d5e60cd9b8fb671745a3fa6d7c49c2e241781c5e25844eb63186f2"
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
    assert_match version.to_s, shell_output("#{bin}/k8sql --version")
    output = shell_output("#{bin}/k8sql -q 'SELECT * FROM pods' 2>&1", 1)
    assert_match(/kube|config|connect/i, output)
  end
end
