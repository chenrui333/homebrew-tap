class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "97c4d0f5a3f88e0ea5612de76dc0da1777b6df4eb6b517537c4cd974479caeec"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b59572332140d8425ae38d9db3480276141bc645575a2d8fe39263fb3996ec23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3869588a5086d8321490bb1fff758a7ce61747aa28694da7d26403163e6fd592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1e8585d61c5a6d26538b4e1c5b7f653915fb23c30093fa6feedf7dd053b568a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e510fd68257a1de3628ef6cbc7d17010f3cbb10a11238f8603ad43605f751c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2529038c1eaa8888a1aa6c5ff932363fca23be3bfc1c48a7c73407ce6aaf230"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4n --version")
    assert_match "Error: kube config file not found", shell_output("#{bin}/b4n 2>&1", 1)
  end
end
