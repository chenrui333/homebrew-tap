class Nhost < Formula
  desc "Developing locally with the Nhost CLI"
  homepage "https://docs.nhost.io/development/cli/overview"
  url "https://github.com/nhost/cli/archive/refs/tags/v1.29.7.tar.gz"
  sha256 "3c3e03c435eb19e3cd90116023a3b7f7eeae7fd45e2b06258d70e6aadb507e8a"
  license "MIT"
  head "https://github.com/nhost/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1763fd49e89802629ef4e24f6e0310679d8ea2ed230a889a261dbf8983386da4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3186ef39653ce3eab23df5ea27a98406122ff62e050b3d39e1e4f007bc1fbbfb"
    sha256 cellar: :any_skip_relocation, ventura:       "ba2aebf60ecfeec6143c9e18a5c5028fca460d9d0267f6c2d579d9935403eb29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fe2a266305e08ce018275ba6e50dc67c4c76602ea95281d3167e3c19307bad9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nhost --version")

    system bin/"nhost", "init"
    assert_path_exists testpath/"nhost/config.yaml"
    assert_match "[global]", (testpath/"nhost/nhost.toml").read
  end
end
