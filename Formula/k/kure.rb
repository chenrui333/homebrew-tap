class Kure < Formula
  desc "CLI password manager with sessions"
  homepage "https://github.com/GGP1/kure"
  url "https://github.com/GGP1/kure/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "e9e1fdd94fa152c0707e1526424d075e29840e5a53ad7b8b81ff28210fe98a48"
  license "Apache-2.0"
  head "https://github.com/GGP1/kure.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "435986ffb19fd6aae6bb90dcd949131d1f29d1b4045ae3a3b46584bbd0aa490f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "435986ffb19fd6aae6bb90dcd949131d1f29d1b4045ae3a3b46584bbd0aa490f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "435986ffb19fd6aae6bb90dcd949131d1f29d1b4045ae3a3b46584bbd0aa490f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef79f2a234ad96affcfcd374bfcdb5db8905a8b80dd079fc2771c2df4d580e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73247f2c2f8b605733164585b3eea475e4d5d8f9e43f729a91d78aef9dbfb7c0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"kure", "--version"
    assert_match "Password:", shell_output("#{bin}/kure gen -l 20")
  end
end
