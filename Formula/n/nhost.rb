class Nhost < Formula
  desc "Developing locally with the Nhost CLI"
  homepage "https://docs.nhost.io/development/cli/overview"
  url "https://github.com/nhost/cli/archive/refs/tags/v1.31.1.tar.gz"
  sha256 "2d28fd4079b807d5619f9a748860fc81329dc65470785dc274dc4543e58af7f2"
  license "MIT"
  head "https://github.com/nhost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c9b02e62127c19b5bd6df6d48b90135a2ff98679037fc1ed0f1bf68a4aa42e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eaf2b58290ec6bb58ca0aa45de9f9f916694df0fc5d059d6105b7f90f6846d4"
    sha256 cellar: :any_skip_relocation, ventura:       "7c19d9d73bc5d5d1b3313b6066905ebc8f9df34f0cb596564439b952db842538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8889612d403e0f60a0a67593ec88f7448597fee13bb740a01dc94023f72eba59"
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
