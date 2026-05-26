class K8sql < Formula
  desc "Query Kubernetes clusters using SQL"
  homepage "https://github.com/ndenev/k8sql"
  url "https://github.com/ndenev/k8sql/archive/refs/tags/0.2.4.tar.gz"
  sha256 "459e6e718e783b3b2302b13590c23427d6c285ccf54dc1affca9d9f1b4073f0a"
  license "BSD-3-Clause"
  head "https://github.com/ndenev/k8sql.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "797da03166b2c4f6af3700bb8c7d2749628de5c3a88368460490a7e0fcda73c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b082eb60513ea6897241691bda8a3d302ef7b7d3bb760ae454cebd8aae315568"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "446b9efa16f993ba0127d54166575eac06ca4edc04c95c7277099a5cf73fade3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb849bffec9b30df9ed6e7b8184d7da0ae2c0977ebf4a50458c8e7cc354b029e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "228bd113074c85e5dde61cb3a82829062e969b44150b1f93aedd035e99bca3a5"
  end

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
