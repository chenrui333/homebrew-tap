class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "c016fa33229c5be961d0dfe9ab23aede7404c184f59135f85f11af685c43d973"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9662d944e4be05eab4e70d02ca6757bfb23b2fa3b6c5018883fe334d4d868023"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3a12edcfef5c45915765a5eb442bbb84165ba1b1176696784e59352f29a8b69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e31db0e3bb6f1f8c0a9ddbba04d0d8eb32be4da3625ca125051cc67fe750cf41"
    sha256 cellar: :any,                 arm64_linux:   "e85d6e558316c85e59f6f4fc1848b19569c027e75363ba7a1c6b58dfe3d51af3"
    sha256 cellar: :any,                 x86_64_linux:  "ca40c529579595bc383c3dad5c4c44a9286fd19f07b831e3bd35c89e3b0e8cc9"
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
