class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "6abce692d5c04578afc2eceddb43079a7b31618953865f6edec4083fb7b04fff"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44fd76b5966e33e0bd3f0ae63e1350f362024996b3d423ab93b15ae1e1609a48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82626ca3090a54133215a6e1ec7234c6a0ac3932c647a54c3dd9d788c7c16ace"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e20cf6cede16ccd0bfc296d162ce665e70e920cf973356e4f125d5bf79cfcecb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caad106a6c3374ff534924f763f0aea36e1c54b49197fa95a98fd6770256139b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90e0ee1575713d9e705f746df9924ff8e8dabd2d2b9990d7292fd30db6fb7bd5"
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
