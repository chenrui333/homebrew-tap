class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "7252ae4d85d77afd42370cdd6d1fae500dbfa74411ff9036e6d2116f4f4d11e1"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ceff0fae38a6332c9b22960e2783fccfb3a88ccabeafc6492904628bd6af4dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cfee6462ca1c9a3c30bcbebda2d76bbf3beabcb065a7561394d74026d927feb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a59c64e86ee5df5f42e543ff5bbff37e91a91e423022a37ca34f6446e0d36ab"
    sha256 cellar: :any,                 arm64_linux:   "49831049bdc30db7ce41a2794b6459d3508a5a0fa37d4b20d52a169ad5e546ca"
    sha256 cellar: :any,                 x86_64_linux:  "24eca30df6928035bb1ae5deda2fc9369212f213d47bf2a18afe2caf62e6e4f2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
