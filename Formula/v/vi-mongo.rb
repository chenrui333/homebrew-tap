class ViMongo < Formula
  desc "MongoDB TUI designed to simplify data visualization and quick manipulation"
  homepage "https://github.com/kopecmaciej/vi-mongo"
  url "https://github.com/kopecmaciej/vi-mongo/archive/refs/tags/v0.1.34.tar.gz"
  sha256 "8c2686b4d3890e90be2bb80326d93d1081ed4078deaae63b8d04be0e5dba1c75"
  license "Apache-2.0"
  head "https://github.com/kopecmaciej/vi-mongo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e844ade72c648b9b588e9b1562f2cb3389aab4735e8f8b21a8b37505c1a0f9d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e844ade72c648b9b588e9b1562f2cb3389aab4735e8f8b21a8b37505c1a0f9d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e844ade72c648b9b588e9b1562f2cb3389aab4735e8f8b21a8b37505c1a0f9d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b2667be70b311e0999598d08d58825ee50dd3ee5e7fa72f1e036ab57cd6e504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1928dda34efae493f9c50f745fade32824e0e208d16cad1e93bae100a93d0c43"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kopecmaciej/vi-mongo/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vi-mongo --version")
    assert_match "No connections available", shell_output("#{bin}/vi-mongo --connection-list")
  end
end
