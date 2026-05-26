class K8sql < Formula
  desc "Query Kubernetes clusters using SQL"
  homepage "https://github.com/ndenev/k8sql"
  url "https://github.com/ndenev/k8sql/archive/refs/tags/0.2.4.tar.gz"
  sha256 "459e6e718e783b3b2302b13590c23427d6c285ccf54dc1affca9d9f1b4073f0a"
  license "BSD-3-Clause"
  head "https://github.com/ndenev/k8sql.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/k8sql --version")
    output = shell_output("#{bin}/k8sql -q 'SELECT * FROM pods' 2>&1", 1)
    assert_match(/kube|config|connect/i, output)
  end
end
