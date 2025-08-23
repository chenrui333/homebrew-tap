class Typtea < Formula
  desc "Minimal terminal-based typing speed tester"
  homepage "https://github.com/ashish0kumar/typtea"
  url "https://github.com/ashish0kumar/typtea/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "d2c5580b46c39189b28de3fde92ae51a811efc063a1d819bbc2db359a7c34f98"
  license "MIT"
  head "https://github.com/ashish0kumar/typtea.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "680f0bc7b600ee6c3d8c36eb77b450101d9cb72064c1c4f45d65177c34e428ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e06efd66216b8a4224aff7754e843b4a2503b67e9d3a6c96ff50b9f27e722be"
    sha256 cellar: :any_skip_relocation, ventura:       "35acbb6cec00e001ea128c7f8105a9f06816f9cb83d64ffa00640038e94675c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24bafa9f239461bf93cb00db472fd8a8684478143d13067c137c144d678a5ba0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ashish0kumar/typtea/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/typtea version")

    assert_match "python", shell_output("#{bin}/typtea start --list-langs 2>&1")
  end
end
