class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "7252ae4d85d77afd42370cdd6d1fae500dbfa74411ff9036e6d2116f4f4d11e1"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a3e9941773ffdf51d95bb6ca3a86cbd3c685fd43484936a6515b15f73171894"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29241158205abaf3dd23b07beb9934e8c1838d1bfa3d50724419a54e584d0bdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fd327231710caecd367ca9d8e45389da19b63010936e9ecd2a0062307542722"
    sha256 cellar: :any,                 arm64_linux:   "355f8aff692136085d3ddc81dcd1e726ab43e653d0a463c964df736ad05f66aa"
    sha256 cellar: :any,                 x86_64_linux:  "8ce3949fbbc1fb2f6427da3059a857c4bf206c96311c8d7e875a2f9611dafcab"
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
