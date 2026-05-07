class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.80.16.tar.gz"
  sha256 "e43af48f790e0182300e416fa13a8e2b2c2c07deb2b73cbef8e0dc5505afc24e"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9d0a30ece68c4f8c2f1b79328db2b1a58e21addb9419540178b894fa45a0c08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9d0a30ece68c4f8c2f1b79328db2b1a58e21addb9419540178b894fa45a0c08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9d0a30ece68c4f8c2f1b79328db2b1a58e21addb9419540178b894fa45a0c08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a69c4794f60681725252f61e55c4b3e593969c88aa0ee95c5cd92320d9119326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e1c0df7a6aa67b2201597be961fe6320fc9524a19ce4fdcb15b11d20090a55d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
