class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "4cd40d6bc08e69a880c924c290af90ad59b48211797dc8dc9daa586c362a2e90"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6bed8efbe6838785de463dcf168b43b9882b9ce869c12e94f786e7853b5fbbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e60c1aa1a657a3bd9d4724feda4c41a259d7a05192090f0edc6b1f30c5e7ef0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5df0518a9ab90228af0f7d7c76b08fb0dc2e9b38c05a539df63da6a12665d3d1"
    sha256 cellar: :any,                 arm64_linux:   "76ed920e0e387a291e6ae798e7054d6c0c057620ba2dc3f986f89c517ce90212"
    sha256 cellar: :any,                 x86_64_linux:  "58c2a4d0472052c63cbf1a0f3c1ea4d7b401db250c01c45e2ae7b4f1c45362c2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4n --version")
    assert_match "Error: kubeconfig file not found", shell_output("#{bin}/b4n 2>&1", 1)
  end
end
